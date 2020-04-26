% Function that returns weights for every local regulator
function w = fuzzy_weights(u, mfs)
    % Parameters:
    %u - u(k-1) control signal
    %mfs - structure with membership functions
    
    % Liczba regulator�w/funkcji przynale�no�ci
    nr = size(mfs, 2);

    % Wyliczenie wag dla poszczeg�lnych regulator�w dla sygna�u u(k-1)
    weights = zeros(1, nr);
    for k = 1:nr
            weights(k) = evalmf(mfs{k}, u);
    end
    
    w = weights;
end