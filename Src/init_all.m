clc
clear
close all

%% --- Load General Parameters ---
init_general;

%% --- Select Controller ---
controller_type = "analog";
% controller_type = "digital";

switch controller_type
    case "analog"
        c_type = 0; 
        init_analog_controller;
    case "digital"
        c_type = 1;
        init_analog_controller; % This is needed to use c2d function.
        init_digital_controller;
    otherwise
        error('Unknown controller type');
end

close all