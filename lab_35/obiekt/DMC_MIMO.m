clear;

load('odpSkokNowe.mat');

S = [];

s_1 = s1(201:300,:);
s_2 = s2(201:300,:);

s_1(:,1) = (s_1(:,1) - s_1(1,1))/20;
s_1(:,2) = (s_1(:,2) - s_1(1,2))/20;


s_2(:,1) = (s_2(:,1) - s_2(1,1))/20;
s_2(:,2) = (s_2(:,2) - s_2(1,2))/20;


D = length(s_1);
N = 20;
Nu = 3;

% S = cell(2,2);
% 
% S{1,1} = s_1(:,1);
% S{1,2} = s_1(:,2);
% S{2,1} = s_2(:,1);
% S{2,2} = s_2(:,2);

for i = 1 : D
    S(1,1,i) = s_1(i,1);
    S(1,2,i) = s_1(i,2);
    S(2,1,i) = s_2(i,1);
    S(2,2,i) = s_2(i,2);
end



M = cell(2*N,2*Nu);
for i=1:N*2
    for j=1:Nu*2
        if (i>=j)
            M{i,j}=S(:,:,i-j+1);
        else
            M{i,j} = [0 0;0 0];
        end
    end
end

MP = cell(N*2,(D-1)*2);
for i=1:N*2
    for j=1:(D-1)*2
        if i+j<=D
            MP{i,j}=S(:,:,i+j)-S(:,:,j);
        else
            if j <= D
                MP{i,j}=S(:,:,D)-S(:,:,j);
            else
                MP{i,j}=S(:,:,D)-S(:,:,D-1);
            end
        end
    end
end

lambda = eye(Nu*2*2)*1;
psi = eye(N*2*2)*1;
% 
Mt = M';

M = cell2mat(M);
MP = cell2mat(MP);
K = (M'*psi*M+lambda)^(-1)*M'*psi;
K1 = K(1:2,:);

Yplot = [];
Uplot = [];

U = zeros(N*2*2,1);

duk = 0;
dUp = zeros((D-1)*2*2,1);
Yk = [];

yzad = [40 50];
Yzad = [];
for i = 1 : N*2
    Yzad = [Yzad; yzad'];
end

Yplot = [];
Uplot = [];

figure;
for k = 0 : n
    measurements = readMeasurements([1,3]); 
    disp(measurements); 
    Yk = [];
    for i = 1 : N*2
        Yk = [Yk; measurements'];
    end
    
    duk = K1*(Yzad - Yk - MP*dUp);
    
    controls = [U(1)+duk(1), U(2)+duk(2)];
    
    if controls(1) < 0
        controls(1) = 0;
    elseif controls(1) > 100
        controls(1) = 100;
    end
    if controls(2) < 0
        controls(2) = 0;
    elseif controls(2) > 100
        controls(2) = 100;
    end
    
    U = [controls'; U];
    U = U(1 : 2*2*N);
    
    dUp = [duk; dUp];
    dUp = dUp(1 : 2*2*(D-1));
   
    sendControls([5,6], controls);

    Yplot = [Yplot; measurements]; subplot(2,1,1); plot(Yplot);                   drawnow
    Uplot = [Uplot; controls];     subplot(2,1,2); stairs(Uplot); ylim([-5,105]); drawnow
        
    waitForNewIteration(); 
end