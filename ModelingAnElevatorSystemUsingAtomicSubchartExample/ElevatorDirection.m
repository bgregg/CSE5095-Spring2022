classdef (Enumeration) ElevatorDirection < Simulink.IntEnumType
% ELEVATORDIRECTION - Enumeration class for the direction of motion of
% elevator cars in the sf_elevator example.

%   Copyright 2010-2012 The MathWorks, Inc.
    enumeration
        MOVE_IDLE(0);
        MOVE_UP(1);
        MOVE_DOWN(2);
    end
end