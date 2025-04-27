% pH Values Analysis
actual_pH = [8.2; 8.3; 8.4; 8.5; 8.6];
linear_model = [8.14; 8.24; 8.34; 8.44; 8.54];
arima_model = [8.19; 8.27; 8.35; 8.43; 8.51];

models = {linear_model, arima_model};
model_names = {'Linear Model', 'ARIMA Model'};

% Initialize arrays
means = zeros(length(actual_pH), 3); % [Actual, Linear, ARIMA]
stds = zeros(length(actual_pH), 2);  % [Linear, ARIMA] - no variation given, set to zero
p_values = zeros(length(actual_pH), 2);
significant = zeros(length(actual_pH), 2);

% Calculate statistics
means(:,1) = actual_pH;
for j = 1:2
    means(:,j+1) = models{j};
    stds(:,j) = zeros(size(actual_pH)); % No repeated measures, std assumed zero

    for i = 1:length(actual_pH)
        % Single sample t-test
        [~, p] = ttest(models{j}(i), actual_pH(i));
        p_values(i,j) = p;
        significant(i,j) = p < 0.05;

        fprintf('pH %.1f, %s: Predicted = %.2f, p = %.4f, Significant = %d\n', ...
                actual_pH(i), model_names{j}, models{j}(i), p, significant(i,j));
    end
end

% Error metrics
rmse = zeros(1,2);
mae = zeros(1,2);
for j = 1:2
    rmse(j) = sqrt(mean((models{j} - actual_pH).^2));
    mae(j) = mean(abs(models{j} - actual_pH));
    fprintf('%s: RMSE = %.4f, MAE = %.4f\n', model_names{j}, rmse(j), mae(j));
end

% Visualization
figure('Position', [100, 100, 1000, 600]);
bar_width = 0.2;
positions = 1:length(actual_pH);

colors = {[0 0 0], [0.12 0.47 0.71], [0.84 0.15 0.16]};
bar(positions, means(:,1), bar_width, 'FaceColor', colors{1});
hold on;

for j = 1:2
    pos = positions + j * bar_width;
    bar(pos, means(:,j+1), bar_width, 'FaceColor', colors{j+1});
    
    for i = 1:length(actual_pH)
        if significant(i,j)
            text(pos(i), means(i,j+1) + 0.02, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 14);
        end
    end
end

xticks(positions + bar_width);
xticklabels(arrayfun(@(x) sprintf('%.1f', x), actual_pH, 'UniformOutput', false));
xlabel('Actual pH Values', 'FontSize', 14);
ylabel('Predicted pH', 'FontSize', 14);
title('pH Prediction Comparison: Linear vs ARIMA', 'FontSize', 16);
legend({'Actual', 'Linear Model', 'ARIMA Model'}, 'Location', 'northwest');
grid on;

% Error Metrics Plot
figure('Position', [100, 100, 800, 500]);
errors = [rmse; mae]';
bar(errors, 'grouped');
set(gca, 'XTickLabel', model_names);
xlabel('Model Type', 'FontSize', 14);
ylabel('Error Metrics', 'FontSize', 14);
title('pH Prediction Accuracy', 'FontSize', 16);
legend({'RMSE', 'MAE'}, 'Location', 'best');
grid on;
% Line graph for pH
figure;
x = 1:5;
actual_ph = [8.2, 8.3, 8.4, 8.5, 8.6];
linear_ph = [8.14, 8.24, 8.34, 8.44, 8.54];
arima_ph = [8.19, 8.27, 8.35, 8.43, 8.51];

plot(x, actual_ph, '-ko', 'LineWidth', 2, 'DisplayName', 'Actual');
hold on;
plot(x, linear_ph, '-bo', 'LineWidth', 2, 'DisplayName', 'Linear Model');
plot(x, arima_ph, '-ro', 'LineWidth', 2, 'DisplayName', 'ARIMA Model');
grid on;
title('pH Predictions');
xlabel('Sample Index');
ylabel('pH Value');
legend('Location', 'northwest');
