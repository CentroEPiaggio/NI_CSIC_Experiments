function Todom2map = get_transforms(tfStructs, from_frame, to_frame)
% GET TRANSFORMS
% Get transforms from from_frame to to_frame

% Getting IDs transforms from from_frame to to_frame
ids = [];
for i = 1 : length(tfStructs)
    
    tfStruct = tfStructs{i};
    
    % Avoid trasforms between feet (those have size 12, others 1)
    if length(tfStructs{i}.Transforms) == 1
        
        % Check parent and child
        parent_frame = tfStruct.Transforms.Header.FrameId;
        child_frame = tfStruct.Transforms.ChildFrameId;
        
        % If correct one, save
        if strcmp(parent_frame, from_frame)
            if strcmp(child_frame, to_frame)
                ids = [ids, i];
            end
        end
    end
    
end

% Iterate and extract the transforms from from_frame to to_frame
for i = 1 : length(ids)
    tfStruct = tfStructs{ids(i)};
    odom2map = tfStruct.Transforms.Transform;
    translation = [odom2map.Translation.X, odom2map.Translation.Y, odom2map.Translation.Z];
    quaternion = [odom2map.Rotation.W, odom2map.Rotation.X, odom2map.Rotation.Y, odom2map.Rotation.Z];
    rotation = quat2rotm(quaternion);
    Todom2map_curr = [rotation, translation.';
        zeros(1,3), 1];
    Todom2map{i} = Todom2map_curr;
end

end

