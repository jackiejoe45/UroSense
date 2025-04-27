% Glucose Prediction Analysis
actual_glucose = [300; 280; 260; 240; 220];
linear_model = [311.53; 292.20; 272.87; 253.54; 234.21];
arima_model = [317.34; 324.58; 331.83; 339.08; 346.32];

models = {linear_model, arima_model};
model_names = {'Linear Model', 'ARIMA Model'};

% Initialize arrays
means = zeros(length(actual_glucose), 3); % [Actual, Linear, ARIMA]
p_values = zeros(length(actual_glucose), 2);
significant = zeros(length(actual_glucose), 2);

% Store means
means(:,1) = actual_glucose;
for j = 1:2
    means(:,j+1) = models{j};

    for i = 1:length(actual_glucose)
        [~, p] = ttest(models{j}(i), actual_glucose(i));
        p_values(i,j) = p;
        significant(i,j) = p < 0.05;

        fprintf('Glucose %.0f, %s: Predicted = %.2f, p = %.4f, Significant = %d\n', ...
                actual_glucose(i), model_names{j}, models{j}(i), p, significant(i,j));
    end
end

% Error metrics
rmse = zeros(1,2);
mae = zeros(1,2);
for j = 1:2
    rmse(j) = sqrt(mean((models{j} - actual_glucose).^2));
    mae(j) = mean(abs(models{j} - actual_glucose));
    fprintf('%s: RMSE = %.4f, MAE = %.4f\n', model_names{j}, rmse(j), mae(j));
end

% Visualization
figure('Position', [100, 100, 1000, 600]);
bar_width = 0.2;
positions = 1:length(actual_glucose);

colors = {[0 0 0], [0.12 0.47 0.71], [0.84 0.15 0.16]};
bar(positions, means(:,1), bar_width, 'FaceColor', colors{1});
hold on;

for j = 1:2
    pos = positions + j * bar_width;
    bar(pos, means(:,j+1), bar_width, 'FaceColor', colors{j+1});
    
    for i = 1:length(actual_glucose)
        if significant(i,j)
            text(pos(i), means(i,j+1) + 1, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 14);
        end
    end
end

xticks(positions + bar_width);
xticklabels(arrayfun(@(x) sprintf('%d', x), actual_glucose, 'UniformOutput', false));
xlabel('Actual Glucose Values (mg/dL)', 'FontSize', 14);
ylabel('Predicted Glucose', 'FontSize', 14);
title('Glucose Prediction Comparison: Linear vs ARIMA', 'FontSize', 16);
legend({'Actual', 'Linear Model', 'ARIMA Model'}, 'Location', 'northwest');
grid on;

% Error Metrics Plot
figure('Position', [100, 100, 800, 500]);
errors = [rmse; mae]';
bar(errors, 'grouped');
set(gca, 'XTickLabel', model_names);
xlabel('Model Type', 'FontSize', 14);
ylabel('Error Metrics (mg/dL)', 'FontSize', 14);
title('Glucose Prediction Accuracy', 'FontSize', 16);
legend({'RMSE', 'MAE'}, 'Location', 'best');
grid on;
