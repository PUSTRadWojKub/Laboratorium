% Function that creates and returns symetric fuzzy membership functions
function [wy] = fuzzy_membership_functions(u_min, u_max, nr, mf)
    % Parameters:
    %u_min, u_max - minimum and maximum values of control signal
    %nr - number of regulators
    %mf - type of membership function (trimf, trapmf, gaussmf)
    
    % Symetryczny podzia³
    centers_spacing = (u_max-u_min)/(nr-1);
    
    % Struktura z funkcjami przynale¿noœci
    mfs = cell(1, nr);
    
    % Dla funkcji przynale¿noœci w postaci funkcji Trójk¹tnej
    if(mf == 'trimf')
        % Wyliczenie funkcji przynale¿noœci dla regulatorów
        for k = 1:nr
            % Obliczenie parametrów funkcji Trójk¹tnej
            xc = centers_spacing*(k-1)+u_min;
            xcr = xc + centers_spacing;
            xcl = xc - centers_spacing;
            % Utworzenie funkcji przynale¿ci
            MFName = strcat('u_', string(k), '_mf');
            mfs{k} = fismf("trimf", [xcl, xc, xcr], 'Name', MFName);
%             plot(u_min:0.01:u_max, evalmf(mfs{k}, u_min:0.01:u_max)); 
%             hold on
        end
    end
    
    % Dla funkcji przynale¿noœci w postaci funkcji Trapezoidalnej
    if(mf == 'trapmf')
        trap_coeff_1 = 0.8/nr; %0.8 dobrane eksperymentalnie
        trap_coeff_2 = ((u_max-u_min)-(nr-1)*2*trap_coeff_1)/(nr-1);
        % Wyliczenie funkcji przynale¿noœci dla regulatorów
        for k = 1:nr
            % Obliczenie parametrów funkcji Trapezoidalnej
            xc = centers_spacing*(k-1)+u_min;
            xcr = xc + trap_coeff_1;
            xcl = xc - trap_coeff_1;
            xcrr = xcr + trap_coeff_2;
            xcll = xcl - trap_coeff_2;
            % Utworzenie funkcji przynale¿ci
            MFName = strcat('u_', string(k), '_mf');
            mfs{k} = fismf("trapmf", [xcll, xcl, xcr, xcrr], 'Name', MFName);
%             plot(u_min:0.01:u_max, evalmf(mfs{k}, u_min:0.01:u_max)); 
%             hold on
        end
    end
    
    % Dla funkcji przynale¿noœci w postaci funkcji Gaussa
    if(mf == 'gaussmf')
        gauss_coeff = 0.4/nr; %0.4 dobrane eksperymentalnie
        % Wyliczenie funkcji przynale¿noœci dla regulatorów
        for k = 1:nr
            % Obliczenie parametrów funkcji Gaussowskiej
            xc = centers_spacing*(k-1)+u_min;
            xcr = xc + gauss_coeff;
            xcl = xc - gauss_coeff;
            xccr = xc + centers_spacing/2.3 - xcr; %2.3 dobrane eksperymentalnie
            % Utworzenie funkcji przynale¿ci
            MFName = strcat('u_', string(k), '_mf');
            mfs{k} = fismf("gauss2mf", [xccr, xcl, xccr, xcr], 'Name', MFName);
%             plot(u_min:0.01:u_max, evalmf(mfs{k}, u_min:0.01:u_max)); 
%             hold on
        end
    end
    
    wy = mfs;
end