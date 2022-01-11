function battery_SoC = compute_battery_status(batteryStructs)
% COMPUTE BATTERY STATUS
% Compute the battere SoC
%
% batteryStructs - contains result of 
%       extract_topic_from_bag(file_path,'/pdb/battery_state');

% Battery status
battery_SoC = cellfun(@(m) double(m.StateOfCharge),batteryStructs);
end

