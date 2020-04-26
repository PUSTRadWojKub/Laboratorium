% Function that returns weights for every local regulator
function w = fuzzy_weights(u_min, u_max, u, nr, mf)
    % Parameters:
    %u_min, u_max - minimum and maximum values of control signal
    %u - u(k-1) control signal
    %nr - number of regulators
    %mf - type of membership function (trimf, trapmf, gaussmf)
    
    %Struktura z funkcjami przynale¿noœci
    mfs = fuzzy_membership_functions(u_min, u_max, nr, mf);

    %Wyliczenie wag dla poszczególnych regulatorów dla sygna³u u(k-1)
    weights = zeros(1, nr);
    for k = 1:nr
            weights(k) = evalmf(mfs{k}, u);
    end
    
    w = weights;
end