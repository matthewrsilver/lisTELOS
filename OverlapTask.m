% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%                                 Overlap Task                                 %
%                                                                              %
%   The overlap task is one of the four benchmark saccade tasks simulated by   %
%   the model.   This task tests the ability to  withhold a reactive saccade   %
%   when a cue is presented but fixation should be maintained.  If the model   %
%   were not able to  balance between planned and reactive  saccade commands   %
%   as described by the TELOS model (Brown, Bullock and Grossberg 2004) then   %
%   it would saccade reactively to the cue even though the fixation point is   %
%   still present.                                                             %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function [fields data] = OverlapTask

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Initialize parameters for simulation  
  %
      
  % Add directories containing helper functions to MATLAB's execution path
  addpath tools tools/signalFunctions

  % Initialize parameters    
  duration     = 2;
  stepSize     = 0.0001;
  useWM        = 0;
  cueLocations = [41 14];
  cueOnTimes   = [0.0  0.5];
  cueOffTimes  = [1.0  1.5];
  stimLocation = 41;
  stimOnTime   = 2;
  stimOffTime  = 2;
  stimStrength = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Run the task
  %

  disp('Running the Overlap Task (Simulation 1 of 1)')
  disp('**********************************************************')
  [fields data sacTimes sacTargets] =             ...
      simulateTrial('Step',         stepSize,     ...
                    'Duration',     duration,     ...
                    'UseWM',        useWM,        ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime,  ...
                    'StimStrength', stimStrength);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;

  
  % Find the time at which eye position moved to the target location
  OverlapTime    = sacTimes(sacTargets == cueLocations(2));
  
  % Compute the latency
  OverlapLatency = (OverlapTime - cueOffTimes(1))*1000; 
  
  % Print latency
  disp(' ')
  disp(['Saccade Latency: ' num2str(OverlapLatency) ' ms'])
  disp(' ')

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Plot the results
  %
  
  % having these values makes things easier...
  keynum      = duration/stepSize + 1;
  fixLocation = 41;
  cueLocation = 14;
  saccadeStep = round(OverlapTime/stepSize + 1);
  
  figure('Position', [518 20 700 900]);
  % Demonstrate the task inputs for the left column
  subplot(10, 2, 1)
  baseEyePos = zeros(1, duration/stepSize + 1);
  baseEyePos(saccadeStep:end) = .5;
  plot(baseEyePos, 'k');
  axis([1 20001 0 3])
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(-400, 0.275, 'E', 'HorizontalAlignment', 'center')
  text(-400, 1.275, 'T', 'HorizontalAlignment', 'center')
  text(-400, 2.275, 'F', 'HorizontalAlignment', 'center')
  line([1 20001], [1 1], 'Color', 'black')
  line([1 20001], [2 2], 'Color', 'black')
  rectangle('Position', [5001 1 10000 .5], 'FaceColor', 'black')
  rectangle('Position', [1    2 10000 .5], 'FaceColor', 'black')
  title('Cortical Cells in Overlap Task')

  [figx figy] = dsxy2figxy([5001 5001], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  [figx figy] = dsxy2figxy([10001 10001], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  [figx figy] = dsxy2figxy([saccadeStep saccadeStep], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  % Demonstrate the task inputs for the right column
  subplot(10, 2, 2)
  baseEyePos = zeros(1, duration/stepSize + 1);
  baseEyePos(saccadeStep:end) = .5;
  plot(baseEyePos, 'k');
  axis([1 20001 0 3])
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(-400, 0.275, 'E', 'HorizontalAlignment', 'center')
  text(-400, 1.275, 'T', 'HorizontalAlignment', 'center')
  text(-400, 2.275, 'F', 'HorizontalAlignment', 'center')
  line([1 20001], [1 1], 'Color', 'black')
  line([1 20001], [2 2], 'Color', 'black')
  rectangle('Position', [5001 1 10000 .5], 'FaceColor', 'black')
  rectangle('Position', [1    2 10000 .5], 'FaceColor', 'black')
  title('Subcortical Cells in Overlap Task')
  
  [figx figy] = dsxy2figxy([5001 5001], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  [figx figy] = dsxy2figxy([10001 10001], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  [figx figy] = dsxy2figxy([saccadeStep saccadeStep], [2 -37.5]); 
  annotation(gcf, 'line', [figx], [figy], 'LineStyle', ':');
  
  %LIP fixation cell (P^L_F)
  subplot(10, 2, 3)
  PLi = data(:, fields.PLi(3):fields.PLi(4));
  plot(0:stepSize:duration, PLi(1:keynum, fixLocation), 'k')
  ylabel('P^L_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('LIP Fixation Cell')
  
  % LIP movement cell (P^L_T)
  subplot(10, 2, 5)
  PLi = data(:, fields.PLi(3):fields.PLi(4));
  plot(0:stepSize:duration, PLi(1:keynum, cueLocation), 'k')
  ylabel('P^L_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('LIP Movement Cell')
  
  % 7a Onset Cell (Fixation Point) (P^Z_F)
  subplot(10, 2, 7)
  PYi = data(:, fields.PYi(3):fields.PYi(4));
  plot(0:stepSize:duration, PYi(1:keynum, fixLocation), 'k')
  ylabel('P^Y_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PPC Area 7a Onset Cell (Direction of Gaze)')

  % 7a Onset Cell (Target) (P^Z_F)
  subplot(10, 2, 9)
  PYi = data(:, fields.PYi(3):fields.PYi(4));
  plot(0:stepSize:duration, PYi(1:keynum, cueLocation), 'k')
  ylabel('P^Y_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('PPC Area 7a Onset Cell (Target)')
  
  % dlPPC Spatial Working Memory Cell (M_T1)
  subplot(10, 2, 11)
  Mir = data(:, fields.Mir(3):fields.Mir(4));
  plot(0:stepSize:duration, Mir(1:keynum, cueLocation), 'k')
  ylabel('M_{T1}')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('dlPFC Spatial Working Memory Cell')
  
  % SEF Direction Cell (S^Z_T)
  subplot(10, 2, 13)
  SOi = data(:, fields.SOi(3):fields.SOi(4));
  plot(0:stepSize:duration, SOi(1:keynum, cueLocation), 'k')
  ylabel('S^O_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('SEF Direction Cell')

  % FEF Plan Cell (F^P_T)
  subplot(10, 2, 15)
  FPi = data(:, fields.FPi(3):fields.FPi(4));
  plot(0:stepSize:duration, FPi(1:keynum, cueLocation), 'k')
  ylabel('F^P_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('FEF Plan Cell')
  
  % FEF Output Cell (F^O_T)
  subplot(10, 2, 17)
  FOi = data(:, fields.FOi(3):fields.FOi(4));
  plot(0:stepSize:duration, FOi(1:keynum, cueLocation), 'k')
  ylabel('F^O_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('FEF Output Cell')
  
  % FEF Post-saccadic Cell (F^X_T)
  subplot(10, 2, 19)
  FXi = data(:, fields.FXi(3):fields.FXi(4));
  plot(0:stepSize:duration, FXi(1:keynum, cueLocation), 'k')
  ylabel('F^X_T')
  axis([0 2 0 1])
  set(gca, 'TickLength', [0; 0])
  set(gca, 'XTick', [0 .5 1 1.5 2])
  set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000'})
  xlabel('time (ms)')
  title('FEF Post-saccadic Cell')
  
  % Nigrothalamic SNr Saccade-Related Cell (B^N_T)
  subplot(10, 2, 4)
  BNi = data(:, fields.BNi(3):fields.BNi(4));
  plot(0:stepSize:duration, BNi(1:keynum, cueLocation), 'k')
  ylabel('B^N_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Nigrothalamic SNr Saccade-Related Cell')
  
  % Thalamus Plan Selection Cell (T_T)
  subplot(10, 2, 6)
  Ti = data(:, fields.Ti(3):fields.Ti(4));
  plot(0:stepSize:duration, Ti(1:keynum, cueLocation), 'k')
  ylabel('T_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Thalamus Plan Selection Cell')
  
  % Nigrocollicular Striatal Direct Fixation-Related Cell (G^D_F)
  subplot(10, 2, 8)
  GDi = data(:, fields.GDi(3):fields.GDi(4));
  plot(0:stepSize:duration, GDi(1:keynum, fixLocation), 'k')
  ylabel('G^D_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Nigrocollicular Striatal Direct Fixation-Related Cell')
  
  % Nigrocollicular Striatal Direct Saccade-Related Cell (G^D_T)
  subplot(10, 2, 10)
  GDi = data(:, fields.GDi(3):fields.GDi(4));
  plot(0:stepSize:duration, GDi(1:keynum, cueLocation), 'k')
  ylabel('G^D_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Nigrocollicular Striatal Direct Saccade-Related Cell')
  
  % Nigrocollicular Striatal Indirect Fixation-Related Cell (G^I_F)
  subplot(10, 2, 12)
  GIi = data(:, fields.GIi(3):fields.GIi(4));
  plot(0:stepSize:duration, GIi(1:keynum, cueLocation), 'k')
  ylabel('G^I_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Nigrocollicular Striatal Indirect Fixation-Related Cell')
  
  % Nigrocollicular SNr Fixation-Related Cell (G^N_F)
  subplot(10, 2, 14)
  GNi = data(:, fields.GNi(3):fields.GNi(4));
  plot(0:stepSize:duration, GNi(1:keynum, fixLocation), 'k')
  ylabel('G^N_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Nigrocollicular SNr Fixation-Related Cell')
  
  % Nigrocollicular SNr Saccade-Related Cell (G^N_T)
  subplot(10, 2, 16)
  GNi = data(:, fields.GNi(3):fields.GNi(4));
  plot(0:stepSize:duration, GNi(1:keynum, cueLocation), 'k')
  ylabel('G^N_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  title('Nigrocollicular SNr Saccade-Related Cell')
  
  % Superior Colliculus Fixation Cell (C_F)
  subplot(10, 2, 18)
  Ci = data(:, fields.Ci(3):fields.Ci(4));
  plot(0:stepSize:duration, Ci(1:keynum, fixLocation), 'k')
  ylabel('C_F')
  axis([0 2 0 1])
  set(gca, 'XTick', [])
  set(gca, 'TickLength', [0; 0])
  title('Superior Colliculus Fixation Cell')
  
  % Superior Colliculus Burst Cell (C_T)
  subplot(10, 2, 20)
  Ci = data(:, fields.Ci(3):fields.Ci(4));
  plot(0:stepSize:duration, Ci(1:keynum, cueLocation), 'k')
  ylabel('C_T')
  axis([0 2 0 1])
  set(gca, 'XTick', [0 .5 1 1.5 2])
  set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000'})
  set(gca, 'TickLength', [0; 0])
  xlabel('time (ms)')
  title('Superior Colliculus Burst Cell')

end
