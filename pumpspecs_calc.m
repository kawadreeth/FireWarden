%% Constants
rho = 1000; %kg/m3
g = 9.81; %m/s2
rough_cu = 0.000163;
f = 0.015; 
dynamic_vis = 0.001; %cP
Q_pump = 30; %GPM


%house specs
depth_pool = 2; %m
height_house = 10; %m
length_house= 10; %m
width_house = 15; %m
rooftop_area = 150; %m2
dist_house2pool = 5; %m

% Variables - fluids
pipe_dia = 0.0063; %m
patm = 101325; %Pa
v_exit = 1; %m/s

%% Sprinkler calc
sprinkler_range = 3; %m
area_persprinkler = pi*(sprinkler_range)^2;
n_sprinklers = rooftop_area/area_persprinkler;
length_pipe = height_house + (width_house/(2*sprinkler_range))*length_house;
sprinkler_nozzle_dia = 3.2; %mm

%% Fluid dynamics for pump specs
% friction
hf = f*(length_pipe/pipe_dia)*(v_exit^2)/(2*g);

% bernoullis equation
p1 = depth_pool;
p2 = patm/(rho*g);
kin_head2 = v_exit^2/(2*g);

% pump head
hp = p2-p1+n_sprinklers*kin_head2+height_house+hf;  %m
pump_pressure_pa= rho*g*hp; %pa
pump_pressure = pump_pressure_pa/6894.76; %psi
pump_power = rho*g*hp*Q_pump/746; %hp

%% Mass flow rates
%pump
mass_flow_rate_pump = rho * Q_pump ; %kg/s

% sprinkler
sprinkler_pressure = pump_pressure; %psi
min_q_sprinkler = 2; %GPM
pressure_vertical_loss = (pump_pressure_pa - rho*g*height_house)/6894.76; %psi
Q_sprinkler = Q_pump/n_sprinklers*(pressure_vertical_loss/pump_pressure_pa); %GPM

%% Cost estimation

%fixed costs in usd
generator = 500;
sumpump = 1000;
suctionstrainer = 40;

persprinkler = 40;
pipe_per_m = 20;
hose_per_m = 10; 
tot_fixed_cost = generator+sumpump+suctionstrainer;

% variable cost
pipings_cost = length_pipe*pipe_per_m;
sprinklers_cost = persprinkler*n_sprinklers;
hose_cost = hose_per_m*dist_house2pool;

% Total cost
total_cost = tot_fixed_cost+pipings_cost+sprinklers_cost+hose_cost;
add_m2_cost = (persprinkler+sprinkler_range*2*pipe_per_m)/(area_persprinkler); % $/m2