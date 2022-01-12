function [pos_body, vel_body, joint_positions, joint_torques, ...
    time, t_start, t_end] = compute_robot_state(stateStructs, navStructs, flag)
% COMPUTE ROBOT STATE
% Compute the robot related quantities
%
% stateStructs - contains result of
%       extract_topic_from_bag(file_path,'/state_estimator/anymal_state');
% navStructs - contains result of
%       extract_topic_from_bag(file_path,...
%           '/path_planning_and_following/navigate_to_goal/result');
% flag	-	0 -> start from when robot moves
%       -	1 -> start from when robot reaches first navigation goal

% Time
time = cellfun(@(m) double(m.Header.Stamp.Sec) + double(m.Header.Stamp.Nsec)*1e-9, ...
    stateStructs);

% Base Position
x_body = cellfun(@(m) double(m.Pose.Pose.Position.X),stateStructs);
y_body = cellfun(@(m) double(m.Pose.Pose.Position.Y),stateStructs);
z_body = cellfun(@(m) double(m.Pose.Pose.Position.Z),stateStructs);
pos_body = [x_body,y_body,z_body];

% Base Velocity
dx_body = cellfun(@(m) double(m.Twist.Twist.Linear.X),stateStructs);
dy_body = cellfun(@(m) double(m.Twist.Twist.Linear.Y),stateStructs);
dz_body = cellfun(@(m) double(m.Twist.Twist.Linear.Z),stateStructs);
vel_body = [dx_body,dy_body,dz_body];

% Joint Positions
joint_positions = cell2mat(cellfun(@(m) double(m.Joints.Position),stateStructs,...
    'uniformoutput',false));
joint_positions = reshape(joint_positions,[12,length(stateStructs)]).';

% Joint Torque
joint_torques = cell2mat(cellfun(@(m) double(m.Joints.Effort),stateStructs,...
    'uniformoutput',false));
joint_torques = reshape(joint_torques,[12,length(stateStructs)]).';

if flag == 0
    % Find start time
    for i = 1 : length(time)
        if norm(vel_body(i,:)) > 1e-2
            t_start = time(i);
            break;
        end
    end
else
    t_start = double(navStructs{1}.Header.Stamp.Sec) + double(navStructs{1}.Header.Stamp.Nsec)*1e-9;
end
% Find end time
for i = length(time) : -1 : 1
    if norm(vel_body(i,:)) > 1e-2
        t_end = time(i);
        break;
    end
end

% Find trim indexes and trim all outputs
[i_start, i_end] = trim_in_time(stateStructs, t_start, t_end);
pos_body = pos_body(i_start:i_end,:);
vel_body = vel_body(i_start:i_end,:);
joint_positions = joint_positions(i_start:i_end,:);
joint_torques = joint_torques(i_start:i_end,:);
time = time(i_start:i_end);

% Refactor time from 0 to end
time = time - time(1);

end

