clear;

%Stan ustalony
Upp = 0; %sygnal wejsciowy sterowania w stanie ustalonym
Zpp = 0; %sygnal wejsciowy zaklocenia w stanie ustalonym
Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

Zs = 1.0; %wartosci skoku sygnalu zaklocenia ze stanu ustalonego

Tp = 0.5; %okres probkowania
Ts = 25; %czas w ktorym nastepuje skok
T = 200; %czas symulacji
n = T/Tp; %liczba probek symulacji
nskok = Ts/Tp; %probka w ktorej nastepuje skok
opoznienie = 6; %opoznienie obiektu

%Opoznienie
U(1:n) = Upp;
Z(1:n) = Zpp;
Z(nskok:n) = Zs;
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
stairs(1:T/Tp, Z/(Zs-Zpp)-Zpp)
grid on;
title("Sygnal wejsciowy");

% Wyciecie odpowiedzi skokowej
odp_skok = (Y(nskok+1:100)-Ypp)/(Zs-Zpp);

figure;
plot(odp_skok)
grid on;
title("Odpowiedz skokowa toru zak³ócenie-wyjœcie procesu");
xlabel('k');
ylabel('y(k)');
legend('y(k)','Location','southeast');
matlab2tikz ('zad3_odp_zy.tex','showInfo', false );

save('odp_skokZ.mat', 'odp_skok');