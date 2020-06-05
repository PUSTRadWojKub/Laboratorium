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

u1(1:T/Tp) = 1;
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

s11 = y1;
s21 = y2;
s31 = y3;

u1(1:T/Tp) = Y1pp;
u2(1:T/Tp) = 1;
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

s12 = y1;
s22 = y2;
s32 = y3;

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:T/Tp) = 1;
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

s13 = y1;
s23 = y2;
s33 = y3;

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:T/Tp) = U3pp;
u4(1:T/Tp) = 1;

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

s14 = y1;
s24 = y2;
s34 = y3;


figure;
subplot(3,1,1)
plot(1:T/Tp, s11);
hold on;
ylim([0 2]);
ylabel('s11');
subplot(3,1,2)
plot(1:T/Tp, s21);
hold on;
ylim([0 2]);
ylabel('s21');
subplot(3,1,3)
plot(1:T/Tp, s31);
hold on;
ylim([0 2]);
ylabel('s31');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad2_skokU1.tex', 'showInfo', false)

figure;
subplot(3,1,1)
plot(1:T/Tp, s12);
hold on;
ylim([0 2]);
ylabel('s12');
subplot(3,1,2)
plot(1:T/Tp, s22);
hold on;
ylim([0 2]);
ylabel('s22');
subplot(3,1,3)
plot(1:T/Tp, s32);
hold on;
ylim([0 2]);
ylabel('s32');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad2_skokU2.tex', 'showInfo', false)

figure;
subplot(3,1,1)
plot(1:T/Tp, s13);
hold on;
ylim([0 2]);
ylabel('s13');
subplot(3,1,2)
plot(1:T/Tp, s23);
hold on;
ylim([0 2]);
ylabel('s23');
subplot(3,1,3)
plot(1:T/Tp, s33);
hold on;
ylim([0 2]);
ylabel('s33');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad2_skokU3.tex', 'showInfo', false)

figure;
subplot(3,1,1)
plot(1:T/Tp, s14);
hold on;
ylim([0 2]);
ylabel('s14');
subplot(3,1,2)
plot(1:T/Tp, s24);
hold on;
ylim([0 2]);
ylabel('s24');
subplot(3,1,3)
plot(1:T/Tp, s34);
hold on;
ylim([0 2]);
ylabel('s34');
xlabel('k');
% matlab2tikz('..\sprawozdanie\rysunki\zad2_skokU4.tex', 'showInfo', false)