clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

Us = 1.0; %wartosc skoku sygnalu sterowania ze stanu ustalonego

Tp = 0.5; %okres probkowania
Ts = 25; %czas w ktorym nastepuje skok
T = 200; %czas symulacji
n = T/Tp; %liczba probek symulacji
nskok = Ts/Tp; %probka w ktorej nastepuje skok
opoznienie = 6; %opoznienie obiektu

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

% Wyciecie odpowiedzi skokowej
odp_skok = (Y(nskok+1:225)-Ypp)/(Us-Upp);

figure;
plot(odp_skok);
grid on;
title("Odpowiedz skokowa toru wej�cie-wyj�cie procesu");
xlabel('k');
ylabel('y(k)');
legend('y(k)','Location','southeast');
matlab2tikz ('zad3_odp_uy.tex','showInfo', false );

save('odp_skokU.mat', 'odp_skok');
