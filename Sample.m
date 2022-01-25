% M McCready, 2021
classdef Sample
    %SAMPLE: Defines simulation domain for BlochDremr class, including
    %positions centered within coil, tissue T1 vales, contrast agent 
    %relaxivity data, and concentration of agent.
    
    properties
        xyz %position data
        rel %contrast agent relaxivity data
        conc %concentration of agent
        T1 %T1 default value
        M0 %Curie's law (*WITHOUT field factored in)
    end
    
    methods
        function obj = Sample(varargin)
            %SAMPLE: Construct an instance of this class
            %   Creates a Sample object containing all necessary details of
            %   the simulation domain for the BlochDremr class.
            %Optional name, value pair input:
            %   'XYZ'       - the xyz locations of the discritized domain
            %   'relaxivity'- longitudinal relaxivity data for the
            %                 T1-dispersive agent to be used
            %   'concentration'- local concentration of agent at each xyz
            %   'T1'        - local T1 time constant at each xyz (tissue)
            %   'M0'        - magnetization per Tesla
            
            obj.xyz = [];
            obj.rel = [];
            obj.conc = [];
            obj.T1 = [];
            obj.M0 = [];
            
            if nargin>0 %parsing optional input
                k = 1;
                while k < length(varargin)
                    property = lower(varargin{k});
                    val = varargin{k+1};
                    switch property
                        case 'xyz'
                            obj.xyz = val;
                        case 'relaxivity'
                            obj.rel = val;
                        case 'concentration'
                            obj.conc = val;
                        case 't1'
                            obj.T1 = val;
                        case 'curie'
                            obj.M0 = val;
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
                        case 'xyz'
                            obj.xyz = val;
                        case 'relaxivity'
                            obj.rel = val;
                        case 'concentration'
                            obj.conc = val;
                        case 't1'
                            obj.T1 = val;
                        case 'curie'
                            obj.M0 = val;
                    end
                    k = k+2;
                end
            end
            
        end
        
    end
    
end

