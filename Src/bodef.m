% --- function making bode plot with Hz frequency axis ---
function [] = bodef(x,drawMargin)
    figure('Name',inputname(1),'NumberTitle','off');
    plotOption = bodeoptions;
    plotOption.FreqUnits = 'Hz';
    bodeplot(x,plotOption)
    if drawMargin
        margin(x)
    end
    title(inputname(1))
    grid on
end