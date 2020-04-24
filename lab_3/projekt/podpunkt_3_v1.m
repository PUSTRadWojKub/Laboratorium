%Wyznaczamy symulacyjnie odpowiedz skokowa dla procesu

clear all;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = -1;
Umax = 1;

Tp = 0.5; %okres probkowania
T = 100; %czas symulacji
opoznienie = 6;

Ts = 10; %czas skoku wartosci sygnalu sterujacego
Us = 1;

U_cale = Upp;
Y = Ypp;

%Opoznienie
for k = 2:opoznienie
    U_cale = [U_cale, Upp];
    Y = [Y, Ypp];
end

U = U_cale(end);

%Przebieg
for k = opoznienie+1:(T/Tp)
    if k == Ts/Tp
        U = Us;
    end
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    U_cale = [U_cale, U];
    Y = [Y, symulacja_obiektu3y(U_cale(k-5), U_cale(k-6), Y(k-1), Y(k-2))];
end

figure;
plot(1:T/Tp, Y*10)
grid on;
title("Sygnal wyjsciowy");

figure;
stairs(1:T/Tp, U_cale/(Us-Upp)-Upp*10)
grid on;
title("Sygnal wejsciowy");

%Zakladam ze odpowiedz skokowa ustabilizowala sie przy 190 probce (wartosc po
%ustabilizowaniu 23.18)

odp_skok = (Y(Ts/Tp+1:60)-Ypp)/(Us-Upp);


figure;
plot(Ts/Tp+1:60, odp_skok)
grid on;
title("Odpowiedz skokowa");
