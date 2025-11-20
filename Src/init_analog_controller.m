% Analog Controller Initialization File
%% --- Analog Controller Parameters and Values ---
% Peak voltage of the PWM carrier sawtooth waveform
V_M = 1;
% Sensor gain
H = 3.3/5;
% Desired crossover frequency of the loop gain after compensation 
f_co = f_sw/10;
% Uncompensated loop gain when Gc(s) = 1
T_u = Gvd*H/V_M;
% Evaluating the uncompensated loop gain at loop gain crossover frequency
T_u_mag_at_f_co = abs(freqresp(T_u,f_co*2*pi));
%% --- Design of The Compensator ---
phi_max = 60*pi/180; % Gc1 maximum phase (60 degrees)
f_z1 = f_co*sqrt((1-sin(phi_max))/(1+sin(phi_max)));
w_z1 = f_z1*2*pi;
f_p1 = f_co*sqrt((1+sin(phi_max))/(1-sin(phi_max)));
w_p1 = f_p1*2*pi;
G_c1 = tf([1/w_z1 1],[1/w_p1 1]);
G_c1_mag_at_f_co = abs(freqresp(G_c1,f_co*2*pi));
% Following division makes Tu*Gc1 to have fco as its crossover frequency
G_c1 = G_c1/(G_c1_mag_at_f_co*T_u_mag_at_f_co);
% Inverted zero added to the compensator to better regulate low-frequency
% disturbances
f_l = f_co/10;
w_l = f_l*2*pi;
G_c2 = tf([1 w_l],[1 0]);
G_c = G_c1*G_c2;
% compensated loop gain
T = G_c*T_u;
bodef(T,true)
% compNum and compDen are used as numerator and denominator of the transfer
% function of the compensator
[comp_num,comp_den] = tfdata(G_c,'v');