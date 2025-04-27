% ANOVA: Actual vs Linear pH
pH_actual = [8.2, 8.3, 8.4, 8.5, 8.6];
pH_linear = [8.14, 8.24, 8.34, 8.44, 8.54];
group_linear = [ones(1,5), 2*ones(1,5)];
[p_ph_linear, ~] = anova1([pH_actual, pH_linear], group_linear, 'off');
fprintf('pH - Actual vs Linear ANOVA p-value: %.4f, Significant: %d\n', p_ph_linear, p_ph_linear < 0.05);

% ANOVA: Actual vs ARIMA pH
pH_arima = [8.19, 8.27, 8.35, 8.43, 8.51];
group_arima = [ones(1,5), 2*ones(1,5)];
[p_ph_arima, ~] = anova1([pH_actual, pH_arima], group_arima, 'off');
fprintf('pH - Actual vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_ph_arima, p_ph_arima < 0.05);

pH_linear = [8.14, 8.24, 8.34, 8.44, 8.54];
pH_arima = [8.19, 8.27, 8.35, 8.43, 8.51];
group = [ones(1,5), 2*ones(1,5)];
[p_ph_methods, ~] = anova1([pH_linear, pH_arima], group, 'off');
fprintf('pH - Linear vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_ph_methods, p_ph_methods < 0.05);


% ANOVA: Actual vs Linear Protein
protein_actual = [325, 335, 345, 355, 365];
protein_linear = [325.85, 336.01, 346.18, 356.34, 366.54];
group_linear = [ones(1,5), 2*ones(1,5)];
[p_protein_linear, ~] = anova1([protein_actual, protein_linear], group_linear, 'off');
fprintf('Protein - Actual vs Linear ANOVA p-value: %.4f, Significant: %d\n', p_protein_linear, p_protein_linear < 0.05);

protein_linear = [325.85, 336.01, 346.18, 356.34, 366.54];
protein_arima = [322.98, 330.35, 337.54, 344.69, 351.81];
group = [ones(1,5), 2*ones(1,5)];
[p_protein_methods, ~] = anova1([protein_linear, protein_arima], group, 'off');
fprintf('Protein - Linear vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_protein_methods, p_protein_methods < 0.05);


% ANOVA: Actual vs ARIMA Protein
protein_arima = [322.98, 330.35, 337.54, 344.69, 351.81];
group_arima = [ones(1,5), 2*ones(1,5)];
[p_protein_arima, ~] = anova1([protein_actual, protein_arima], group_arima, 'off');
fprintf('Protein - Actual vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_protein_arima, p_protein_arima < 0.05);

% ANOVA: Actual vs Linear Glucose
glucose_actual = [300, 280, 260, 240, 220];
glucose_linear = [311.53, 292.20, 272.87, 253.54, 234.21];
group_linear = [ones(1,5), 2*ones(1,5)];
[p_glucose_linear, ~] = anova1([glucose_actual, glucose_linear], group_linear, 'off');
fprintf('Glucose - Actual vs Linear ANOVA p-value: %.4f, Significant: %d\n', p_glucose_linear, p_glucose_linear < 0.05);

% ANOVA: Actual vs ARIMA Glucose
glucose_arima = [317.34, 324.58, 331.83, 339.08, 346.32];
group_arima = [ones(1,5), 2*ones(1,5)];
[p_glucose_arima, ~] = anova1([glucose_actual, glucose_arima], group_arima, 'off');
fprintf('Glucose - Actual vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_glucose_arima, p_glucose_arima < 0.05);

glucose_linear = [311.53, 292.20, 272.87, 253.54, 234.21];
glucose_arima = [317.34, 324.58, 331.83, 339.08, 346.32];
group = [ones(1,5), 2*ones(1,5)];
[p_glucose_methods, ~] = anova1([glucose_linear, glucose_arima], group, 'off');
fprintf('Glucose - Linear vs ARIMA ANOVA p-value: %.4f, Significant: %d\n', p_glucose_methods, p_glucose_methods < 0.05);
