classdef (Enumeration) ElevatorStatus < Simulink.IntEnumType
% ELEVATORSTATUS - Enumeration class for the status of an elevator car in
% the sf_elevator example.

%   Copyright 2010-2012 The MathWorks, Inc.
    enumeration
        IDLE(0)
        BUSY(1)
        EMERG(2)
    end 
end