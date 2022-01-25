% M McCready, 2021
classdef Pulse
    %PULSE: Defines dreMR pulse paramters for BlochDremr class
    
    properties
        dB %amplitude of dreMR pulse
        dt %time duration of dreMR pulse
    end
    
    methods
        function obj = Pulse(varargin)
            %PULSE: Construct an instance of this class
            %   Creates a Pulse object with default empty values.
            %Optional name, value pair input:
            %   'dB' - the amplitude of the dreMR pulse
            %   'dt' - the duration of the pulse
            
            obj.dB = [];
            obj.dt = [];
            
            if nargin>0 %parsing the optional input
                k = 1;
                while k < length(varargin)
                    property = lower(varargin{k});
                    val = varargin{k+1};
                    switch property
                        case 'db'
                            obj.dB = val;
                        case 'dt'
                            obj.dt = val;
                    end
                    k = k+2;
                end
            end
        end
        
        function obj = set(obj,varargin)
            %SET: setter function for class properties
            %   Takes name, value pairs as in class constructor
            
            if nargin>1 %parsing optional input
                k = 1;
                while k < length(varargin)
                    property = lower(varargin{k});
                    val = varargin{k+1};
                    switch property
                        case 'db'
                            obj.dB = val;
                        case 'dt'
                            obj.dt = val;
                    end
                    k = k+2;
                end
            end
        end
    end
end

