% M McCready, 2021
% This script creates Figure 5 of the manuscript "An improved homogeneity 
% design method for fast field-cycling coils in molecular MRI" by M
% Mcready, W Handler, and B Chronik (2021). It cannot be run without an
% extensive library for simulating electromagnetic coils developed by the
% xMR Lab at University of Western Ontario (UWO) and relaxivity data
% provided by privated correspondance with T Scholl and F Martinez at UWO.

B0 = 0.5;%static field with no dreMR pulse

%need to get our coils======================================================

load('NewCoil.mat'); %loads in Elems object representing new design

load('OldCoil.mat'); %loads in Elems object representing old design

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

%getting relaxivity data
load('relaxivity.mat');
rel = relaxivity(:,[1 3]);%Vivotrax (<1.5T)
rel(:,2) = 1e3*rel(:,2);%changing units to per uM

%homogenous concentration (160 uM)
conc = ones(size(X))*160e-6;

%background T1 and T2 of blood
T1 = 1.2; %T1 can be spatially dependent for non-uniform domain

%Equilibrium magnetization without field factored in (i.e. magnetization
%per Tesla)
M0=1;

%making the simulation domain object
sample = Sample('xyz',XYZ,'relaxivity',rel,'concentration',conc(:),'T1',T1,'Curie',M0);

%then do bloch sims========================================================

%simulation using old coil design
bloch = BlochDremr('pulse',pulse1,'sample',sample,'coil',oldcoil,'B0',B0);%-dB
Mz = calcMag(bloch);
Mz1 = reshape(Mz,size(X));

bloch = BlochDremr('pulse',pulse2,'sample',sample,'coil',oldcoil,'B0',B0);%+dB
Mz = calcMag(bloch);
Mz2 = reshape(Mz,size(X));

Iold = Mz1*(B0/(B0+pulse1.dB)) - Mz2*(B0/(B0+pulse2.dB)); %dreMR subtract

%simulation using new coil design
bloch = BlochDremr('pulse',pulse1,'sample',sample,'coil',newcoil,'B0',B0);%-dB
Mz = calcMag(bloch);
Mz1 = reshape(Mz,size(X));

bloch = BlochDremr('pulse',pulse2,'sample',sample,'coil',newcoil,'B0',B0);%+dB
Mz = calcMag(bloch);
Mz2 = reshape(Mz,size(X));

Inew = Mz1*(B0/(B0+pulse1.dB)) - Mz2*(B0/(B0+pulse2.dB)); %dreMR subtract

%ideal case (perfectly homogeneous field - no coil supplied)
bloch = BlochDremr('pulse',pulse1,'sample',sample,'B0',B0); %-dB
Mz = calcMag(bloch);
Mz1 = reshape(Mz,size(X));

bloch = BlochDremr('pulse',pulse2,'sample',sample,'B0',B0); %+dB
Mz = calcMag(bloch);
Mz2 = reshape(Mz,size(X));
Iid = Mz1*(B0/(B0+pulse1.dB)) - Mz2*(B0/(B0+pulse2.dB)); %dreMR subtract

%get percent differences===================================================
pdiffold = 100*abs(Iold-Iid)./abs(Iid);
pdiffnew = 100*abs(Inew-Iid)./abs(Iid);

%making figures============================================================

%old coil design
figure();surf(100*X,100*Z,pdiffold,'EdgeColor','none');view([0 0 1])
c = colorbar;c.Label.String = '% Difference';c.FontSize = 12;
xlabel('x (cm)');ylabel('z (cm)');
colormap gray;axis image
caxis([0 12])

figure()
h=histogram(pdiffold,25,'Normalization','probability');
ylim([0 1]);xlim([h.BinEdges(1) h.BinEdges(end)])
ylabel('Fraction of pixels');

%new coil design
figure();surf(100*X,100*Z,pdiffnew,'EdgeColor','none');view([0 0 1])
c = colorbar;c.Label.String = '% Difference';c.FontSize = 12;
xlabel('x (cm)');ylabel('z (cm)');
colormap gray;axis image
caxis([0 12])

figure()
h=histogram(pdiffnew,h.BinEdges,'Normalization','probability');
ylim([0 1]);xlim([h.BinEdges(1) h.BinEdges(end)])
ylabel('Fraction of pixels');