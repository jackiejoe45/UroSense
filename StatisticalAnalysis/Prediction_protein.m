% Protein Values Analysis
actual_protein = [325; 335; 345; 355; 365];
linear_model = [325.85; 336.01; 346.18; 356.34; 366.54];
arima_model = [322.98; 330.35; 337.54; 344.69; 351.81];

models = {linear_model, arima_model};
model_names = {'Linear Model', 'ARIMA Model'};

% Initialize arrays
means = zeros(length(actual_protein), 3); % [Actual, Linear, ARIMA]
p_values = zeros(length(actual_protein), 2);
significant = zeros(length(actual_protein), 2);

% Store means
means(:,1) = actual_protein;
for j = 1:2
    means(:,j+1) = models{j};

    for i = 1:length(actual_protein)
        % Single sample t-test
        [~, p] = ttest(models{j}(i), actual_protein(i));
        p_values(i,j) = p;
        significant(i,j) = p < 0.05;

        fprintf('Protein %.0f, %s: Predicted = %.2f, p = %.4f, Significant = %d\n', ...
                actual_protein(i), model_names{j}, models{j}(i), p, significant(i,j));
    end
end

% Error metrics
rmse = zeros(1,2);
mae = zeros(1,2);
for j = 1:2
    rmse(j) = sqrt(mean((models{j} - actual_protein).^2));
    mae(j) = mean(abs(models{j} - actual_protein));
    fprintf('%s: RMSE = %.4f, MAE = %.4f\n', model_names{j}, rmse(j), mae(j));
end

% Visualization
figure('Position', [100, 100, 1000, 600]);
bar_width = 0.2;
positions = 1:length(actual_protein);

colors = {[0 0 0], [0.12 0.47 0.71], [0.84 0.15 0.16]};
bar(positions, means(:,1), bar_width, 'FaceColor', colors{1});
hold on;

for j = 1:2
    pos = positions + j * bar_width;
    bar(pos, means(:,j+1), bar_width, 'FaceColor', colors{j+1});
    
    for i = 1:length(actual_protein)
        if significant(i,j)
            text(pos(i), means(i,j+1) + 1, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 14);
        end
    end
end

xticks(positions + bar_width);
xticklabels(arrayfun(@(x) sprintf('%d', x), actual_protein, 'UniformOutput', false));
xlabel('Actual Protein Values (mg/dL)', 'FontSize', 14);
ylabel('Predicted Protein', 'FontSize', 14);
title('Protein Prediction Comparison: Linear vs ARIMA', 'FontSize', 16);
legend({'Actual', 'Linear Model', 'ARIMA Model'}, 'Location', 'northwest');
grid on;

% Error Metrics Plot
figure('Position', [100, 100, 800, 500]);
errors = [rmse; mae]';
bar(errors, 'grouped');
set(gca, 'XTickLabel', model_names);
xlabel('Model Type', 'FontSize', 14);
ylabel('Error Metrics (mg/dL)', 'FontSize', 14);
title('Protein Prediction Accuracy', 'FontSize', 16);
legend({'RMSE', 'MAE'}, 'Location', 'best');
grid on;
