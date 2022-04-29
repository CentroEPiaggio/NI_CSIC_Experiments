function [i_start, i_end, i_mid] = trim_in_time(struct_in, t_start, ...
    t_end, t_mid)
% TRIM IN TIME 
%   Trims the structure from start to end

% Find start time index
for i = 1 : length(struct_in)
    s_now = struct_in{i};
    t_now = double(s_now.Header.Stamp.Sec) + double(s_now.Header.Stamp.Nsec)*1e-9;
    if norm(t_now - t_start) < 1e-2
        i_start = i;
        break;
    end
end
% Find end time index
for i = 1 : length(struct_in)
    s_now = struct_in{i};
    t_now = double(s_now.Header.Stamp.Sec) + double(s_now.Header.Stamp.Nsec)*1e-9;
    if norm(t_now - t_end) < 1e-2
        i_end = i;
        break;
    end
end
% Find mid time index
for i = 1 : length(struct_in)
    s_now = struct_in{i};
    t_now = double(s_now.Header.Stamp.Sec) + double(s_now.Header.Stamp.Nsec)*1e-9;
    if norm(t_now - t_mid) < 1e-2
        i_mid = i;
        break;
    end
end

end

