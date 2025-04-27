% pH Measurements data
% Define the data matrix
true_pH = [5.5; 5.5; 5.5; 6.5; 6.5; 6.5; 7.5; 7.5; 7.5; 8.5; 8.5; 8.5];
sample_num = [1; 2; 3; 1; 2; 3; 1; 2; 3; 1; 2; 3];
A = [5.0; 5.9; 5.9; 6.5; 6.5; 6.5; 7.5; 7.5; 7.5; 8.0; 8.0; 8.0];
B = [5.0; 5.0; 5.0; 6.5; 5.0; 7.0; 7.5; 7.5; 7.5; 7.0; 7.0; 7.0];
C = [5.0; 6.5; 6.5; 6.5; 6.5; 6.5; 7.5; 7.0; 7.0; 8.0; 8.0; 8.0];
D = [5.0; 6.5; 5.0; 5.0; 5.0; 6.5; 7.5; 7.0; 7.0; 8.0; 8.0; 8.0];

% Create unique pH levels for analysis
unique_pH = unique(true_pH);

% Initialize arrays to store summary statistics
means = zeros(length(unique_pH), 5); % [True pH, A, B, C, D]
stds = zeros(length(unique_pH), 4);  % [A, B, C, D]
p_values = zeros(length(unique_pH), 4); % [A, B, C, D]
significant = zeros(length(unique_pH), 4); % [A, B, C, D]

% Calculate statistics for each pH level
for i = 1:length(unique_pH)
    pH = unique_pH(i);
    indices = true_pH == pH;
    
    % Store true pH
    means(i, 1) = pH;
    
    % Calculate statistics for each sample
    samples = {A(indices), B(indices), C(indices), D(indices)};
    sample_names = {'A', 'B', 'C', 'D'};
    
    for j = 1:4
        % Calculate mean and std
        means(i, j+1) = mean(samples{j});
        stds(i, j) = std(samples{j});
        
        % Perform t-test against true pH
        [~, p] = ttest(samples{j}, pH);
        p_values(i, j) = p;
        significant(i, j) = p < 0.05;
        
        % Print results
        fprintf('pH %.1f, Sample %s: Mean = %.2f, SD = %.2f, p = %.4f, Significant = %d\n', ...
                pH, sample_names{j}, means(i, j+1), stds(i, j), p_values(i, j), significant(i, j));
    end
end

% Calculate overall error metrics
rmse = zeros(1, 4);
mae = zeros(1, 4);
all_samples = {A, B, C, D};

for j = 1:4
    % Calculate RMSE
    rmse(j) = sqrt(mean((all_samples{j} - true_pH).^2));
    % Calculate MAE
    mae(j) = mean(abs(all_samples{j} - true_pH));
    
    fprintf('Sample %s: RMSE = %.3f, MAE = %.3f\n', ...
            sample_names{j}, rmse(j), mae(j));
end

% ANOVA between all samples
samples_combined = [A; B; C; D];
group = [ones(size(A)); 2*ones(size(B)); 3*ones(size(C)); 4*ones(size(D))];
[p, tbl] = anova1(samples_combined, group, 'off');
fprintf('ANOVA p-value: %.4f, Significant difference between samples: %d\n', p, p < 0.05);

% Create figure for visualization
figure('Position', [100, 100, 1000, 600]);

% Define bar width and positions
bar_width = 0.15;
true_pH_positions = 1:length(unique_pH);

% Define colors for the bars
colors = {[0 0 0], [0.12 0.47 0.71], [0.17 0.63 0.17], [0.84 0.15 0.16], [0.58 0.40 0.74]};

% Plot true pH values as bars
bar_h = bar(true_pH_positions, means(:,1), bar_width, 'FaceColor', colors{1});
hold on;

% Plot each sample's measurements with error bars
legend_handles = [bar_h];
legend_names = {'True pH'};

for i = 1:4
    positions = true_pH_positions + i * bar_width;
    bar_h = bar(positions, means(:,i+1), bar_width, 'FaceColor', colors{i+1});
    legend_handles = [legend_handles; bar_h];
    legend_names = [legend_names, {['Sample ' sample_names{i}]}];
    
    % Add error bars
    for j = 1:length(unique_pH)
        errorbar(positions(j), means(j,i+1), 0, stds(j,i), 'k', 'LineStyle', 'none', 'LineWidth', 1.5);
        
        % Add asterisks for significance
        % if significant(j, i)
        %     text(positions(j), means(j,i+1) + stds(j,i) + 0.1, '*', ...
        %         'HorizontalAlignment', 'center', 'FontSize', 14);
        % end
    end
end

% Customize the plot
xlabel('pH Values', 'FontSize', 14);
ylabel('Measured pH', 'FontSize', 14);
title('pH Measurements Across Different Samples', 'FontSize', 16);
xticks(true_pH_positions + 2.5 * bar_width);
xticklabels(unique_pH);
ylim([0 9]);
legend(legend_handles, legend_names, 'Location', 'northwest');
grid on;

% Add a text box with information
% text_str = 'Error bars: standard deviation (n=3)\n.* indicates p < 0.05 (significantly different from true pH)';
% annotation('textbox', [0.02, 0.02, 0.4, 0.05], 'String', text_str, ...
%            'FitBoxToText', 'on', 'BackgroundColor', 'white');

% Create a second figure for accuracy comparison
figure('Position', [100, 100, 800, 500]);
% Combine RMSE and MAE into one matrix for grouped bars
errors = [rmse; mae]';  % 4x2 matrix: rows = samples, cols = [RMSE, MAE]

% Plot grouped bar chart
bar(errors, 'grouped');
set(gca, 'XTickLabel', sample_names);

% Customize appearance
legend({'RMSE', 'MAE'}, 'Location', 'best');
xlabel('Sample Type', 'FontSize', 14);
ylabel('Error Metrics', 'FontSize', 14);
title('Measurement Accuracy by Sample Type', 'FontSize', 16);
grid on;
