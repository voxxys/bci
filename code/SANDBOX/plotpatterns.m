function [] = plotpatterns(Y1,Y2)

    figure;
    hold on;
    plot(Y1(1,:), Y1(end,:), 'b.');
    plot(Y2(1,:), Y2(end,:), 'r.');

end
