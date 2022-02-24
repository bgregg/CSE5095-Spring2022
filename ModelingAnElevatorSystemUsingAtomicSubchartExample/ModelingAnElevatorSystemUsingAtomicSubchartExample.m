%% Model an Elevator System by Using Atomic Subcharts
% This example shows how to model a two-car elevator system by using linked
% atomic subcharts in Stateflow(R). The elevator system consists of a
% Simulink(R) model and a user interface (UI). The model contains two
% Stateflow charts: 
%
% * Elevator System models the core logic that delegates incoming requests
% from the UI to the nearest available elevator car. This chart contains a
% pair of atomic subcharts that implement identical logic for the cars.
% * UI Controller processes information from the Elevator System chart and
% updates the UI display. In this chart, each atomic subchart determines
% when to move an elevator car and when to open its doors.

% Copyright 2006-2021 The MathWorks, Inc.

%% 

set_param(0,'ExportBackgroundColorMode','white')
model ='sf_elevator';
load_system(model);

% Delete all annotations at the top level of the model
ah = find_system(model, 'FindAll', 'on', 'type', 'annotation');
for i = 1:length(ah)
   ao = get_param(ah(i), 'Object');
   ao.delete;
end

open_system(model);

%% 
% At the start of simulation, the model opens the UI. The UI shows two
% elevator cars that can stop at nine floors. At the bottom of the UI, two
% yellow rectangles represent the interior of the elevator cars. While the
% example is running, you call an elevator car, request a stop at a floor,
% or set off a fire alarm by clicking the buttons on each floor hallway and
% inside the elevator cars. The UI responds by modifying the input values
% and triggering input events for the Elevator System chart.
%
% <<../sf_elevator_gui.png>>

%% Manage Requests from User Interface
% The Elevator System chart consists of three parallel subcharts. Each of
% these subcharts manages a queue of requests from the UI:
%
% * The |Elevator_Manager| subchart implements the main control logic for
% the elevator system. This subchart manages the hall queue, which holds
% all the requests that are generated when you click a button in one of the
% floor hallways. The subchart processes these requests and delegates them
% to one of the elevator cars, depending on availability and proximity to
% the request.
% * |Elevator_A| and |Elevator_B| represent the logic for the two elevator
% cars. Each car has its own queue that holds all of its floor requests.
% Floor requests are generated when you click a button inside the elevator
% car or when the |Elevator_Manager| delegates a request from the hall
% queue to the car.

open_system([model '/Elevator System']);

%% Reuse Logic Patterns by Using Atomic Subcharts
% The elevator cars use identical logic to process their individual request
% queues. The Elevator System chart models their behavior by using linked
% atomic subcharts from a
% <matlab:openExample('stateflow/ModelingAnElevatorSystemUsingAtomicSubchartExample','supportingFile','sf_elevator_lib.slx')
% library model>.

model_lib ='sf_elevator_lib';
load_system(model_lib);
open_system([model_lib '/Elevator']);

%%
% In the library model, the chart |Elevator| implements the logic for a
% generic elevator car. To program the subcharts |Elevator_A| and
% |Elevator_B| so that they control the appropriate car, you map data and
% events in each subchart to the corresponding data and events in the main
% chart. For instance, for |Elevator_B|:
%
% * The subchart input |floor_request| maps to the chart input
% |CarB_floor_request|.
% * The subchart output |position| maps to the chart output
% |B_position|.
% * The subchart output |doorOpen| maps to the chart output |doorBOpen|.
% * The subchart event |CAR_CALL| maps to the chart event |CAR_CALL_B|.
% 
% To see the mappings for each atomic subchart, right-click the subchart
% and select *Subchart Mappings*.
%
% <<../sf_elevator_car_mappings_dialog.png>>

%%
% To control the UI display of each elevator car, the UI Controller chart
% uses two atomic subcharts linked from a
% <matlab:openExample('stateflow/ModelingAnElevatorSystemUsingAtomicSubchartExample','supportingFile','sf_gui_elevator_controller_lib.slx')
% library model>.

open_system([model '/UI Controller']);

%% 
% For more information about using atomic subcharts to encapsulate and
% reuse logic, see <docid:stateflow_ug#bsbm40z-2>.

%% Incorporate Atomic Subcharts in Your Design
% The model in this example is a redesigned version of an
% <matlab:openExample('stateflow/ModelingAnElevatorSystemUsingAtomicSubchartExample','supportingFile','sf_elevator_old.slx')
% older model> that does not use atomic subcharts. The original model uses
% separate subcharts to manage floor requests (subcharts |Elevator_A| and
% |Elevator_B| of the Elevator System chart) and to control the UI display
% of elevator cars (subcharts |CarA_Controller| and |CarB_Controller| of
% the UI Controller chart). In each case, the subcharts are nearly
% identical copies of one another. They differ only in the names of the
% data and events that they use.
%
% To convert the duplicate subcharts to atomic subcharts, first make a
% library atomic subchart out of one of the subcharts. Then use linked
% instances of this library to replace the duplicate subcharts. For
% example, consider the duplicate elevator car subcharts of the Elevator
% System chart. These subcharts call several functions and local variables
% that are defined in the |Elevator_Manager| subchart. Before creating an
% atomic subchart, you must make these subcharts independent and
% self-contained units.

model_old ='sf_elevator_old';
load_system(model_old);
open_system([model_old '/Elevator System']);

%%
% 1. Migrate these functions from the |Elevator_Manager| subchart into the
% parent chart:
%
% * |exists_in_queue|
% * |deregister|
% * |dequeue|
%
% Rename these functions to distinguish them from the functions inside the
% elevator car subcharts. 
%
% 2. Using the Model Explorer, migrate these variables from the |Elevator_Manager| subchart into the
% parent chart:
% 
% * |hall_call_queue|
% * |hall_call_status|
%
% 3. In the Elevator System chart, set the *Export Chart Level Functions*
% chart property to |true|. For more information, see
% <docid:stateflow_ug#f9-59271>.
%
% 4. Modify the |Elevator_Manager| and |Elevator_A| subcharts to use the
% migrated functions and variables.
%
% 5. Create a library atomic subchart from the |Elevator_A| subchart, as
% described in <docid:stateflow_ug#bsbm400-25>. 
%
% 6. To enable the atomic subchart to pass the position of the elevator car
% to the containing chart, change the *Scope* of the subchart data
% |position| from |Local| to |Output|.
%
% 7. Replace the two elevator subcharts with the linked atomic subchart.
% For each linked atomic subchart, map data and events to the parent chart.
% For more information, see <docid:stateflow_ug#bscpeun>.
