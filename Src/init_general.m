% Forward Converter (Power Converter Design Course)

%% ---------- Converter Electrical Specifications ----------
% Input voltage in [V] (input voltage should be between 24 V and 29 V)
% Minimum input voltage
V_g_min = 24;
% Maximum input voltage
V_g_max = 29;
% Nominal input voltage
V_g_nom = (V_g_min+V_g_max)/2;
V_g = 24;

% Output voltage in [V]
V_out = 5;

% Maximum output voltage peak-to-peak ripple in [V]
V_out_pp_ripple_max = 50e-3;

% Maximum output current in [A]
I_out_max = 10;

%% Chosen parameters by the designers
% Switching and sampling frequency 
% Sampling values are to be used in digital contoller design.
f_sw = 100e3;
f_sampling = f_sw;
% Switching and sampling period in [s]
T_sw = 1/f_sw;
T_sampling = T_sw;
% Minimum on time for switches in [s]
T_on_min = 1e-6;



%% ---------- Chosen and Calculated Parameters and Values ----------
% Targeted efficiency
eta = 0.8;


% Corssover frequency
f_co = f_sw/10;

% Simulation duration
t_sim = T_sw * 1000;
t1 = t_sim / 4;
t2 = t_sim / 2;
t3 = t_sim * 3 / 4;

% Maximum duty cycle (when the transformer's core is being magnetized)
% Choosing D_max = 0.45, allows us enough margin in each switching period
% so that the transformer flux can be reset.
D_max = 0.45;

% Magnetizing inductance
L_m = 5e-3;
% Core loss resistor;
R_m = 1e12;
% Leakage inductance referred to the primary
L1 = 1e-18;
% Copper resistance of windings reffered to the primary
R1 = 100e-4;
% Transformer turns and the turns ratio (Ns/Np)
% Primary number of turns
% N_p = 25;
% Secondary number of turns
% N_s = 15;
% Turns ratio
% n = N_s / N_p;
% n = v_out/(eta*v_g_min*D_max);
n = 0.5;

% Minimum duty cycle
D_min = v_out/(eta*v_g_max*n);

% DC value of the duty cycle (Quiescent operation point duty cycle)
D = v_out/v_g/n;

%% LC Output Filter Passive Components Values
% Minumum value for the output filter capacitor
% C = 100e-6;
C = 220e-6;
% Maximum value for the output capcitor ESR
R_ESR = 1/(2*pi*f_co*C);
% Output inductor maximum peak-to-peak current 
delta_i_L_pp = delta_v_out_max/R_ESR;
% output inductor
L = 22e-6;
R_load = 1;