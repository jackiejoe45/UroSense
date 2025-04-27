% Line graph for pH
figure;
x = 1:5;
actual_ph = [8.2, 8.3, 8.4, 8.5, 8.6];
linear_ph = [8.14, 8.24, 8.34, 8.44, 8.54];
arima_ph = [8.19, 8.27, 8.35, 8.43, 8.51];

plot(x, actual_ph, '-ko', 'LineWidth', 2, 'DisplayName', 'Actual');
hold on;
plot(x, linear_ph, '-b^', 'LineWidth', 2, 'DisplayName', 'Linear Model');
plot(x, arima_ph, '-rs', 'LineWidth', 2, 'DisplayName', 'ARIMA Model');
grid on;
title('pH Predictions');
xlabel('Sample Index');
ylabel('pH Value');
legend('Location', 'northwest');

% Line graph for Protein
figure;
x = 1:5;
actual_protein = [325, 335, 345, 355, 365];
linear_protein = [325.85, 336.01, 346.18, 356.34, 366.54];
arima_protein = [322.98, 330.35, 337.54, 344.69, 351.81];

plot(x, actual_protein, '-ko', 'LineWidth', 2, 'DisplayName', 'Actual');
hold on;
plot(x, linear_protein, '-b^', 'LineWidth', 2, 'DisplayName', 'Linear Model');
plot(x, arima_protein, '-rs', 'LineWidth', 2, 'DisplayName', 'ARIMA Model');
grid on;
title('Protein Predictions');
xlabel('Sample Index');
ylabel('Protein (mg/dL)');
legend('Location', 'northwest');

% Line graph for Glucose
figure;
x = 1:5;
actual_glucose = [300, 280, 260, 240, 220];
linear_glucose = [311.53, 292.20, 272.87, 253.54, 234.21];
arima_glucose = [317.34, 324.58, 331.83, 339.08, 346.32];

plot(x, actual_glucose, '-ko', 'LineWidth', 2, 'DisplayName', 'Actual');
hold on;
plot(x, linear_glucose, '-b^', 'LineWidth', 2, 'DisplayName', 'Linear Model');
plot(x, arima_glucose, '-rs', 'LineWidth', 2, 'DisplayName', 'ARIMA Model');
grid on;
title('Glucose Predictions');
xlabel('Sample Index');
ylabel('Glucose (mg/dL)');
legend('Location', 'northwest');

