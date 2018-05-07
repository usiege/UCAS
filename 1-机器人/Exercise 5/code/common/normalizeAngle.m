function [angle1] = normalizeAngle(angle)
    %normalizeAngle   set angle to the range [-pi,pi)

    angle1 = mod( angle+pi, 2*pi) - pi;
