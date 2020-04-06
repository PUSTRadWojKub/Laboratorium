%Wyznaczamy symulacyjnie odpowiedzi skokowe dla procesu, dla kilku zmian
%sygnalu sterowania i sygnalu zaklocenia

clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
n = T/Tp; %liczba probek
opoznienie = 6;

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;

%Wartosci skokow sygnalu sterowania ze stanu ustalonego
U1 = -0.5;
U2 = -1.0;
U3 = -1.5;
U4 = -2.0;
U5 = 0.5;
U6 = 1.0;
U7 = 1.5;
U8 = 2.0;

%Wartosci skokow sygnalu zaklocenia ze stanu ustalonego
Z1 = -0.5;
Z2 = -1.0;
Z3 = -1.5;
Z4 = -2.0;
Z5 = 0.5;
Z6 = 1.0;
Z7 = 1.5;
Z8 = 2.0;

figure;
%Odpowiedzi skokowe dla torów sterowanie - wyjœcie
for i=1:8
for k = opoznienie+1:(T/Tp)
    switch i
        case 1
            U(50:n) = U1;
        case 2
            U(50:n) = U2;
        case 3
            U(50:n) = U3;
        case 4
            U(50:n) = U4;
        case 5
            U(50:n) = U5;
        case 6
            U(50:n) = U6;
        case 7
            U(50:n) = U7;
        case 8
            U(50:n) = U8;
    end
    Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
end
subplot(2,1,1);
plot(1:T/Tp, Y);
grid on;
title("Sygnal wyjœciowy");
xlabel('k');
ylabel('y(k)');
% axis([0 400 -5 7]);
if i==8
    legend('y1(k)','y2(k)','y3(k)','y4(k)','y5(k)','y6(k)','y7(k)','y8(k)');
end
hold on;
subplot(2,1,2);
stairs(1:T/Tp, U)
grid on;
title("Sygna³ steruj¹cy");
xlabel('k');
ylabel('u(k)');
axis([0 400 -3 3]);
hold on;
i=i+1;
end
dU1=sprintf('u1(k) dla dU=%.1f',U1);
dU2=sprintf('u2(k) dla dU=%.1f',U2);
dU3=sprintf('u3(k) dla dU=%.1f',U3);
dU4=sprintf('u4(k) dla dU=%.1f',U4);
dU5=sprintf('u5(k) dla dU=%.1f',U5);
dU6=sprintf('u6(k) dla dU=%.1f',U6);
dU7=sprintf('u7(k) dla dU=%.1f',U7);
dU8=sprintf('u8(k) dla dU=%.1f',U8);
legend(dU1,dU2,dU3,dU4,dU5,dU6,dU7,dU8);
hold off;
matlab2tikz ('zad2_tor_u_y.tex','showInfo', false );


figure;
%Odpowiedzi skokowe dla torów zak³ócenia - wyjœcie
for i=1:8
for k = opoznienie+1:(T/Tp)
    switch i
        case 1
            Z(50:n) = Z1;
        case 2
            Z(50:n) = Z2;
        case 3
            Z(50:n) = Z3;
        case 4
            Z(50:n) = Z4;
        case 5
            Z(50:n) = Z5;
        case 6
            Z(50:n) = Z6;
        case 7
            Z(50:n) = Z7;
        case 8
            Z(50:n) = Z8;
    end
    Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
end
subplot(2,1,1);
plot(1:T/Tp, Y);
grid on;
title("Sygnal wyjœciowy");
xlabel('k');
ylabel('y(k)');
% axis([0 400 -5 7]);
if i==8
    legend('y1(k)','y2(k)','y3(k)','y4(k)','y5(k)','y6(k)','y7(k)','y8(k)');
end
hold on;
subplot(2,1,2);
stairs(1:T/Tp, Z)
grid on;
title("Zak³ócenie");
xlabel('k');
ylabel('z(k)');
axis([0 400 -3 3]);
hold on;
i=i+1;
end
dZ1=sprintf('z1(k) dla dZ=%.1f',Z1);
dZ2=sprintf('z2(k) dla dZ=%.1f',Z2);
dZ3=sprintf('z3(k) dla dZ=%.1f',Z3);
dZ4=sprintf('z4(k) dla dZ=%.1f',Z4);
dZ5=sprintf('z5(k) dla dZ=%.1f',Z5);
dZ6=sprintf('z6(k) dla dZ=%.1f',Z6);
dZ7=sprintf('z7(k) dla dZ=%.1f',Z7);
dZ8=sprintf('z8(k) dla dZ=%.1f',Z8);
legend(dZ1,dZ2,dZ3,dZ4,dZ5,dZ6,dZ7,dZ8);
hold off;
matlab2tikz ('zad2_tor_z_y.tex','showInfo', false );
