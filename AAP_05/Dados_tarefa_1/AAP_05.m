%==========================================================================
% Disciplina: Comunicações Sem Fio 
% AAP 05 - Medição do canal sem fio usando o CC1350
%==========================================================================

% Organização do console ------------------------------------------
clc; 
clear; 
close all;
format shortEng



% Carregamento dos Dados ------------------------------------------

data_05m = load("dados_meio_m.mat"); 
data_1m = load("dados_1m.mat"); 
data_2m = load("dados_2m.mat"); 
data_3m = load("dados_3m.mat"); 
data_4m = load("dados_4m.mat"); 
data_5m = load("dados_5m.mat"); 



% Cálculo das médias de RSSI --------------------------------------

Pr_d0 = mean(data_05m.dados_meio_m(:,3));  
RSSI_1m = mean(data_1m.dados_1m(:,3)); 
RSSI_2m = mean(data_2m.dados_2m(:,3)); 
RSSI_3m = mean(data_3m.dados_3m(:,3)); 
RSSI_4m = mean(data_4m.dados_4m(:,3)); 
RSSI_5m = mean(data_5m.dados_5m(:,3));  



% Distância de referência -----------------------------------------

d0 = 0.5; 



% Vetor de distâncias e sinal- ------------------------------------

RSSI = [ RSSI_1m, RSSI_2m, RSSI_3m, RSSI_4m, RSSI_5m ]; 
d = [1.0, 2.0, 3.0, 4.0, 5.0]; 



% Tamanho do vetor ------------------------------------------------

k = length(RSSI); 



% Criação da variável símbolica N ---------------------------------

syms n; 



% Inicialização do erro quadrático (J) ----------------------------

J = 0; 



% Soma do erro quadrático entre as medidas e as estimativas ------

for i = 1:k

    P = Pr_d0 - 10*n*log10(d(i)/d0) ;   % Potência média recebida em determinada distância D
    J = J + (RSSI(i) - P)^2 ;

end


% Derivada de J em relação a n ------------------------------------

dJ_dn = diff(J, n);



% Resolução do valor de n -----------------------------------------

n_meio = double(solve(dJ_dn == 0, n));
disp('O valor de n para o meio medido é: ')
disp(n_meio)

% Potência média recebida de acordo com o modelo ------------------
P_modelo = double(Pr_d0 - 10 * n_meio * log10(d / d0)); 



% Plotagem do Gráfico ---------------------------------------------

figure;
plot(d, RSSI, 'ko', 'MarkerFaceColor', 'm', 'MarkerSize', 10); % Dados medidos
hold on;
plot(d, P_modelo, 'b-', 'LineWidth', 3); % Modelo ajustado


% Configurações do gráfico
grid on;
xlabel('Distância (d) [m]');
ylabel('RSSI [dBm]');
title('RSSI versus Distância considerando as medidas de campo e o modelo log-distância.');
legend('Medido', 'Modelo', 'Location', 'SouthWest');