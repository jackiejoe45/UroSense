% Protein Concentration Measurements Data
% Define the data matrix
true_protein = [0; 0; 0; 30; 30; 30; 100; 100; 100; 300; 300; 300];
sample_num = [1; 2; 3; 1; 2; 3; 1; 2; 3; 1; 2; 3];
A = [0; 0; 0; 30; 0; 30; 100; 140; 100; 300; 300; 300];
B = [0; 30; 0; 30; 0; 30; 30; 100; 100; 15; 100; 15];
C = [0; 30; 0; 30; 0; 0; 30; 30; 86; 300; 100; 30];
D = [0; 30; 0; 30; 0; 0; 30; 100; 100; 15; 15; 15];

% Create unique protein levels for analysis
unique_protein = unique(true_protein);

% Initialize arrays to store summary statistics
means = zeros(length(unique_protein), 5); % [True protein, A, B, C, D]
stds = zeros(length(unique_protein), 4);  % [A, B, C, D]
p_values = zeros(length(unique_protein), 4); % [A, B, C, D]
significant = zeros(length(unique_protein), 4); % [A, B, C, D]

% Calculate statistics for each protein level
for i = 1:length(unique_protein)
    protein = unique_protein(i);
    indices = true_protein == protein;
    
    % Store true protein concentration
    means(i, 1) = protein;
    
    % Calculate statistics for each sample
    samples = {A(indices), B(indices), C(indices), D(indices)};
    sample_names = {'A', 'B', 'C', 'D'};
    
    for j = 1:4
        % Calculate mean and std
        means(i, j+1) = mean(samples{j});
        stds(i, j) = std(samples{j});
        
        % Perform t-test against true protein concentration
        [~, p] = ttest(samples{j}, protein);
        p_values(i, j) = p;
        significant(i, j) = p < 0.05;
        
        % Print results
        fprintf('Protein %.1f, Sample %s: Mean = %.2f, SD = %.2f, p = %.4f, Significant = %d\n', ...
                protein, sample_names{j}, means(i, j+1), stds(i, j), p_values(i, j), significant(i, j));
    end
end

% Calculate overall error metrics
rmse = zeros(1, 4);
mae = zeros(1, 4);
all_samples = {A, B, C, D};

for j = 1:4
    % Calculate RMSE
    rmse(j) = sqrt(mean((all_samples{j} - true_protein).^2));
    % Calculate MAE
    mae(j) = mean(abs(all_samples{j} - true_protein));
    
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
true_protein_positions = 1:length(unique_protein);

% Define colors for the bars
colors = {[0 0 0], [0.12 0.47 0.71], [0.17 0.63 0.17], [0.84 0.15 0.16], [0.58 0.40 0.74]};

% Plot true protein values as bars
bar_h = bar(true_protein_positions, means(:,1), bar_width, 'FaceColor', colors{1});
hold on;

% Plot each sample's measurements with error bars
legend_handles = [bar_h];
legend_names = {'True Protein'};

for i = 1:4
    positions = true_protein_positions + i * bar_width;
    bar_h = bar(positions, means(:,i+1), bar_width, 'FaceColor', colors{i+1});
    legend_handles = [legend_handles; bar_h];
    legend_names = [legend_names, {['Sample ' sample_names{i}]}];
    
    % Add error bars
    for j = 1:length(unique_protein)
        errorbar(positions(j), means(j,i+1),0, stds(j,i), 'k', 'LineStyle', 'none', 'LineWidth', 1.5);
        
        % Add asterisks for significance
        % if significant(j, i)
        %     text(positions(j), means(j,i+1) + stds(j,i) + 15, '*', ...
        %         'HorizontalAlignment', 'center', 'FontSize', 14);
        % end
    end
end

% Customize the plot
xlabel('True Protein Concentration (mg/L)', 'FontSize', 14);
ylabel('Measured Protein Concentration (mg/L)', 'FontSize', 14);
title('Protein Concentration Measurements Across Different Samples', 'FontSize', 16);
xticks(true_protein_positions + 2.5 * bar_width);
xticklabels(unique_protein);
if max(means(:) + max(stds(:))) > 320
    ylim([0 max(means(:) + max(stds(:))) * 1.1]);
else
    ylim([0 320]);
end
legend(legend_handles, legend_names, 'Location', 'northwest');
grid on;

% Add a text box with information
% text_str = 'Error bars: standard deviation (n=3)\n* indicates p < 0.05 (significantly different from true protein)';
% annotation('textbox', [0.02, 0.02, 0.5, 0.05], 'String', text_str, ...
%            'FitBoxToText', 'on', 'BackgroundColor', 'white');

% Create a second figure for accuracy comparison
figure('Position', [100, 100, 800, 500]);
% Combine RMSE and MAE into one matrix for grouped bars
errors = [rmse; mae]';  % 4x2 matrix: rows = samples, cols = [RMSE, MAE]

% Plot grouped bar chart
bar(errors, 'grouped');
set(gca, 'XTickLabel', sample_names);

xticks(1:4 + 0.3);
xticklabels(sample_names);
xlabel('Sample Type', 'FontSize', 14);
ylabel('Error Metrics', 'FontSize', 14);
title('Protein Measurement Accuracy by Sample Type', 'FontSize', 16);
legend({'RMSE', 'MAE'}, 'Location', 'best');
grid on;