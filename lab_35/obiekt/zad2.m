clear all;
n = 500;

G = [[28, 23];[38, 23];[18, 33];[18, 43];[8, 23];[18, 13]];

s = cell(1, size(G, 1));
u = cell(1, size(G, 1));
    
for k = 1 : size(G, 1)
    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    G1 = G(k, 1);
    G2 = G(k, 2);
    figure;
        for l = 0 : n
            measurements = readMeasurements([1,3]); 
            disp(measurements); 
            if(l <  200)
                controls = [18,   23];
            else
                controls = [G1, G2];
            end
            sendControls([5,6], controls);

            Y = [Y; measurements]; subplot(2,1,1); plot(Y);
            title("Wyjścia obiektu (czujniki temperatury)"); legend("$T1$", "$T3$", "interpreter", "latex");
            xlabel("$k$", "interpreter", "latex"); ylabel("$^{\circ}C$", "interpreter", "latex");
            drawnow
            U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]);
            title("Wejścia obiektu - sterowanie (grzałki)"); legend("$G1$", "$G2$", "interpreter", "latex");
            xlabel("$k$", "interpreter", "latex"); ylabel("$\%$", "interpreter", "latex");
            drawnow

            waitForNewIteration(); 
        end
    hold off;
    file_name = strcat('skok_g1_', string(G1), '_g2_', string(G2), '.pdf');
    print(file_name,'-dpdf');
    s{k} = Y;
    u{k} = U;
end

for k = 1 : size(G, 1)
    s{k} = s{k}(201:300,:);
    s{k}(:,1) = (s{k}(:,1) - s{k}(1,1))/((G(k,1) - 18) + (G(k,2) - 23));
    s{k}(:,2) = (s{k}(:,2) - s{k}(1,2))/((G(k,1) - 18) + (G(k,2) - 23));
end

% Odpowiedzi skokowe dla wyjscia T1
figure;
Legend = cell(size(G, 1),1);
for k = 1 : size(G, 1)
    subplot(2,1,1);
    plot(s{k}(:,1));
    grid on;
    title("Sygnał wyjściowy T1");
    xlabel("$k$", "interpreter", "latex")
    hold on;
    subplot(2,1,2);
    if abs(G(k,1) - 18) > 0
        stairs(u{k}(201:300,1));
        Legend{k} = '$G1$';
    else
        stairs(u{k}(201:300,2));
        Legend{k} = '$G2$';
    end
    grid on;
    title("Sygnał wejściowy");
    xlabel("$k$", "interpreter", "latex")
    ylabel("$\%$", "interpreter", "latex")
    hold on;
end
legend(Legend, 'interpreter', 'latex');
print("odp_skok_t1.pdf",'-dpdf');

% Odpowiedzi skokowe dla wyjscia T3
figure;
for k = 1 : size(G, 1)
    subplot(2,1,1);
    plot(s{k}(:,2));
    grid on;
    title("Sygnał wyjściowy T3");
    xlabel("$k$", "interpreter", "latex")
    hold on;
    subplot(2,1,2);
    if abs(G(k,1) - 18) > 0
        stairs(u{k}(201:300,1));
        Legend{k} = '$G1$';
    else
        stairs(u{k}(201:300,2));
        Legend{k} = '$G2$';
    end
    grid on;
    title("Sygnał wejściowy");
    xlabel("$k$", "interpreter", "latex")
    ylabel("$\%$", "interpreter", "latex")
    hold on;
end
legend(Legend, 'interpreter', 'latex');
print("odp_skok_t3.pdf",'-dpdf');

Wyznaczanie charakterystki statycznej
Y = [];
U = [];

dG = 0:5:100;
n = 100;

T1stat = zeros(length(dG));
T3stat = zeros(length(dG));

for i = 1:length(dG)
    for j = 1:length(dG)
        for l = 0 : n
            measurements = readMeasurements([1,3]); 
            disp(measurements); 

            controls = [dG(i), dG(j)];

            sendControls([5,6], controls);

            Y = [Y; measurements];
            U = [U; controls];

            waitForNewIteration(); 
        end
        T1stat(i, j) = Y(end, 1);
        T3stat(i, j) = Y(end, 2);
    end
end

figure;
mesh(dG(1:21),dG(1:8),T1stat(1:8,1:21));
xlabel('$G1$', 'interpreter', 'latex');
ylabel('$G2$', 'interpreter', 'latex');
zlabel('$T1(G1,G2)$', 'interpreter', 'latex');
grid on;
title('Charakterystyka statyczna $T1(G1,G2)$', 'interpreter', 'latex');
legend('$T1(G1,G2)$', 'interpreter', 'latex');
print("char_stat_t1.pdf",'-dpdf');

figure;
mesh(dG(1:8),dG(1:21),T3stat(1:8,1:21)');
xlabel('$G1$', 'interpreter', 'latex');
ylabel('$G2$', 'interpreter', 'latex');
zlabel('$T3(G1,G2)$', 'interpreter', 'latex');
grid on;
title('Charakterystyka statyczna $T3(G1,G2)$', 'interpreter', 'latex');
legend('$T3(G1,G2)$', 'interpreter', 'latex');
print("char_stat_t3.pdf",'-dpdf');