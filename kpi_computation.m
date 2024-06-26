%% Extract topics from bag file and compute the metric

clear all; clc;
addpath('./functions/');

% Input parameters
bag_path = './bags/dataset_grasslands/';
bag_file = '_2022-05-11-17-48-56.bag';
up_down = 'full';                                 % up / down / full

% Load constants
constants_initialization;

% Derived parameters
file_path = [bag_path, bag_file];

% Extract each topic structure from bag
stateStructs = extract_topic_from_bag(file_path,'/state_estimator/anymal_state');
tfStructs = extract_topic_from_bag(file_path,'/tf');
batteryStructs = extract_topic_from_bag(file_path,'/pdb/battery_state_ros');
% Example only for one motor (copy/paste for others)
mcurrStructs = extract_topic_from_bag(file_path,'/log/state/current/LF_HAA');
navStructs = extract_topic_from_bag(file_path,...
    '/path_planning_and_following/navigate_to_goal/result');
trajStructs = extract_topic_from_bag(file_path,...
    '/path_planning_and_following/trajectory_poses');
actStructs = extract_topic_from_bag(file_path,...
    '/path_planning_and_following/active_path');

%% Getting robot state variables
[pos_body, ori_body, vel_body, joint_positions, joint_velocities, joint_accelerations, ...
    joint_torques, time, t_start, t_end, lim_start, lim_end] = compute_robot_state(stateStructs, ...
    navStructs, 1, up_down);

%% Getting experiment navigation results
mission_status = compute_mission_status(navStructs);

%% Getting slippage 
slippage_metric = compute_slippage(stateStructs, lim_start, lim_end);

%% Find odom to map transforms
Todom2map = get_transforms(tfStructs, 'odom', 'map', length(pos_body), ...
    t_start, t_end);

%% Get battery state of charge
[time_battery, battery_SoC, battery_V, battery_C] = compute_battery_status(batteryStructs, ...
    t_start, t_end);

%% Get motor current
% Example only for one motor (copy/paste for others)
[motorCurrent, time_i] = compute_motor_current(mcurrStructs, t_start, t_end);

%% Trasforming positions and velocities from odom into map
pos_base = transform_data(pos_body, Todom2map);
ori_base = ori_body;
vel_base = vel_body;            % Velocity seems to be in base frame

%% Converting orientation into RPY
rpy = quat2eul(ori_base);
rpy = unwrap(rpy);

%% Computing KPIs
% Success (To be computed by hand "mission_status" from two bags of and
% experiment)

% Normalized Velocity
speed = arrayfun(@(ROWIDX) norm(vel_base(ROWIDX,:)), (1:size(vel_base,1)).');
norm_speed = speed./sqrt(g*h_R);

% Cost of Transport
Energy = batt_E*(battery_SoC(1) - battery_SoC(end));
distance = sum(sqrt(sum(diff(pos_base).^2')));
CoT = Energy/(mass_R*g*distance);

% Alternative CoT (Using Mechanical Energy)
Energy_1 = trapz(dot(joint_torques,joint_velocities,2));
CoT_1 = Energy_1/(mass_R*g*distance);

% Deviation Index
int_Dev_y = trapz(abs(pos_base(:,2)));
Dev_y = (h_CoM/h_R)*(1/w_R)*int_Dev_y;

% Slippage
slippage = slippage_metric;