function [i_start, i_end] = trim_tf_in_time(struct_in, t_start, t_end)
% TRIM IN TIME
%   Trims the structure from start to end


% Find start time index
for i = 1 : length(struct_in)
    % Avoid trasforms between feet (those have size 12, others 1)
    if length(struct_in{i}.Transforms) == 1
        s_now = struct_in{i};
        t_now = double(s_now.Transforms.Header.Stamp.Sec) + double(s_now.Transforms.Header.Stamp.Nsec)*1e-9;
        if norm(t_now - t_start) < 1e-2
            i_start = i;
            break;
        end
    end
end
% Find end time index
for i = 1 : length(struct_in)
    % Avoid trasforms between feet (those have size 12, others 1)
    if length(struct_in{i}.Transforms) == 1
        s_now = struct_in{i};
        t_now = double(s_now.Transforms.Header.Stamp.Sec) + double(s_now.Transforms.Header.Stamp.Nsec)*1e-9;
        if norm(t_now - t_end) < 1e-2
            i_end = i;
            break;
        end
    end
end

end

