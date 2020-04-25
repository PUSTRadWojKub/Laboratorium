%Sprawdzamy popprawnosc punktu pracy wyliczajac np. 400 kolejnych wartosci
%wyjscia obiektu (powinny byc takie same - ustalone)

clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = -1;
Umax = 1;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
opoznienie = 6;

%Opoznienie
U_cale(1:opoznienie) = Upp;
Y(1:opoznienie) = Ypp;

U = U_cale(end);

%Przebieg
for k = opoznienie+1:(T/Tp)
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    U_cale = [U_cale, U];
    Y = [Y, symulacja_obiektu3y(U_cale(k-5), U_cale(k-6), Y(k-1), Y(k-2))];
end

subplot(2,1,1);
plot(1:T/Tp, U_cale);
title('U')
subplot(2,1,2);
plot(1:T/Tp, Y);
title('Y')
matlab2tikz('../sprawozdanie/rysunki/zad1_punkt_pracy.tex', 'showInfo', false)

%Mozemy zauwazyc stan ustalony (wartosc wyjscia nie zmienia sie na calym przebiegu)