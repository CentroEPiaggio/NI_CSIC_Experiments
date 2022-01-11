function motorCurrent = compute_motor_current(mcurrStructs)
% COMPUTE MOTOR CURRENT
% Compute the motor current
%
% mcurrStructs - contains result of 
%       extract_topic_from_bag(file_path,'/log/state/current/...')

% Motor Current
motorCurrent = cellfun(@(m) double(m.Value),mcurrStructs);
end

