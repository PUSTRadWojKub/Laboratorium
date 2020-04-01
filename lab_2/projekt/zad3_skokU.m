clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym
Zpp = 0;

Us = 1.0;

Tp = 0.5; %okres probkowania
Ts = 25;
T = 200; %czas symulacji
n = T/Tp;
nskok = Ts/Tp;
opoznienie = 6;

%Opoznienie
U(1:n) = Upp;
U(nskok:n) = Us;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;

%Przebieg
for k = opoznienie+1:n
    Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
end

figure;
plot(1:T/Tp, Y)
grid on;
title("Sygnal wyjsciowy");

figure;
stairs(1:T/Tp, U/(Us-Upp)-Upp)
grid on;
title("Sygnal wejsciowy");

%Zakladam ze odpowiedz skokowa ustabilizowala sie przy 190 probce (wartosc po
%ustabilizowaniu 23.18)

odp_skok = (Y(nskok+1:225)-Ypp)/(Us-Upp);


figure;
plot(nskok+1:225, odp_skok)
grid on;
title("Odpowiedz skokowa");