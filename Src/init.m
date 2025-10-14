% Forward Converter Controller Design

%% ---------- Converter Electrical Specifications ----------
% Input voltage in [V] (input voltage should be between 24 V and 29 V)
% The controller is 
vg = 27;
% Output voltage in [V]
v_out = 5;
% Max output current in [A]
i_out_max = 10;

%% ---------- Chosen and Calculated Parameters and Values ----------
% Sampling values are to be used in digital contoller design 
% Switching and sampling frequency 
f_sw = 100e3;
f_sampling = f_sw;
% Switching and sampling period
T_sw = 1 / f_sw;
T_sampling = T_sw;

% This boolean variable chooses between analong and digital controller.
% The value 0 means that the converter is using the analog controller and
% the value 1 means that the converter is using the digital controller.
controller_type = 0;



