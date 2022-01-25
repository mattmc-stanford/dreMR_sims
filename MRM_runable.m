% M McCready, 2021
% This script is a runnable example of how dreMR simulations were carried
% out to create Figure 5 of the manuscript "An improved homogeneity design
% method for fast field-cycling coils in molecular MRI" by M McCready, W
% Handler, and B Chronik (2021). This script will not create Figure 5, as
% it does not include simulation of specific coil designs, only dreMR
% subtraction assuming a perfectly ideal field. It also uses fake
% relaxivity data (similar to real values) so that the user does not
% require relaxivity data used in the manuscript (which was provided
% through privated correspondance with T Scholl and F Martinez at
% University of Western Ontario).

B0 = 0.5;%static field with no dreMR pulse

%need to make pulse object=================================================
pulse1 = Pulse('dB',-0.1,'dt',100e-3);
pulse2 = Pulse('dB',0.1,'dt',100e-3);

%need to make sample object================================================

%designing our domain
w = 0.08; %width
n = 250; %resolution (# points)
x = linspace(-w/2,w/2,n);
z = linspace(-w/2,w/2,n);
[X,Z] = meshgrid(x,z);
Y = zeros(size(X));
XYZ = [X(:) Y(:) Z(:)];

%generating fake relaxivity data (similar to VivoTrax)
rel = zeros(25,2);
rel(:,1) = linspace(0, 1.5, 25); %Magnetic field strength
rel(:,2) = 65.57*exp(-8.525*rel(:,1)) + 17.08; %relaxivity (in per mM)
rel(:,2) = 1e3*rel(:,2);

%homogenous concentration (160 uM)
conc = ones(size(X))*160e-6;

%background T1 and T2 of blood
T1 = 1.2; %T1 can be spatially dependent for non-uniform domain

%Equilibrium magnetization at B0
M0=1;

%making the simulation domain object
sample = Sample('xyz',XYZ,'relaxivity',rel,'concentration',conc(:),'T1',T1,'Curie',M0);

%then do bloch sims========================================================

%ideal case (perfectly homogeneous field - no coil supplied)
bloch = BlochDremr('pulse',pulse1,'sample',sample,'B0',B0); %-dB
Mz = calcMag(bloch);
Mz1 = reshape(Mz,size(X));

bloch = BlochDremr('pulse',pulse2,'sample',sample,'B0',B0); %+dB
Mz = calcMag(bloch);
Mz2 = reshape(Mz,size(X));
Iid = Mz1*(B0/(B0+pulse1.dB)) - Mz2*(B0/(B0+pulse2.dB)); %dreMR subtract
