clear;close all;clc;
load Para_DC.mat;
%% ----- 数据中心服务器模型数据
Para_DC.P_static = 53;     %W
Para_DC.k = 6.5;           %W/Ghz^3
Para_DC.f_max = 3.0;       %Ghz
Para_DC.f_min = 0.8;       %Ghz
Para_DC.mu_div = 5;
Para_DC.delay_time = 0.5;  %s
Para_DC.P_max_sever = Para_DC.k * Para_DC.f_max^3;
Para_DC.Sever_rate_max = Para_DC.f_max * Para_DC.mu_div;
Para_DC.Sever_rate_min = Para_DC.f_min * Para_DC.mu_div;
Para_DC.PUE = 1.2;
Para_DC.Load_rate = 0.9;
%% ----- 数据中心储氢模型数据
Para_DC.eta_el = 0.75;     %电解槽效率
Para_DC.rho = 0.2;         %Nm^3/(kW*h)   单位功率制氢：0.2-0.23
Para_DC.eta_f = 0.60;      %燃料电池效率：0.50-0.65
Para_DC.mu_f = 0.295;      %Nm^3/(kW*h)   单位功率需氢：0.2-0.23
Para_DC.eta_s = 0.95;      %氢气储存效率
Para_DC.C_dis = 0.45/7;    %氢气发电成本 $/kwh
Para_DC.C_ch = 0.21/7;     %氢气生成成本 $/kwh
Para_DC.C_storage = 0.96/7;     %氢气储存成本 $/Nm^3


Para_DC.P_ch_max = [15,15,18,15,12,18];     %MW   最大充电功率
Para_DC.Q_SH2_min = [0,0,0,0,0,0];
Para_DC.Q_SH2_max = Para_DC.eta_el*Para_DC.rho.*Para_DC.P_ch_max*10^3;
                           %Nm^3   最大存储量

Para_DC.Num_dc = 6;
Para_DC.Bus = [3,5,10,14,20,24];
Para_DC.Num_server = [1.8e5,1.8e5,2.2e5,2e5,2.2e5,2.3e5];
Para_DC.Q_SH2_origin = 0.3*Para_DC.Q_SH2_max;
Para_DC.Time_slot = 24;
Para_DC.Mig_rate = [0.7,0.6,0.5,0.4,0.6,0.5];
Para_DC.workload_max = repmat(Para_DC.Load_rate.*Para_DC.Sever_rate_max.*Para_DC.Num_server,Para_DC.Time_slot,1);
Para_DC.workload_min = repmat(Para_DC.Sever_rate_min.*Para_DC.Num_server,Para_DC.Time_slot,1);

Para_DC.power_load_max = 1e-6*Para_DC.PUE.*( Para_DC.P_static.*repmat(Para_DC.Num_server,Para_DC.Time_slot,1) + Para_DC.workload_max.*Para_DC.mu_div.^-1.*Para_DC.k.*Para_DC.f_max^2);
Para_DC.power_load_min = 1e-6*Para_DC.PUE.*( Para_DC.P_static.*repmat(Para_DC.Num_server,Para_DC.Time_slot,1) + Para_DC.workload_min.*Para_DC.mu_div.^-1.*Para_DC.k.*Para_DC.f_min^2);

% Para_DC.workload = floor(unifrnd(Para_DC.workload_min,Para_DC.workload_max,Para_DC.Time_slot,Para_DC.Num_dc));
% Para_DC.Mig_workload = repmat(Para_DC.Mig_rate,Para_DC.Time_slot,1).*Para_DC.workload;

Para_DC.Price_option = [0.10343,0.13992,0.10343,0.10343,0.10343,0.10343,0.13992,0.13992,0.13992,0.13992,0.13992,0.13992,...
    0.10343,0.10343,0.10343,0.10343,0.13992,0.13992,0.13992,0.10343,0.10343,0.10343,0.10343,0.10343]';
Para_DC.Price_option = [0.8*Para_DC.Price_option, 0.9*Para_DC.Price_option, Para_DC.Price_option, 1.1*Para_DC.Price_option, 1.2*Para_DC.Price_option];

Para_DC.H2_price = 0.5/(Para_DC.rho*Para_DC.eta_el);
Para_DC.wind_Com = 0.1;
save Para_DC.mat Para_DC;
