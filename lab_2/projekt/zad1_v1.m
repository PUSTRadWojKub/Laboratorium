%Sprawdzamy popprawnosc punktu pracy wyliczajac np. 400 kolejnych wartosci
%wyjscia obiektu (powinny byc takie same - ustalone)

clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym
Zpp = 0;

%Ograniczenia wartosci sygnalu sterowania
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
n = T/Tp;
opoznienie = 6;

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
xlabel('k');
ylabel('u(k)');
legend('Sterowanie');
% title('Sterowanie');
subplot(3,1,2);
plot(1:n, Z);
xlabel('k');
ylabel('z(k)');
legend('Zak³ócenie');
% title('Zak³ócenie');
subplot(3,1,3);
plot(1:n, Y);
xlabel('k');
ylabel('y(k)');
legend('Wyjœcie');
% title('Wyjœcie');
matlab2tikz ('zad1_punkt_pracy.tex','showInfo', false );


%Mozemy zauwazyc stan ustalony (wartosc wyjscia nie zmienia sie na calym
%przebiegu