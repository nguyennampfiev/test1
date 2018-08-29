classdef check_if < handle    
    properties (SetAccess = protected)
        substr;
    end
    
    methods
        function obj = check_if()
        end
        
        function obj = substring(obj, substr)
            obj.substr = substr;
        end
        
        function result = is_in_string(obj, str)
            result = ~isempty(strfind(str, obj.substr));
        end
    end    
end

