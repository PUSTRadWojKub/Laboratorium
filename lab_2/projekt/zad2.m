%Wyznaczamy symulacyjnie odpowiedzi skokowe dla procesu, dla kilku zmian
%sygnalu sterowania z uwzglednieniem ograniczen

clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym
Zpp = 0;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
n = T/Tp;
opoznienie = 6;

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;

U1 = -0.5;
U2 = -1.0;
U3 = -1.5;
U4 = -2.0;
U5 = 0.5;
U6 = 1.0;
U7 = 1.5;
U8 = 2.0;

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
title("Sygnal wyjsciowy");
hold on;
subplot(2,1,2);
stairs(1:T/Tp, U)
grid on;
title("Zaklocenia");
hold on;
i=i+1;
end
hold off;


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
title("Sygnal wyjsciowy");
hold on;
subplot(2,1,2);
stairs(1:T/Tp, Z)
grid on;
title("Sygnal wejsciowy");
hold on;
i=i+1;
end
hold off;

