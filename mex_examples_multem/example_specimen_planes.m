clear all; clc;

input_multislice = multem_default_values();         % Load default values;

input_multislice.pn_model = 1;                  % ePM_Still_Atom = 1, ePM_Absorptive = 2, ePM_Frozen_Phonon = 3
input_multislice.interaction_model = 1;             % eESIM_Multislice = 1, eESIM_Phase_Object = 2, eESIM_Weak_Phase_Object = 3
input_multislice.potential_slicing = 1;             % ePS_Planes = 1, ePS_dz_Proj = 2, ePS_dz_Sub = 3, ePS_Auto = 4
input_multislice.pn_dim = 110; 
input_multislice.pn_seed = 300183; 
input_multislice.pn_nconf = 1;

input_multislice.spec_rot_theta = 0;                      % final angle
input_multislice.spec_rot_u0 = [1 0 0]; 					% unitary vector			
input_multislice.spec_rot_center_type = 1; 			% 1: geometric center, 2: User define		
input_multislice.spec_rot_center_p = [0 0 0];					% rotation point

na = 6; nb = 6; nc = 10; ncu = 2; rms3d = 0.15;

[input_multislice.spec_atoms, input_multislice.spec_lx...
, input_multislice.spec_ly, input_multislice.spec_lz...
, a, b, c, input_multislice.spec_dz] = Au001Crystal(na, nb, nc, ncu, rms3d);

% occ = 1;
% region = 0;
% charge = 0;
% [input_multislice.spec_atoms, input_multislice.spec_lx, input_multislice.spec_ly, lz] = graphene(1, 1.42, sqrt(0.5/(8*pi^2)));
% input_multislice.spec_dz = 0.5;

input_multislice.spec_dz = 2;

disp([min(input_multislice.spec_atoms(:, 4)), max(input_multislice.spec_atoms(:,4))])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lz = 20;
Z = 6;
rms_3d = 0.09;
d_min = 1.4;
seed = 1983;
rho = 2.2;
lay_pos = 2; %1: top, 2: bottom

z_min = min(input_multislice.spec_atoms(:, 4));
z_max = max(input_multislice.spec_atoms(:, 4));
tic;
input_multislice.spec_atoms = il_add_amorp_lay(input_multislice.spec_atoms, input_multislice.spec_lx, input_multislice.spec_ly, lz, d_min, Z, rms_3d, rho, lay_pos, seed);
toc;

if(lay_pos==1)
    input_multislice.spec_amorp(1).z_0 = z_min-lz;          % Starting z position of the amorphous layer (�)
    input_multislice.spec_amorp(1).z_e = z_min;             % Ending z position of the amorphous layer (�)
else
    input_multislice.spec_amorp(1).z_0 = z_max;             % Starting z position of the amorphous layer (�)
    input_multislice.spec_amorp(1).z_e = z_max+lz;          % Ending z position of the amorphous layer (�)
end
input_multislice.spec_amorp(1).dz = 2.0;                    % slice thick of the amorphous layer (�)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lz = 10;
Z = 6;
rms_3d = 0.09;
d_min = 1.4;
seed = 1983;
rho = 2.2;
lay_pos = 1; %1: top, 2: bottom

z_min = min(input_multislice.spec_atoms(:, 4));
z_max = max(input_multislice.spec_atoms(:, 4));

tic;
input_multislice.spec_atoms = il_add_amorp_lay(input_multislice.spec_atoms, input_multislice.spec_lx, input_multislice.spec_ly, lz, d_min, Z, rms_3d, rho, lay_pos, seed);
toc;

if(lay_pos==1)

    input_multislice.spec_amorp(2).z_0 = z_min-lz;          % Starting z position of the amorphous layer (�)
    input_multislice.spec_amorp(2).z_e = z_min;             % Ending z position of the amorphous layer (�)
else
    input_multislice.spec_amorp(2).z_0 = z_max;             % Starting z position of the amorphous layer (�)
    input_multislice.spec_amorp(2).z_e = z_max+lz;          % Ending z position of the amorphous layer (�)
end
input_multislice.spec_amorp(2).dz = 2.0;                    % slice thick of the amorphous layer (�)

show_crystal(1, input_multislice.spec_atoms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
tic;
[z_planes] = il_spec_planes(input_multislice);
toc;
diff(z_planes)
[nplanes, ~] = size(z_planes);
disp(['Number of slices = ', num2str(nplanes)])

figure(1); clf;
plot(input_multislice.spec_atoms(:, 3), input_multislice.spec_atoms(:, 4), 'ok');
set(gca,'ydir','reverse');
set(gca,'FontSize',12,'LineWidth',1,'PlotBoxAspectRatio',[1.25 1 1]);
title('Atomic positions');
ylabel('y','FontSize',14);
xlabel('x','FontSize',12);
axis equal;

for i = 1:nplanes
    hold on;
    plot([-2 input_multislice.spec_lx], [z_planes(i) z_planes(i)], '-r');    
    axis equal;
end
axis([-2, 18, min(input_multislice.spec_atoms(:, 4))-5, max(input_multislice.spec_atoms(:, 4))+5]);

% nbins = floor((max(input_multislice.spec_atoms(:, 4))-min(input_multislice.spec_atoms(:, 4)))/0.10001);
% tic;
% [x, y] = il_hist(input_multislice.spec_atoms(:, 4), nbins-1);
% toc;
% 
% figure(2); clf;
% plot(x, y, '-+r');
% hold on;
% ii = find(y<0.5);
% plot(x(ii), y(ii), '.b');