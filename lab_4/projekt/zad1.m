clear;

U1pp = 0;
U2pp = 0;
U3pp = 0;
U4pp = 0;

Y1pp = 0;
Y2pp = 0;
Y3pp = 0;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
opoznienie = 4;

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:T/Tp) = U3pp;
u4(1:T/Tp) = U4pp;

y1(1:T/Tp) = 0;
y2(1:T/Tp) = 0;
y3(1:T/Tp) = 0;

y1(1:opoznienie) = Y1pp;
y2(1:opoznienie) = Y2pp;
y3(1:opoznienie) = Y3pp;

for k = opoznienie+1 : T/Tp
    [y1(k),y2(k),y3(k)]=symulacja_obiektu3(u1(k-1),u1(k-2),u1(k-3),u1(k-4),...
                                        u2(k-1),u2(k-2),u2(k-3),u2(k-4),...
                                        u3(k-1),u3(k-2),u3(k-3),u3(k-4),...
                                        u4(k-1),u4(k-2),u4(k-3),u4(k-4),...
                                        y1(k-1),y1(k-2),y1(k-3),y1(k-4),...
                                        y2(k-1),y2(k-2),y2(k-3),y2(k-4),...
                                        y3(k-1),y3(k-2),y3(k-3),y3(k-4));
                                    
end

figure;
% figure('units','normalized','outerposition',[0 0 1 1])
subplot(4,1,1);
plot(1:T/Tp, u1);
hold on;
ylabel('U1');
xlabel('k');
subplot(4,1,2);
plot(1:T/Tp, u2);
hold on;
ylabel('U2');
xlabel('k');
subplot(4,1,3);
plot(1:T/Tp, u3);
hold on;
ylabel('U3');
xlabel('k');
subplot(4,1,4);
plot(1:T/Tp, u4);
hold on;
ylabel('U4');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad1_punkt_pracyU.tex', 'showInfo', false)

% figure('units','normalized','outerposition',[0 0 1 1])
figure;
subplot(3,1,1);
plot(1:T/Tp, y1);
hold on;
ylabel('Y1');
xlabel('k');
subplot(3,1,2);
plot(1:T/Tp, y2);
hold on;
ylabel('Y2');
xlabel('k');
subplot(3,1,3);
plot(1:T/Tp, y3);
hold on;
ylabel('Y3');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad1_punkt_pracyY.tex', 'showInfo', false)