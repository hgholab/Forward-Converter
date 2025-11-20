% Digital Controller Initialization File
%% --- Digital Controller Parameters and Values ---
PWM_resolution = 6;
ADC_resolution = 12;
v_PWM_max = 1;
v_ref = 3;
s = tf('s');
z = tf('z',T_sw);
fp2 = 0.3*f_sw;
Hd = v_ref/V_out/(1+s/2/pi/fp2);    % Sensor transfer function
Tu = Hd*Gvd/v_PWM_max;              % Uncompensated loop gain with no delay
T_analog = G_c*Tu;                  % Loop gain with analog compensator
% Uncompensated loop gain including delay
td = double(D_DC)*T_sw;
Tu.IODelay = td;                    % Delay
% Mapping of Tu with delay
Tud = c2d(Tu,T_sw,'impulse')
Gcd = c2d(G_c,T_sw,'prewarp',2*pi*f_co);
Td = Tud*Gcd;                       % Loop gain with digital compensator
[comp_num_d,comp_den_d] = tfdata(Gcd,'v');
[Hd_num,Hd_denom] = tfdata(Hd,'v');
options = bodeoptions;
options.Grid = 'on';
options.FreqUnits = 'Hz';
options.XLim = [100, 100e3];
bode(T_analog,'r', options);
hold on;
bode(Td,'b',options);