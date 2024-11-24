% MATLAB script to read OpenFOAM forces output and plot total Fx
close all
clear all

% Specify the filename
filename = 'force.dat'; % Change this to your actual file name

% Open the file
fileID = fopen(filename, 'r');

% Skip header lines (Assuming header lines are constant)
for i = 1:4
    fgetl(fileID); % Skip header lines (the first four lines)
end

% Initialize arrays to store data
time = [];
total_Fx = [];

% Read data line by line
while ~feof(fileID)
    % Read one line as a string
    line = fgetl(fileID);
    
    % Convert the string into numbers
    data = sscanf(line, '%f');
    
    % Check if the line has correct data format (10 columns)
    if length(data) == 10
        % Extract relevant values
        time(end+1) = data(1);          % Time or iteration
        total_Fx(end+1) = data(2);      % Total force in x-direction
    end
end

% Close the file
fclose(fileID);

mean_total_Fx_lastIters = mean(total_Fx(end-500:end))

% Plotting
figure(1);
plot(time, total_Fx, 'LineWidth', 1.5);
xlabel('Iterations');
ylabel('Total Force in x-direction (Fx) [N]');
title('Total Fx vs Iterations');
grid on;
ylim([0.26,0.46])

hold on 
yline(mean_total_Fx_lastIters, 'LineWidth', 1.5);


%% Drag coefficient calculation
Aref = 0.008597;    % without roof rack: 0.008597     % with roof rack :  0.0128;
Uinf = 14;
rho = 1; % IN OPENFOAM WITH INCOMPRESSIBLE FLOW, THE DEFAULT RHO IS EQUAL TO 1;

total_Cx = total_Fx / (0.5 * Aref * Uinf^2);
mean_total_Cx_lastIters = mean(total_Cx(end-500:end))

% Plotting
figure(2);
plot(time, total_Cx, 'LineWidth', 1.5);
xlabel('Iterations');
ylabel('Total Force Coefficient in x-direction (Cx) []');
title('Total Cx vs Iterations');
grid on;
ylim([0.33,0.5])

hold on 
yline(mean_total_Cx_lastIters, 'LineWidth', 1.5);



