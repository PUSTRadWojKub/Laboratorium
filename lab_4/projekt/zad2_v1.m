clear;

U1pp = 0;
U2pp = 0;
U3pp = 0;
U4pp = 0;

Y1pp = 0;
Y2pp = 0;
Y3pp = 0;

u_skok = 10; % skok sterowania
Tp = 0.5; %okres probkowania
T = 100; %czas symulacji
opoznienie = 4;

u1(1:u_skok-1) = U1pp;
u1(u_skok:T/Tp) = 1;
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

s11 = y1(u_skok+1:end);
s21 = y2(u_skok+1:end);
s31 = y3(u_skok+1:end);

u1(1:T/Tp) = Y1pp;
u2(1:u_skok-1) = U2pp;
u2(u_skok:T/Tp) = 1;
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

s12 = y1(u_skok+1:end);
s22 = y2(u_skok+1:end);
s32 = y3(u_skok+1:end);

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:u_skok-1) = U3pp;
u3(u_skok:T/Tp) = 1;
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

s13 = y1(u_skok+1:end);
s23 = y2(u_skok+1:end);
s33 = y3(u_skok+1:end);

u1(1:T/Tp) = U1pp;
u2(1:T/Tp) = U2pp;
u3(1:T/Tp) = U3pp;
u4(1:u_skok-1) = U4pp;
u4(u_skok:T/Tp) = 1;

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

s14 = y1(u_skok+1:end);
s24 = y2(u_skok+1:end);
s34 = y3(u_skok+1:end);


figure;
subplot(3,1,1)
plot( s11);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{11}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{11}(k)$','interpreter','latex');
grid on;
subplot(3,1,2)
plot( s21);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{21}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{21}(k)$','interpreter','latex');
grid on;
subplot(3,1,3)
plot( s31);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{31}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{31}(k)$','interpreter','latex');
grid on;
% matlab2tikz('..\proj_sprawozdanie\rysunki\zad2_skokU1.tex', 'showInfo', false)

figure;
subplot(3,1,1)
plot( s12);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{12}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{12}(k)$','interpreter','latex');
grid on;
subplot(3,1,2)
plot( s22);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{22}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{22}(k)$','interpreter','latex');
grid on;
subplot(3,1,3)
plot( s32);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{32}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{32}(k)$','interpreter','latex');
grid on;
grid on;
% matlab2tikz('..\proj_sprawozdanie\rysunki\zad2_skokU2.tex', 'showInfo', false)

figure;
subplot(3,1,1)
plot( s13);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{13}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{13}(k)$','interpreter','latex');
grid on;
subplot(3,1,2)
plot( s23);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{23}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{23}(k)$','interpreter','latex');
grid on;
subplot(3,1,3)
plot( s33);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{33}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{33}(k)$','interpreter','latex');
grid on;
% matlab2tikz('..\proj_sprawozdanie\rysunki\zad2_skokU3.tex', 'showInfo', false)

figure;
% title('Odpowiedzi skokowe dla skoku $u_\mathrm{4}$','interpreter','latex');
subplot(3,1,1)
plot( s14);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{14}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{14}(k)$','interpreter','latex');
grid on;
subplot(3,1,2)
plot( s24);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{24}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{24}(k)$','interpreter','latex');
grid on;
subplot(3,1,3)
plot( s34);
hold on;
ylim([0 2]);
ylabel('$s^\mathrm{34}$','interpreter','latex');
xlabel('$k$','interpreter','latex');
legend('$s^\mathrm{34}(k)$','interpreter','latex');
grid on;
% matlab2tikz('..\proj_sprawozdanie\rysunki\zad2_skokU4.tex', 'showInfo', false)