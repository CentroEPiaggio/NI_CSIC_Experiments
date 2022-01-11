%% Extract topics from bag file and compute the metric

clear all; clc;
addpath('./functions/');

% Input parameters
bag_path = './bags/';
bag_file = '_2022-01-11-17-41-00.bag';

% Derived parameters
file_path = [bag_path, bag_file];

% Extract each topic structure from bag
stateStructs = extract_topic_from_bag(file_path,'/state_estimator/anymal_state');
tfStructs = extract_topic_from_bag(file_path,'/tf');
batteryStructs = extract_topic_from_bag(file_path,'/pdb/battery_state');
% Example only for one motor (copy/paste for others)
mcurrStructs = extract_topic_from_bag(file_path,'/log/state/current/LF_HAA');
navStructs = extract_topic_from_bag(file_path,...
    '/path_planning_and_following/navigate_to_goal/result');

%% Getting robot state variables
[pos_body, vel_body, joint_positions] = compute_robot_state(stateStructs);

%% Getting experiment navigation results
mission_status = compute_mission_status(navStructs);

%% Getting slippage 
[slippage_num, slippage_den, slippage_squared, ...
    slippage_norm] = compute_slippage(stateStructs);

%% Find odom to map trasforms
Todom2map = get_transforms(tfStructs, 'odom', 'map');

%% Get battery state of charge
battery_SoC = compute_battery_status(batteryStructs);

%% Get motor current
% Example only for one motor (copy/paste for others)
motorCurrent = compute_motor_current(mcurrStructs);