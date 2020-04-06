%Sprawdzamy popprawnosc punktu pracy wyliczajac np. 400 kolejnych wartosci
%wyjscia obiektu (powinny byc takie same - ustalone)

clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
n = T/Tp; %liczba probek
opoznienie = 6; %opoznienie obiektu

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Y(1:opoznienie) = Ypp;


%Przebieg
for k = opoznienie+1:n
    Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Z(k-2),Z(k-3),Y(k-1),Y(k-2));
end

subplot(3,1,1);
plot(1:n, U);
title('U')
subplot(3,1,2);
plot(1:n, Z);
title('Z')
subplot(3,1,3);
plot(1:n, Y);
title('Y')

%Mozemy zauwazyc stan ustalony (wartosc wyjscia nie zmienia sie na calym
%przebiegu)