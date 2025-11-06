% --- function making drawing multiple Nyquist plots easier ---
function [] =NyqPlot(x)
    figure('Name',inputname(1),'NumberTitle','off');
    nyquistplot(x)
    title(inputname(1))
    grid on
end