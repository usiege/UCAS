function validateFilter()

if ~validateTransitionFunction() || ~validateAssociations()
   fprintf('Execution halted. Test of individual building blocks was unsuccessful. Please test them individually and re-run this script.\n');
   close all;
   return;
end
close all

load data/validationData.mat

x(:,1) = filterData(1).x_posteriori;
P(:,:,1) = filterData(1).P_posteriori;
for i = 2:length(filterData)
    [x(:,i), P(:,:,i)] = filterStep(x(:,i-1), P(:,:,i-1), filterData(i).u, filterData(i).h, filterParams.R, filterParams.M, filterParams.k, filterParams.g, filterParams.b);
end

figure(1); cla, hold on, axis equal;
a = [filterData.x_gt];  plot(a(1,:), a(2,:), 'b-'); hold on, axis equal;
b = [filterData.x];  plot(b(1,:), b(2,:), 'g-');
c = [filterData.x_posteriori];  plot(c(1,:), c(2,:), 'k:');
plot(x(1,:), x(2,:), 'r-')
title('robot path');
xlabel('x'), ylabel('y');
legend({'ground truth','forward integration', 'EKF baseline implementation', 'EKF solution'});
