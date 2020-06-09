clear;
close all

T = 500;
Tp = 0.5;
opoznienie = 4;

y1(1:opoznienie) = 0;
y2(1:opoznienie) = 0;
y3(1:opoznienie) = 0;


% Wybór sygna³ów wejœciowych
% 1 - y1 - U2
%     y2 - U1
%     y3 - U3
%
% 2 - y1 - U2
%     y2 - U1
%     y3 - U4
%
% 3 - y1 - U4
%     y2 - U2
%     y3 - U1
regulator = 2;

% x = [K1, Ti1, Td1, K2, Ti2, Td2, K3, Ti3, Td3]

switch regulator
    case 1
%         x = [7.278652197505372,9.682504943608706,0.028805729080709,2.348042537703474,0.419147202061216,0.027493772598440,1.250000000000000,6.237554608944860,1.263322612764187];
%         x = [1, 1000, 0.001, 1, 1000, 0.001, 1, 1000, 0.001];  % 1 krok - inicjalizacja
%         x = [6, 10, 0.01, 1, 1000, 0.001, 1, 1000, 0.001];     % 2 krok - dobieranie wspó³czynników dla 1 regulatora
%         x = [6, 10, 0.01, 3, 1, 0.01, 1, 1000, 0.001];         % 3 krok - dobieranie wspó³czynników dla 2 regulatora
%         x = [6, 10, 0.01, 3, 1, 0.01, 1, 10, 0.01];            % 2 krok - dobieranie wspó³czynników dla 3 regulatora
        x = [6, 5, 0.01, 3, 1, 0.01, 1, 8, 1];   %najlepsze rêczne
    case 2
%         x = [4.322822413135649,13.963120973863298,0.010074920585211,2.777905755042830,20.973596348557400,0,0.790546695184308,4.061007884579925,0.514548021669644];
%         x = [1, 1000, 0.001, 1, 1000, 0.001, 1, 1000, 0.001];  % 1 krok - inicjalizacja
%         x = [5, 10, 0.01, 1, 1000, 0.001, 1, 1000, 0.001];     % 2 krok - dobieranie wspó³czynników dla 1 regulatora
%         x = [5, 10, 0.01, 3, 10, 0.01, 1, 1000, 0.001];         % 3 krok - dobieranie wspó³czynników dla 2 regulatora
%         x = [5, 10, 0.01, 3, 10, 0.01, 1, 5, 0.1];            % 2 krok - dobieranie wspó³czynników dla 3 regulatora
        x = [5, 12, 0.01, 3, 20, 0.01, 0.5, 5, 0.5];   %najlepsze rêczne
    case 3
%         x = [1.321834400767867,0.333803132207827,7.682610724402128e-05,6.820754823225034,13.234375000000000,0.025682335608536,0.812500000000000,12.639480291624530,0.406250000000000];
%         x = [1, 1000, 0.001, 1, 1000, 0.001, 1, 1000, 0.001];  % 1 krok - inicjalizacja
%         x = [1, 1, 0.01, 1, 1000, 0.001, 1, 1000, 0.001];     % 2 krok - dobieranie wspó³czynników dla 1 regulatora
%         x = [1, 1, 0.01, 5, 10, 0.01, 1, 1000, 0.001];         % 3 krok - dobieranie wspó³czynników dla 2 regulatora
%         x = [1, 1, 0.01, 5, 10, 0.01, 1, 10, 0.1];            % 2 krok - dobieranie wspó³czynników dla 3 regulatora
        x = [1, 1, 0.01, 5, 10, 0.01, 0.5, 5, 0.5];   %najlepsze rêczne
end

U = [0 0 0 0;...
    0 0 0 0;...
    0 0 0 0;...
    0 0 0 0];

u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
u4 = U(:,4);

e1 = 0;
e2 = 0;
e3 = 0;

yzad1(1:200) = 0;
yzad2(1:200) = 0;
yzad3(1:200) = 0;
yzad1(201:400) = 3;
yzad2(201:400) = 5;
yzad3(201:400) = 0.5;
yzad1(401:600) = 1;
yzad2(401:600) = 0.5;
yzad3(401:600) = 5;
yzad1(601:900) = 6;
yzad2(601:900) = 2;
yzad3(601:900) = 10;
yzad1(901:T/Tp) = 0.5;
yzad2(901:T/Tp) = 8;
yzad3(901:T/Tp) = 3;

