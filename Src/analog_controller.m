% Analog Controller Initialization File

%% Analog Controller Parameters and Values
% peak voltage of sawtooth waveform
V_M = 3;

% the quiescent value of the control voltage
V_C = D*V_M;


 

% ---------- parameters values ----------
% Run this file to initialize values used in the Simulink file
% switching frequency
% fsw = 100e3;
% input voltage
% vg = 150;
% output voltage
% V = 15;
% load resistor
% R = 10;
% filter capacitor
% C = 200e-6;
% magnetizing inductance of flyback transformer
% L = 1000e-6;
% flyback transformer turns ratio
%n = 0.2;
% quiescent operation point duty cycle
% D = 1/3;
% peak voltage of sawtooth waveform
% VM = 4;
% the quiescent value of the control voltage
% VC = D*VM;
% sensor gain
% H = 1/3;
H = 3/5;
% open loop quadratic poles 
% w0 = (1-D)/(n*sqrt(L*C));
w_0 = 1/sqrt(L*C);
f_0 = w_0/2/pi;
% open loop transfer functions Q-factor
Q = R_load*sqrt(C/L);
% RHP zero
% wz = (1-D)^2*R/(D*n*L);
% wz = inf
% fz = wz/2/pi;
% control-to-output DC gain
% Gg0 = n*D/(1-D);
G_g0 = n*D;
% line-to-output DC gain
% Gd0 = V / D / (1-D);
G_d0 = V/D;
% crossover frequency of loop gain after compensation
% fco = 2.1e3; 
f_co = f_sw/10;

% simulation and step times
% tSim = 0.4;
t1 = 0.25 * t_sim;
t2 = 0.5 * t_sim;
t3 = 0.75 * t_sim;

% ---------- open-loop transfer functions ----------
% the open-loop line-to-output transfer function
G_vg = G_g0 * tf(1,[(1/w_0)^2 1/w_0/Q 1]);
bodef(G_vg,false)
% the poles of the open-loop transfer functions are the same
% so these poles are also the poles of Gvd and Zout
G_vg_poles = pole(G_vg)

% the open-loop control-to-output transfer function
G_vd = G_d0*tf(1, [(1/w_0)^2 1/w_0/Q 1]);
bodef(G_vd,false)
figure
pzmap(G_vd)
title('Gvd')

% the open-loop output impedance
% Zout = tf([n^2*L/(1-D)^2 0],[n^2*L*C/(1-D)^2 n^2*L/R/(1-D)^2 1]);
% bodef(Zout,false)

% the uncompensated loop gain of the system
T_u = G_vd*H/V_M; % uncompensated loop gain (Gc(s) = 1)
bodef(T_u,true)
NyqPlot(T_u)
title('Tu')
uncompensated_loop_poles = zero(1+T_u)
figure
pzmap(1+T_u)
title('1+Tu')

% evaluating the uncompensated loop gain at loop gain crossover frequency
T_u_at_f_co = freqresp(T_u,f_co*2*pi);
T_u_mag_at_f_co = abs(T_u_at_f_co);
T_u_phase_at_f_co = angle(T_u_at_f_co);

% dc gain of uncompensated loop gain
T_u0 = G_d0*H/V_M; 

% ---------- design of the compensator ----------
phi_max = 60*pi/180; %Gc1 maximum phase (60 degrees)
f_z1 = f_co*sqrt((1-sin(phi_max))/(1+sin(phi_max)));
w_z1 = f_z1*2*pi;
f_p1 = f_co*sqrt((1+sin(phi_max))/(1-sin(phi_max)));
w_p1 = f_p1*2*pi;
G_c1 = tf([1/w_z1 1],[1/w_p1 1]);
G_c1_at_f_co = freqresp(G_c1,f_co*2*pi);
G_c1_mag_at_f_co = abs(G_c1_at_f_co);
G_c1_phase_at_f_co = angle(G_c1_at_f_co);
% following division makes Tu*Gc1 to have fco as its crossover frequency
G_c1 = G_c1 / (G_c1_mag_at_f_co*T_u_mag_at_f_co);
f_z2 = f_co/4;
w_z2 = f_z2*2*pi;
G_c2 = tf([1 w_z2],[1 0]);
G_c = G_c1*G_c2
bodef(G_c,false)
% compensated loop gain
T = G_c*T_u
bodef(T,true);
NyqPlot(T)
% compNum and compDen are used as numerator and denominator of the transfer
% function of the compensator
[comp_num,comp_den] = tfdata(G_c,'v');  

% ---------- closed-loop transfer functions ----------
% using these bode diagrams we can see that the effect of 
% disturbances on the output is negligible 
% GvgClosed = Gvg/(1+T);
% bodef(GvgClosed,false)

% ZoutClosed = Zout/(1+T);
% bodef(ZoutClosed,false)

% vRefTovOut = 1/H * T/(1+T);
% bodef(vRefTovOut,false)

close all


% -------- auxiliary functions ----------
% --- function making bode plot with Hz frequency axis ---
function [] = bodef(x,drawMargin)
    figure('Name',inputname(1),'NumberTitle','off');
    plotOption = bodeoptions;
    plotOption.FreqUnits = 'Hz';
    bodeplot(x,plotOption)
    if drawMargin
        margin(x)
    end
    title(inputname(1))
    grid on
end

% --- function making drawing multiple Nyquist plots easier ---
function [] =NyqPlot(x)
    figure('Name',inputname(1),'NumberTitle','off');
    nyquistplot(x)
    title(inputname(1))
    grid on
end
