% M McCready, 2021
classdef BlochDremr
    %BLOCHDREMR: Solves the longitudinal bloch equation under a given dreMR
    %pulse for a given domain
    
    properties
        pulse %a Pulse object which defines the dreMR pulse to be applied
        sample %a Sample object defining the domain to apply the pulse over
        coil %an Elems object defining the coil producing the pulse
        B0 %the static field with dreMR insert off (T)
    end
    
    methods
        function obj = BlochDremr(varargin)
            %BLOCHDREMR: Construct an instance of this class
            %   Creates a BlochDremr object with default empty pulse,
            %   sample, and coil parameters, and B0 set to 0.5T
            %Optional name, value pair input:
            %   'pulse' - the Pulse object defining the desired dreMR pulse
            %   'sample'- the Sample object defining the desired domain
            %   'coil'  - the Elems object defining the dreMR insert coil
            %   'B0'    - the desired static field strength (T)
            
            obj.pulse = [];
            obj.sample = [];
            obj.coil = [];
            obj.B0 = 0.5;
            
            if nargin>0 %parsing the optional input
                k = 1;
                while k < length(varargin)
                    property = lower(varargin{k});
                    val = varargin{k+1};
                    switch property
                        case 'pulse'
                            obj.pulse = val;
                        case 'sample'
                            obj.sample = val;
                        case 'coil'
                            obj.coil = val;
                        case 'b0'
                            obj.B0 = val;
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
                        case 'pulse'
                            obj.pulse = val;
                        case 'sample'
                            obj.sample = val;
                        case 'coil'
                            obj.coil = val;
                        case 'b0'
                            obj.B0 = val;
                    end
                    k = k+2;
                end
            end
        end
        
        function Mz = calcMag(obj)
            %CALCMAG calculates longitudinal magnetization over the sample
            %domain following the given dreMR pulse.
            %   Assumes Mz has been zeroed across the sample following the
            %   90deg RF pulse directly before a typical dreMR pulse. The 
            %   assumption is also made that IL and IR << Vmax so slew is
            %   linear with B in slew rate simulations. To assume a perfect
            %   square pulse set slew rate to inf. Field profile is
            %   determined by coil design. If no coil is supplied, field is
            %   assumed to be perfectly homogenous.
            
            if ~isempty(obj.coil) %if a coil is supplied we use its field
                field = calcBField(obj.coil,obj.sample.xyz); %Biot-savart
                field = field(:,3); %z-component at each point in domain
                eff = field/obj.coil.current; %field efficiency at each pt
                effc = obj.coil.B0T/obj.coil.current; %eff at isocenter
            else %no coil is supplied, assume homogeneous
                eff = 1;
                effc = 1;
            end
            
            %preparing variables: dB relaxation period
            field = (eff/effc)*obj.pulse.dB + obj.B0; %field under pulse
            M0 = obj.sample.M0*field; %getting steady state Mz under pulse
            %linear interpolation of relaxivity data for our field
            r1 = interp1(obj.sample.rel(:,1),obj.sample.rel(:,2),field);
            R1 = obj.sample.conc.*r1 + 1./obj.sample.T1; %relaxation rates
            
            %analytic flat-top solution
            Mz = M0.*(1 - exp(-obj.pulse.dt.*R1));
        end
        
    end
    
end

