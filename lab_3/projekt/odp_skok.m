function [odp_skok] = odp_skok(Upocz, Uskok)
    %Stan ustalony
    Upp = 0; %sygnal wejsciowy w stanie ustalonym
    Ypp = 0; %sygnal wyjsciowy w stanie ustalonym

    Tp = 0.5; %okres probkowania
    T = 400; %czas symulacji
    opoznienie = 6;
    
    %Opoznienie
    U(1:opoznienie) = Upp;
    Y(1:opoznienie) = Ypp;
    
    U(opoznienie+1:T/Tp)= Upocz;
    for k=opoznienie+1:T/Tp
        Y(k)=symulacja_obiektu3y(U(k-5),U(k-6),Y(k-1),Y(k-2));
    end
    Ustat = U(end);
    Ystat = Y(end);
    
    clear U;
    clear Y;
    
    %Opoznienie
    U(1:opoznienie) = Ustat;
    Y(1:opoznienie) = Ystat;
    
    U(opoznienie+1:T/Tp) = Uskok;

    %Przebieg
    for k = opoznienie+1:(T/Tp)
        Y = [Y, symulacja_obiektu3y(U(k-5), U(k-6), Y(k-1), Y(k-2))];
    end

    figure;
    plot(1:T/Tp, Y)
    grid on;
    title("Sygnal wyjsciowy");

    figure;
    stairs(1:T/Tp, U)
    grid on;
    title("Sygnal wejsciowy");

    odp_skok = (Y((opoznienie+2):60)-Ystat)/(Uskok-Ustat);

    figure;
    plot(1:size(odp_skok, 2), odp_skok)
    grid on;
    title("Odpowiedz skokowa");
    
    filename = strcat('odp_skok_', string(Upocz), '_', string(Uskok), '.mat');
    save(filename, 'odp_skok');
end

