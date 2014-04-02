% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%                Histed & Miller (2006) Double Step Saccade Task               %
%                                                                              %
%   In this task,  participants first direct gaze toward a  central fixation   %
%   cue and then await the presentation of two subsequent cues. When the two   %
%   cues are  presented,  their onsets are separated in time  by an interval   %
%   of  variable duration termed the  stimulus onset asynchrony (SOA).  Both   %
%   cues are extingushed at the same time, at which point there begins a one   %
%   second delay during which the participant must remember the cues and the   %
%   order  in which they were presented.   Following the delay interval, the   %
%   fixation point disappears, signalling that the participant is to saccade   %
%   to the  cued locations  in the  order they were cued.   On some  trials,   %
%   microstimulation is applied for the first 900ms of the delay interval.     %
%                                                                              %
%   Trials proceed according to the following schematic:                       %
%                                                                              %
%   cue1 |----------|##########|----------|----------|----------|----------|   %
%   cue2 |----------|---#######|----------|----------|----------|----------|   %
%    fix |##########|##########|##########|##########|----------|----------|   %
%   stim |----------|----------|/\/\/\/\/\|/\/\/\/\--|----------|----------|   %
%        |          |          |          |          |          |          |   %
%        0ms        500ms      1000ms                2000ms                    %
%                                                                              %
%   Details about this simulation:                                             % 
%                                                                              %
%     Sequence length:           2                                             %
%     Cue locations:             20,    56                                     %
%     Cue durations:             500ms, 370ms                                  %
%     Stimulus onset asynchrony: 130ms                                         %
%     Stimulation location:      21                                            %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function [fields data sacTimes sacTargs] = HistedMillerTask
  
  %%  Establish Key Parameter Values
  %
  %   It's nice to have these in variables for plotting and/or analysis later.
  %
  
  stepSize     = 0.001;
  duration     = 30.0;
  cueLocations = [41   20   56];
  cueOnTimes   = [0     5    6.3];
  cueOffTimes  = [20   10   10];
  stimLocation = 21;
  stimOnTime   = 10;
  stimOffTime  = 19;
  
  
  %%  Run Control Simulation
  %
  %   In this section, we make a call to the function 'simulateTrial()' and
  %   pass several parameters describing the times and locations of the
  %   cues.  This function returns names and sizes of the model's fields
  %   and the raw cell traces for all nodes in all fields.
  % 
  
  disp('Running the Histed and Miller Control (Simulation 1 of 2)')
  disp('**********************************************************')  
  [fields data sacTimes sacTargs] =                                         ...
      simulateTrial('Step',         stepSize,                               ...
                    'Duration',     duration,                               ...
                    'CueLocations', cueLocations,                           ...
                    'CueOnTimes',   cueOnTimes,                             ...
                    'CueOffTimes',  cueOffTimes,                            ...
                    'StimLocation', stimLocation,                           ...
                    'StimOnTime',   stimOnTime,                             ...
                    'StimOffTime',  stimOffTime,                            ...
                    'StimStrength', 0,                                      ...
                    'CountCells',   length(cueLocations));
                                         
  
  %%  Plot Results
  %
  %   Using the values returned above, plot key model traces to show how
  %   the cues are loaded into working memory, and then read out to produce
  %   saccades to the appropriate locations.
  %
  
  keynum      = duration/stepSize + 1;
  figure('Position', [518 20 700 1000]);
  
  % Demonstrate the task inputs for the left column
  subplot(10, 2, 1)
  axis([1 30001 0 4])
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(-400, 3.275, 'Cue1', 'HorizontalAlignment', 'right')
  text(-400, 2.275, 'Cue2', 'HorizontalAlignment', 'right')
  text(-400, 1.275, 'Fix',  'HorizontalAlignment', 'right')
  text(-400, 0.275, 'Stim',  'HorizontalAlignment', 'right')
  line([1 30001], [0 0], 'Color', 'black')
  line([1 30001], [1 1], 'Color', 'black')
  line([1 30001], [2 2], 'Color', 'black')
  line([1 30001], [3 3], 'Color', 'black')
  
  % Represent fixation
  rectangle('Position', [1    1 20000 .5], 'FaceColor', 'black')
  % Represent Cue2
  rectangle('Position', [6300 2  3700 .5], 'FaceColor', 'black')
  % Represent Cue1
  rectangle('Position', [5000 3  5000 .5], 'FaceColor', 'black')
  
  title('Cell Traces in Control Condition', 'FontWeight', 'bold')  
  
  % Demonstrate the task inputs for the right column
  subplot(10, 2, 2)
  axis([1 30001 0 4])
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(-400, 3.275, 'Cue1', 'HorizontalAlignment', 'right')
  text(-400, 2.275, 'Cue2', 'HorizontalAlignment', 'right')
  text(-400, 1.275, 'Fix',  'HorizontalAlignment', 'right')
  text(-400, 0.275, 'Stim',  'HorizontalAlignment', 'right')
  line([1 30001], [0 0], 'Color', 'black')
  line([1 30001], [1 1], 'Color', 'black')
  line([1 30001], [2 2], 'Color', 'black')
  line([1 30001], [3 3], 'Color', 'black')
  
  % Represent Stimulation
  rectangle('Position', [10000 0  9000 .5], 'FaceColor', 'black')
  % Represent fixation
  rectangle('Position', [1     1 20000 .5], 'FaceColor', 'black')
  % Represent Cue2
  rectangle('Position', [6300  2  3700 .5], 'FaceColor', 'black')
  % Represent Cue1
  rectangle('Position', [5000  3  5000 .5], 'FaceColor', 'black')
  
  title('Cell Traces in Microstimulation Condition', 'FontWeight', 'bold')  
  
  % 7a Onset Cell (P^Y_i)
  subplot(10, 2, 3)
  PYi = data(:, fields.PYi(3):fields.PYi(4));
  plot([0:stepSize:duration]/10, PYi(1:keynum, max(PYi)>0), 'k')
  ylabel('P^Y_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PPC Area 7a Output Layer', 'FontWeight', 'bold')
  
  %LIP (P^L_i)
  subplot(10, 2, 5)
  PLi = data(:, fields.PLi(3):fields.PLi(4));
  plot([0:stepSize:duration]/10, PLi(1:keynum, max(PLi)>0), 'k')
  ylabel('P^L_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Lateral Intraparietal Cortex', 'FontWeight', 'bold')
  
  % dlPPC Spatial Working Memory Cell (M_ir)
  subplot(10, 2, [7 9])
  Mir = data(:, fields.Mir(3):fields.Mir(4));
  plot([0:stepSize:duration]/10, Mir(1:keynum, max(Mir)>0), 'k')
  ylabel('M_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PFC Item-Order-Rank Spatial Working Memory', 'FontWeight', 'bold')
  
  % SEF Direction Cell (S^Z_T)
  subplot(10, 2, 11)
  SYir = data(:, fields.SYir(3):fields.SYir(4));
  plot([0:stepSize:duration]/10, SYir(1:keynum, max(SYir)>0), 'k')
  ylabel('S^Y_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('SEF Selection Layer', 'FontWeight', 'bold')
  
  % SEF Descending Habituative Gates
  subplot(10, 2, 13)
  ZDir = data(:, fields.ZDir(3):fields.ZDir(4));
  plot([0:stepSize:duration]/10, ZDir(1:keynum, max(ZDir)>0), 'k')
  ylabel('Z^D_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Habituative Gates', 'FontWeight', 'bold')
  
  % SEF Output Cell (S^O_i)
  subplot(10, 2, 15)
  SOi = data(:, fields.SOi(3):fields.SOi(4));
  plot([0:stepSize:duration]/10, SOi(1:keynum, max(SOi)>0), 'k')
  ylabel('S^O_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('SEF Output Layer', 'FontWeight', 'bold')
  
  % FEF Output Cell (F^O_i)
  subplot(10, 2, 17)
  FOi = data(:, fields.FOi(3):fields.FOi(4));
  plot([0:stepSize:duration]/10, FOi(1:keynum, max(FOi)>0), 'k')
  ylabel('F^O_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('FEF Output Layer', 'FontWeight', 'bold')
  
  % Superior Colliculus (C_F)
  subplot(10, 2, 19)
  Ci = data(:, fields.Ci(3):fields.Ci(4));
  plot([0:stepSize:duration]/10, Ci(1:keynum, max(Ci)>0), 'k')
  ylabel('C_i')
  axis([0 3 0 1])
  set(gca, 'TickLength', [0; 0])
  set(gca, 'XTick', [0 .5 1 1.5 2 2.5 3])
  set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000', '2500', '3000'})
  title('Superior Colliculus', 'FontWeight', 'bold')
  
    
  
  
  %%  Run Microstimulation Simulation
  %
  %   In this section, we make a call to the function 'simulateTrial()' and
  %   pass several parameters describing the times and locations of the
  %   cues.  This function returns names and sizes of the model's fields
  %   and the raw cell traces for all nodes in all fields.
  % 
  
  disp(' ')
  disp('Running the Histed and Miller Stimulation (Simulation 2 of 2)')
  disp('**********************************************************')  
  [fields data sacTimes sacTargs] =                                         ...
      simulateTrial('Step',         stepSize,                               ...
                    'Duration',     duration,                               ...
                    'CueLocations', cueLocations,                           ...
                    'CueOnTimes',   cueOnTimes,                             ...
                    'CueOffTimes',  cueOffTimes,                            ...
                    'StimLocation', stimLocation,                           ...
                    'StimOnTime',   stimOnTime,                             ...
                    'StimOffTime',  stimOffTime,                            ...
                    'CountCells',   length(cueLocations));
  
  
  %%  Plot Results
  %
  %   Using the values returned above, plot key model traces to show how
  %   the cues are loaded into working memory, and then read out to produce
  %   saccades to the appropriate locations.
  %
  
  % 7a Onset Cell (P^Y_i)
  subplot(10, 2, 4)
  PYi = data(:, fields.PYi(3):fields.PYi(4));
  plot([0:stepSize:duration]/10, PYi(1:keynum, max(PYi)>0), 'k')
  ylabel('P^Y_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PPC Area 7a Output Layer', 'FontWeight', 'bold')
  
  %LIP (P^L_i)
  subplot(10, 2, 6)
  PLi = data(:, fields.PLi(3):fields.PLi(4));
  plot([0:stepSize:duration]/10, PLi(1:keynum, max(PLi)>0), 'k')
  ylabel('P^L_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Lateral Intraparietal Cortex', 'FontWeight', 'bold')
  
  % dlPPC Spatial Working Memory Cell (M_ir)
  subplot(10, 2, [8, 10])
  Mir = data(:, fields.Mir(3):fields.Mir(4));
  plot([0:stepSize:duration]/10, Mir(1:keynum, max(Mir)>0), 'k')
  ylabel('M_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PFC Item-Order-Rank Spatial Working Memory', 'FontWeight', 'bold')
  
  % SEF Direction Cell (S^Z_T)
  subplot(10, 2, 12)
  SYir = data(:, fields.SYir(3):fields.SYir(4));
  hold on
  plot([0:stepSize:duration]/10, SYir(1:keynum, 1:50:end), 'k')
  plot([0:stepSize:duration]/10, SYir(1:keynum, 20), 'k')
  plot([0:stepSize:duration]/10, SYir(1:keynum, 137),'k')
  ylabel('S^Y_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('SEF Selection Layer', 'FontWeight', 'bold')

  % SEF Descending Habituative Gates
  subplot(10, 2, 14)
  ZDir = data(:, fields.ZDir(3):fields.ZDir(4));
  hold on
  plot([0:stepSize:duration]/10, ZDir(1:keynum, 1:50:end), 'k')
  plot([0:stepSize:duration]/10, ZDir(1:keynum, 20),  'k')
  plot([0:stepSize:duration]/10, ZDir(1:keynum, 137), 'k')
  ylabel('Z^D_{ir}')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Habituative Gates', 'FontWeight', 'bold')

  % SEF Output Cell (S^O_i)
  subplot(10, 2, 16)
  SOi = data(:, fields.SOi(3):fields.SOi(4));
  hold on
  plot([0:stepSize:duration]/10, SOi(1:keynum, 1:10:end), 'k')
  plot([0:stepSize:duration]/10, SOi(1:keynum, 20),  'k')
  plot([0:stepSize:duration]/10, SOi(1:keynum, 56), 'k')
  ylabel('S^O_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('SEF Output Layer', 'FontWeight', 'bold')
  
  % FEF Output Cell (F^O_i)
  subplot(10, 2, 18)
  FOi = data(:, fields.FOi(3):fields.FOi(4));
  plot([0:stepSize:duration]/10, FOi(1:keynum, max(FOi)>0), 'k')
  ylabel('F^O_i')
  axis([0 3 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('FEF Output Layer', 'FontWeight', 'bold')
  
  % Superior Colliculus (C_F)
  subplot(10, 2, 20)
  Ci = data(:, fields.Ci(3):fields.Ci(4));
  plot([0:stepSize:duration]/10, Ci(1:keynum, max(Ci)>0), 'k')
  ylabel('C_i')
  axis([0 3 0 1])
  set(gca, 'TickLength', [0; 0])
  set(gca, 'XTick', [0 .5 1 1.5 2 2.5 3])
  set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000', '2500', '3000'})
  title('Superior Colliculus', 'FontWeight', 'bold')

end
