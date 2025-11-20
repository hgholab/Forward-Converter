% Forward Converter (Power Converter Design Course)
%% --- Converter Electrical Specifications ---
% Input voltage (input voltage is between 24 V and 29 V)
% Minimum input voltage
V_g_min = 24;
% Maximum input voltage
V_g_max = 29;
% Nominal input voltage
V_g_nom = (V_g_min+V_g_max)/2;
% Output voltage
V_out = 5;
% Maximum output voltage peak-to-peak ripple
v_out_pp_ripple_max = 50e-3;
% Maximum output current
I_out_max = 10;
% Nominal output current
I_out_nom = 8;
% Minimum efficiency 
eta_min = 0.7;
% Targeted efficiency
eta_t = 0.8;
%% --- Chosen and Calculated Parameters and Values ---
% Switching and sampling frequencies
% Sampling values are to be used in digital contoller design.
f_sw = 200e3;
f_sampling = f_sw;
% Switching and sampling periods
T_sw = 1/f_sw;
T_sampling = T_sw;
% Simulation duration
% We observe 1000 switching period of the converter.
t_sim = T_sw * 1000;
% At t1, the input voltage changes from V_g_min = 24 to V_g_nom = 26.5.
t1 = t_sim / 4; 
% At t2, the input voltage changes from V_g_nom = 26.5 to V_g_max = 29.
t2 = t_sim / 2;
% At t3, load resistance changes from 5/8 = 0.625 ohm to 5/10 = 0.5 ohm.
% Consequently, the load current goes from 8 A to 10 A (full_load).
t3 = t_sim * 3 / 4;
% Maximum duty cycle (when the transformer's core is being magnetized)
% Choosing D_max = 0.45, allows us enough margin in each switching period
% so that the transformer flux can be reset.
D_max = 0.45;
% Magnetizing inductance
L_m = 46.8e-6;
% Core loss resistor in parallel with magnetizing inductance
R_m = 1e6;
% Leakage inductance referred to the primary
L1 = 0.55e-6;
% Copper resistance of windings reffered to the primary
R1 = 27.75e-3;
% Transformer turns ratio (Ns/Np)
n = 0.8;
% Input voltage nominal DC value
V_g = V_g_nom; 
% Primary switches Rds,on
r_ds = 15e-3; 
% Load (inductor) nominal DC current
I_L = 8;
% Secondary diodes forward voltage drop in the load nominal current
V_D = 550e-3;  
% Secondary diodes series resistance
r_D = 10e-3;  
% Output inductor
L = 22e-6;
% Output inductor series resistance
r_L = 12e-3;
% Output filter capacitor
C = 220e-6;
r_C = 5e-3;
% Nominal load resistance
R = V_out/I_L;     
% Load resistance at maximum output current
R_load_at_max_current = V_out/I_out_max;
% Load resistance at nominal output current
R_load_at_nom_current = V_out/I_out_nom;
%% --- DC Operating Point and Small-Signal Model of The Converter ---
% This section calculates the DC operating point of the converter and then,
% extracts the small-signal model of the converter.
% Symbolic variables
% i_L: Output inductor current
% v_C: Capacitor voltage
% v_g: input voltage
% v_D: diode forward voltage drop
% d: duty cycle
% D: DC value of the duty cycle at nominal input voltage
syms i_L v_C v_g v_D d D
% Equations when switches 1 and 2, and diode D1 conduct (subinterval 1)
% Secondary voltage 
v_s = n*(v_g-2*r_ds*n*i_L);
% d(i_L)/dt
M1 = (1/L)*(-(r_D+r_L+(R*r_C)/(R+r_C))*i_L-(R/(R+r_C))*v_C-v_D+v_s);
% d(v_C)/dt
M2 = (1/C)*(1/(R+r_C))*(R*i_L-v_C);
% Output voltage
v_o1 = (1/(R+r_C))*(R*r_C*i_L+R*v_C);
% Equations when diode D2 conducts (subinterval 2 and 3)
% d(i_L)/dt
M3 = (1/L)*(-(r_D+r_L+(R*r_C)/(R+r_C))*i_L-(R/(R+r_C))*v_C-v_D);
% d(v_C)/dt
M4 = (1/C)*(1/(R+r_C))*(R*i_L-v_C);
% Output voltage
v_o2 = (1/(R+r_C))*(R*r_C*i_L+R*v_C);
% Averaging 
MA1 = simplify(d*M1+(1-d)*M3);
MA2 = simplify(d*M2+(1-d)*M4);
v_o = simplify(d*v_o1+(1-d)*v_o2);
% DC operating point calculation
MA_DC_1 = subs(MA1,[v_g v_D d],[V_g V_D D]);
MA_DC_2 = subs(MA2,[v_g v_D d],[V_g V_D D]);
sol = solve([MA_DC_1 == 0, MA_DC_2 == 0],...
    [i_L, v_C],'ReturnConditions',true);
iL_dc_sym = simplify(sol.i_L);
vC_dc_sym = simplify(sol.v_C);
v_o_DC = ...
   simplify(subs(v_o,[i_L,v_C,v_g,v_D,d],[iL_dc_sym,vC_dc_sym,V_g,V_D,D]));
% DC values for duty cycle, inductor current and capacitor voltage
D_DC = solve(v_o_DC==5,D) ;
IL = subs(iL_dc_sym,D,D_DC);
VC = subs(vC_dc_sym,D,D_DC);
% Linearization around the quiescent operating point
% x_dot = Ax + Bu
% x = [i_L;v_C] Vector x is the state variables.
% u = [v_g;v_D;d] Vector u is the input vector.
A11 = ...
    subs(simplify(diff(MA1,i_L)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
A12 = ...
    subs(simplify(diff(MA1,v_C)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
A21 = ...
    subs(simplify(diff(MA2,i_L)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
A22 = ...
    subs(simplify(diff(MA2,v_C)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
A = eval([A11 A12;A21 A22]);
B11 = ...
    subs(simplify(diff(MA1,v_g)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B12 = ...
    subs(simplify(diff(MA1,v_D)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B13 = ...
    subs(simplify(diff(MA1,d)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B21 = ...
    subs(simplify(diff(MA2,v_g)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B22 = ...
    subs(simplify(diff(MA2,v_D)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B23 = ...
    subs(simplify(diff(MA2,d)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
B = eval([B11 B12 B13;B21 B22 B23]);
CC11 = ...
    subs(simplify(diff(v_o,i_L)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
CC12 = ...
    subs(simplify(diff(v_o,v_C)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
CC = eval([CC11 CC12]);
E11 = ...
    subs(simplify(diff(v_o,v_g)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
E12 = ...
    subs(simplify(diff(v_o,v_D)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
E13 = ...
    subs(simplify(diff(v_o,d)),[i_L v_C v_g v_D d],[IL VC V_g V_D D_DC]);
E = eval([E11 E12 E13]);
H = tf(ss(A,B,CC,E));
% Line-to-output transfer function
Gvg = H(1);
% Control-to-output transfer function
Gvd = H(3)