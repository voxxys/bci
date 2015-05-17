close all;
clear all;
cd E:\LocalData\ShishkinBCI
load s504_TnT_samples1;
% settings
Params0.channels = [2 8 13 14 15 16 17 18 19 20 24 25 44 45 46 47 48 49 50];
Params0.ranges_use{1} = [75:10:95,130:10:150,185:10:200, 215:10:240];
Params0.range_use = Params0.ranges_use{1};
Params0.W = [];

bFlipTrTst = false;
if(bFlipTrTst)
    samples2 = samples;
    classes2 = classes;
    samples.tst = samples2.tr;
    samples.tr = samples2.tst;
    classes.tst = classes2.tr;
    classes.tr = classes2.tst;
end;

ParamsS = Params0;
ResultsStr = ClassifyTestShrinkage(samples.tr,classes.tr,ParamsS);
% use calculated weights and test on the independent sample
ParamsS.W = ResultsStr.W;
ResultsStst = ClassifyTestShrinkage(samples.tst,classes.tst,ParamsS);

ParamsF = Params0;
ResultsFtr = ClassifyTestFisher(samples.tr,classes.tr,ParamsF);
% use calculated weights and test on the independent sample
ParamsF.W = ResultsFtr.W;
ResultsFtst = ClassifyTestFisher(samples.tst,classes.tst,ParamsF);

ParamsRFn = Params0;
ParamsRFn.ranges_use{1} = [75:95,130:150,185:200, 215:240];
%reset specific
ParamsRFn.CM0 = [];
ParamsRFn.CM1 = [];
ParamsRFn.W   = [];
%set specific
ResultsRFntr = ClassifyTestRiemanFisherN(samples.tr,classes.tr,ParamsRFn);
ParamsRFn.W = ResultsRFntr.W;
ParamsRFn.CM0 = ResultsRFntr.CM0;
ParamsRFn.CM1 = ResultsRFntr.CM1;
ResultsRFntst = ClassifyTestRiemanFisherN(samples.tst,classes.tst,ParamsRFn)

figure,
plot(1-ResultsStst.spec,ResultsStst.sens,'ro-');
hold on;
plot(1-ResultsRFntst.spec,ResultsRFntst.sens,'b>-');
plot(1-ResultsFtst.spec,ResultsFtst.sens,'kp-');
axis([0,1,0,1.1])
legend('Shrinkage','Rieman-Fisher1', 'Plain Fisher LDA');
title('Single trial performance comparison')
xlabel('FA probability');
ylabel('Sensitivity');
grid
