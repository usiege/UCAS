% % % % % % % % % % % % % % % % % % % % % % 
% Line fitting test script
% % % % % % % % % % % % % % % % % % % % % % 

startup;
close all;
clear all;

runAndCheckFitLine(1, [ 1, 0; 0, 1 ]', [pi / 4; sqrt(0.5)]);

runAndCheckFitLine(2, [ -1, 0; 0, 1 ]', [3 * pi / 4; sqrt(0.5)]);

runAndCheckFitLine(3, [ -1, 1; 1, 1 ]', [ pi/ 2; 1]);

runAndCheckFitLine(4, [ 1, 1; 1, -1 ]', [ 0; 1]);

maxManualIndex = 4;


for i = 1 : 30
    alpha = unifrnd(-pi, pi);
    r = randn(1, 1);
    r = r * r + 1;
    
    p = [ r * cos(alpha); r * sin(alpha); ];
    v = [ -sin(alpha); cos(alpha) ];
    n = 10;
    ts = linspace(-1, 1, n);
    XY = p * ones(1, n)  + v * ts;
    runAndCheckFitLine(maxManualIndex + 2 * i - 1, XY, [alpha; r]); 
    runAndCheckFitLine(maxManualIndex + 2 * i, XY + unifrnd( -0.01, 0.01, size(XY)), [alpha; r], 0.01); 
end
