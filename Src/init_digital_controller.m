% Digital Controller Initialization File
%% Digital Controller Parameters and Values

PWM_resolution = 7;
ADC_resolution = 12;
v_PWM_max = 1;

G_c_d = c2d(G_c,T_sampling,'matched');
[comp_num_d,comp_den_d] = tfdata(G_c_d,'v'); 


% Show continuous and discrete poles
pole(G_c)
pole(G_c_d)

% Zero-pole-gain form
zpk(G_c)
zpk(G_c_d)

% DC gain
dc_cont = dcgain(G_c)
dc_disc = dcgain(G_c_d)

% Bode / frequency check (continuous vs discrete)
T_s = T_sw;        % e.g. 50e-6
w = logspace(0,6,200);      % adjust upper freq for your system
figure; bode(G_c, G_c_d, w);

% Or discrete frequency response (freqz style)
[b,d] = tfdata(G_c_d,'v');
freqz(b, d, 1024, 1/T_s)    % if you want discrete freq axis in Hz

s = tf('s');

H_filter = (3.3/5)*(1/(1591.52e-9*s + 1));
bode(H_filter)
