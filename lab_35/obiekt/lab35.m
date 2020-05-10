clear all;
initSerialControl COM3 % initialise com port
Y = [];
U = [];
n = 500;
    
    
for k = 0 : n
    measurements = readMeasurements([1,3]); 
    disp(measurements); 
    if(k <  200)
        controls = [18,   23];
    else
        controls = [18, 43];
    end
    sendControls([5,6], controls);

    Y = [Y; measurements]; subplot(2,1,1); plot(Y);                   drawnow
    U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
    waitForNewIteration(); 
end
s1 = Y;
u1 = U;
    
Y = [];
U = [];
        
for k = 0 : n
    measurements = readMeasurements([1,3]); 
    disp(measurements); 
    if(k <  200)
        controls = [18,   23];
    else
        controls = [18, 43];
    end
    sendControls([5,6], controls);

    Y = [Y; measurements]; subplot(2,1,1); plot(Y);                   drawnow
    U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
    waitForNewIteration(); 
end

s2 = Y;
u2 = U;

