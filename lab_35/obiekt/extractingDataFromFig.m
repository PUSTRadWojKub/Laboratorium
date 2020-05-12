clear;
fig = openfig('char_stat_t1.fig');
h = gcf; %current figure handle
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
%%get data 
data = dataObjs{2};
G1T1 = data.XData ;
G2T1 = data.YData ;
T1stat = data.ZData' ;

fig = openfig('char_stat_t3.fig');
h = gcf; %current figure handle
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
%%get data 
data = dataObjs{2};
G1T3 = data.XData ;
G2T3 = data.YData ;
T3stat = data.ZData ;

vars = {'axesObjs', 'dataObjs', 'h', 'fig', 'vars'};
clear (vars{:});

figure;
mesh(G1T1(1:8),G2T1(1:11),T1stat(1:11,1:8));
xlabel('$G1$', 'interpreter', 'latex');
ylabel('$G2$', 'interpreter', 'latex');
zlabel('$T1(G1,G2)$', 'interpreter', 'latex');
grid on;
title('Charakterystyka statyczna $T1(G1,G2)$', 'interpreter', 'latex');
legend('$T1(G1,G2)$', 'interpreter', 'latex');
print("char_stat_t1.pdf",'-dpdf');

figure;
mesh(G1T3(1:8),G2T3(1:11),T3stat(1:11,1:8));
xlabel('$G1$', 'interpreter', 'latex');
ylabel('$G2$', 'interpreter', 'latex');
zlabel('$T3(G1,G2)$', 'interpreter', 'latex');
grid on;
title('Charakterystyka statyczna $T3(G1,G2)$', 'interpreter', 'latex');
legend('$T3(G1,G2)$', 'interpreter', 'latex');
print("char_stat_t3.pdf",'-dpdf');

% KT1G1 = (T1stat(1,8) - T1stat(1,1)) / (G1T1(8) - G1T1(1))
% KT1G2 = (T1stat(11,1) - T1stat(1,1)) / (G2T1(11) - G2T1(1))
% KT3G1 = (T3stat(1,11) - T3stat(1,1)) / (G1T3(11) - G1T3(1))
% KT3G2 = (T3stat(8,1) - T3stat(1,1)) / (G2T3(8) - G2T3(1))