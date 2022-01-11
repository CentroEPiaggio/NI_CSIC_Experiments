function [pos_body, vel_body, joint_positions, joint_torque] = compute_robot_state(stateStructs)
% COMPUTE ROBOT STATE
% Compute the robot related quantities
%
% stateStructs - contains result of 
%       extract_topic_from_bag(file_path,'/state_estimator/anymal_state');

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
joint_positions = reshape(joint_positions,[12,length(stateStructs)]);

% Joint Positions
joint_torque = cell2mat(cellfun(@(m) double(m.Joints.Effort),stateStructs,...
    'uniformoutput',false));
joint_torque = reshape(joint_torque,[12,length(stateStructs)]);

end

