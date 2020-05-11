function zad1_2()
    %addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    k = 0;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements([1,3]); % read measurements 1 and 3
        
%         %% processing of the measurements and new control values calculation
        disp(measurements); % process measurements
%         
%         %% sending new values of control signals
        controls = [18,   23];
        
        sendControls([5,6]    ,... send for these elements
                     controls);  % new corresponding control values
        k = k+1;
        
        %legends ...
        
        Y = [Y; measurements]; subplot(2,1,1); plot(Y);
        title("Wyjścia obiektu (czujniki temperatury)"); legend("$T1$", "$T3$", "interpreter", "latex");
        xlabel("$k$", "interpreter", "latex"); ylabel("$^{\circ}C$", "interpreter", "latex");
        drawnow
        U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]);
        title("Wejścia obiektu - sterowanie (grzałki)"); legend("$G1$", "$G2$", "interpreter", "latex");
        xlabel("$k$", "interpreter", "latex"); ylabel("$\%$", "interpreter", "latex");
        drawnow
        
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end