% Regulator 1
K1 = x(1);
Ti1 = x(2);
Td1 = x(3);
r01 = K1*(1 + Tp/(2*Ti1) + Td1/Tp);
r11 = K1*(Tp/(2*Ti1) - (2*Td1)/Tp - 1);
r21 = (K1*Td1)/Tp;


% Regulator 2
K2 = x(4);
Ti2 = x(5);
Td2 = x(6);
r02 = K2*(1 + Tp/(2*Ti2) + Td2/Tp);
r12 = K2*(Tp/(2*Ti2) - (2*Td2)/Tp - 1);
r22 = (K2*Td2)/Tp;


% Regulator 3
K3 = x(7);
Ti3 = x(8);
Td3 = x(9);
r03 = K3*(1 + Tp/(2*Ti3) + Td3/Tp);
r13 = K3*(Tp/(2*Ti3) - (2*Td3)/Tp - 1);
r23 = (K3*Td3)/Tp;

Uplot = [];
Yplot = [];

e = 0;



for k = opoznienie + 1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
    
    e = e + (yzad1(k)-y1(k))^2 + (yzad2(k)-y2(k))^2 + (yzad3(k)-y3(k))^2;
    
    e1(k) = yzad1(k)-y1(k);
    e2(k) = yzad2(k)-y2(k);  
    e3(k) = yzad3(k)-y3(k);  
    
    dU1 = r21*e1(k-2) + r11*e1(k-1) + r01*e1(k);
    dU2 = r22*e2(k-2) + r12*e2(k-1) + r02*e2(k);
    dU3 = r23*e3(k-2) + r13*e3(k-1) + r03*e3(k);
    switch regulator
        case 1
            u1(k) = U(1,1)+dU2;
            u2(k) = U(1,2)+dU1;
            u3(k) = U(1,3)+dU3;
            u4(k) = 0;
        case 2
            u1(k) = U(1,1)+dU2;
            u2(k) = U(1,2)+dU1;
            u3(k) = 0;
            u4(k) = U(1,4)+dU3;
        case 3
            u1(k) = U(1,1)+dU3;
            u2(k) = U(1,2)+dU2;
            u3(k) = 0;
            u4(k) = U(1,4)+dU1;
    end
    
    U = [[u1(k), u2(k), u3(k), u4(k)]; U];
    
    Yplot = [Yplot; [y1(k),y2(k),y3(k)]];
    Uplot = [Uplot; [u1(k), u2(k), u3(k), u4(k)]];
end
e

figure;
subplot(4,2,1);
stairs(Uplot(:,1));
ylabel('$u_\mathrm{1}(k)$','interpreter','latex');
% xlabel('$k$','interpreter','latex');
grid on;
subplot(4,2,2);
plot(yzad1);
hold on;
plot(Yplot(:,1));
% xlabel('$k$','interpreter','latex');
ylabel('$y_\mathrm{1}(k)$, $y_\mathrm{1}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,3);
stairs(Uplot(:,2));
% xlabel('$k$','interpreter','latex');
ylabel('$u_\mathrm{2}(k)$','interpreter','latex');
grid on;
subplot(4,2,4);
plot(yzad2);
hold on;
plot(Yplot(:,2));
% xlabel('$k$','interpreter','latex');
ylabel('$y_\mathrm{2}(k)$, $y_\mathrm{2}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,5);
stairs(Uplot(:,3));
% xlabel('$k$','interpreter','latex');
ylabel('$u_\mathrm{3}(k)$','interpreter','latex');
grid on;
subplot(4,2,6);
plot(yzad3);
hold on;
plot(Yplot(:,3));
xlabel('$k$','interpreter','latex');
ylabel('$y_\mathrm{3}(k)$, $y_\mathrm{3}^\mathrm{zad}(k)$','interpreter','latex');
grid on;

subplot(4,2,7);
stairs(Uplot(:,4));
xlabel('$k$','interpreter','latex');
ylabel('$u_\mathrm{4}(k)$','interpreter','latex');
grid on;

% matlab2tikz('..\proj_sprawozdanie\rysunki\zad4_PID_v3_ga.tex', 'showInfo', false)


% print('..\proj_sprawozdanie\rysunki\zad4_PID_v2_recznie5','-dpdf');

