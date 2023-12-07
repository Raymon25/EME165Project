clear;

%This script solves for Temperature as a function of indexed values.
%Constants are plugged to minimize the need for substituions in main
%script. This is to reduce iteration time as the solve function is fairly
%slow.

%Creates and assigns values to variables for propety values

k = 80; %W/m-K
h_water = 1000; %W/m^2-K
h_air = 25; %W/m^2-K
Q = 10^6; %W/m^2
a = 0.95;
e = 0.75;
r_i = 15 * 10^(-3); %m
r_o = 18 * 10^(-3); %m
T_inf = 40; %C
T_water = 600; %C
T_surr = 40; %C
r_avg = (r_i + r_o)/2; %m 

%Creates matrix of control volumes

columns = 36; %number of control volumes in angular drection (minimum of 20)

d_theta = pi/columns; %change in angle between control volumes

%Set resistance values
c_o =r_o * d_theta; %m
c_i =r_i * d_theta; %m
R_contact = 10^(-4); %m^2 K/W
R_cond = (r_avg * d_theta)/(k*(r_o-r_i)); %m^2 K/W
R_conv_o = 1/(h_air*c_o); %m^2 K/W
R_conv_i = 1/(h_water*c_i); %m^2 K/W

sb = 5.67*10^-8;


syms Temp_cond_lower Temp_surface Temp_cond_higher Temp_under_surface fraction T

%For Temp(1,1) - Temp(1,18)
eqn = (T-T_inf)/R_conv_o + (T-Temp_under_surface)/R_contact + sb*e*c_o*(T+273)^4 == Q*fraction*a*c_o+sb*a*c_o*(T_inf+273)^4;
eqn1_sol = solve(eqn,T,'MaxDegree',4);

%For Temp(1,19) - Temp(1,36)
eqn2_sol = Temp_under_surface;

%For Teamp(2,1)
eqn = (Temp_surface-T)/R_contact == (T-T_water)/R_conv_i + (T-Temp_cond_higher)/R_cond;
eqn3_sol = solve(eqn,T);

%For Temp(2,2) - Temp(2,35)
eqn = (Temp_cond_lower-T)/R_cond + (Temp_surface-T)/R_contact == (T-T_water)/R_conv_i + (T-Temp_cond_higher)/R_cond;
eqn4_sol = solve(eqn,T);

%For Temp(2,36)
eqn = (Temp_cond_lower-T)/R_cond + (Temp_surface-T)/R_contact == (T-T_water)/R_conv_i;
eqn5_sol = solve(eqn,T);

%disp(eqn1_sol);
%disp(eqn2_sol);
%disp(eqn3_sol);
%disp(eqn4_sol);
%disp(eqn5_sol);