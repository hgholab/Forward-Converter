% Forward Converter (Power Converter Design Course)

%% ---------- Converter Electrical Specifications ----------
% Input voltage in [V] (input voltage should be between 24 V and 29 V)
% The controller is designed for the lowest input voltage. (???)
v_g_min = 24;
v_g_max = 29;
% v_g_mean = (v_g_min+v_g_max)/2

% Output voltage in [V]
v_out = 5;
V = v_out; % The same value but used in the transfer functions

% maximum voltage ripple
delta_v_out_max = 50e-3;

% What this is (???)
delta_i_out = 5;

% Maximum output current in [A]
i_out_max = 10;



%% ---------- Chosen and Calculated Parameters and Values ----------
% targeted efficiency
eta = 0.8;
% Sampling values are to be used in digital contoller design.
% Switching and sampling frequency 
f_sw = 100e3;
f_sampling = f_sw;
% Switching and sampling period
T_sw = 1 / f_sw;
T_sampling = T_sw;

% Corssover frequency
f_co = f_sw/10;

% Simulation duration
t_sim = T_sw * 1000* 5;

% Maximum duty cycle (when the transformer's core is being magnetized)
% Choosing D_max = 0.45, allows us enough margin in each switching period
% so that the transformer flux can be reset.
D_max = 0.45;

% Magnetizing inductance
L_m = 5e-3;
% Core loss resistor;
R_m = 1e12;
% Leakage inductance referred to the primary
L1 = 0;
% Copper resistance of windings reffered to the primary
R1 = 0;
% Transformer turns and the turns ratio (Ns/Np)
% Primary number of turns
% N_p = 25;
% Secondary number of turns
% N_s = 15;
% Turns ratio
% n = N_s / N_p;
n = v_out/(eta*v_g_min*D_max);

% Minimum duty cycle
D_min = v_out/(eta*v_g_max*n);

% DC value of the duty cycle (Quiescent operation point duty cycle)
D = v_out/v_g_max/n;

% Output filter passive components values
% Minumum value for the output filter capacitor
% C = 100e-6;
C = delta_i_out/(2*pi*f_co*delta_v_out_max);
% Maximum value for the output capcitor ESR
R_ESR = 1/(2*pi*f_co*C);
% Output inductor maximum peak-to-peak current 
delta_i_L_pp = delta_v_out_max/R_ESR
% output inductor
L = 25e-6;
R_load = 1;

%% Choosing the Controller Type
% This boolean variable chooses between analong and digital controller.
% The value 0 means that the converter is using the analog controller and
% the value 1 means that the converter is using the digital controller.
controller_type = 0;









