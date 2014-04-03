% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%                      Immediate Serial Recall (ISR) Task                      %
%                                                                              %
%   In the ISR task,  a fixation cue, toward which  the participant  directs   %
%   and maintains gaze, is presented at  the center of the visual field.  As   % 
%   the fixation cue remains present,  a number of subsequent cues are shown   %
%   at various spatial locations which the participant must remember.   Once   %
%   the fixation cue is removed,  the participant reproduces the sequence of   %
%   spatial cues by saccading to the remembered locations  in the order they   %
%   were cued.                                                                 %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function [fields data] = ImmediateSerialRecallTask

  %%  Establish Key Parameter Values
  %
  %   It's nice to have these in variables for plotting and/or analysis later.
  %
  
  stepSize     = 0.0001;
  duration     = 2.0;
  cueLocations = [41     38    14    38    68];
  cueOnTimes   = [0.0    0.1   0.3   0.5   0.7];
  cueOffTimes  = [1.0    0.2   0.4   0.6   0.8];
  
  
  %%  Run Simulation
  %
  %   In this section, we make a call to the function 'simulateTrial()' and
  %   pass several parameters describing the times and locations of the
  %   cues.  This function returns names and sizes of the model's fields
  %   and the raw cell traces for all nodes in all fields.
  % 
  
  disp('Running the Immediate Serial Recall Task (Simulation 1 of 1)')
  disp('**********************************************************')  
  [fields data] = simulateTrial('Step',         stepSize,                    ...
                                'Duration',     duration,                    ...
                                'CueLocations', cueLocations,                ...
                                'CueOnTimes',   cueOnTimes,                  ...
                                'CueOffTimes',  cueOffTimes,                 ...
                                'CountCells',   length(cueLocations));
   
  
  %%  Plot Results
  %
  %   Using the values returned above, plot key model traces to show how
  %   the cues are loaded into working memory, and then read out to produce
  %   saccades to the appropriate locations.
  %
  
  % Key model traces
  keynum = duration/stepSize + 1;
  
  figure('Position', [518 20 700 900])
  subplot(9, 1, 1);
  PYi = data(:, fields.PYi(3):fields.PYi(4));
  plot(0:stepSize:duration, PYi(1:keynum, max(PYi)>0), 'k');
  ylabel('P^Y_i');
  title('A. PPC Area 7a Output Layer', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 2);
  PLi = data(:, fields.PLi(3):fields.PLi(4));
  plot(0:stepSize:duration, PLi(1:keynum, max(PLi)>0), 'k');
  ylabel('P^L_i');
  title('B. Lateral Intraparietal Cortex', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 3);
  
  % Generate a representation of SPL counting cells:
  rowheight   = 0.25;
  pulseheight = 0.15; 
  PCr         = zeros(length(cueLocations)-1, (duration/stepSize)+1);
  for i = 1:length(cueLocations)-1
      PCr(i, :) = rowheight*(i-1);
      if i < length(cueLocations)-1
          PCr(i, fix(cueOnTimes(i+1)/stepSize+1):fix(cueOnTimes(i+2)/stepSize+1))      ...
              = rowheight*(i-1)+pulseheight;
      else
          PCr(i, fix(cueOnTimes(i+1)/stepSize+1):end)                             ...
              = rowheight*(i-1)+pulseheight;
      end
  end
  
  plot(0:stepSize:duration, PCr, 'k');
  ylabel('P^C_r');
  title('C. SPL Counting Cells', 'FontWeight', 'bold')
  set(gca, 'XTick', []);
  set(gca, 'YTick', [.125:.25:1]);
  set(gca, 'YTickLabel', {'1', '2', '3', '4'})
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 4);
  Mir = data(:, fields.Mir(3):fields.Mir(4));
  plot(0:stepSize:duration, Mir(1:keynum, max(Mir)>0), 'k');
  ylabel('M_{ir}');  
  title('D. PFC Item-Order-Rank Working Memory', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 5);
  SYir = data(:, fields.SYir(3):fields.SYir(4));
  plot(0:stepSize:duration, SYir(1:keynum, max(SYir)>0), 'k');
  ylabel('S^Y_{ir}');
  title('E. SEF Selection Layer', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 6);
  SOi = data(:, fields.SOi(3):fields.SOi(4));
  plot(0:stepSize:duration, SOi(1:keynum, max(SOi)>0), 'k');
  ylabel('S^O_i');
  title('F. SEF Output Layer', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 7);
  FOi = data(:, fields.FOi(3):fields.FOi(4));
  plot(0:stepSize:duration, FOi(1:keynum, max(FOi)>0), 'k');
  ylabel('F^O_i');
  title('G. FEF Output Layer', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 8);
  GNi = data(:, fields.GNi(3):fields.GNi(4));
  plot(0:stepSize:duration, GNi(1:keynum, max(GNi)>0), 'k');
  ylabel('G^N_i');
  title('H. Colliculus-Projecting SNr', 'FontWeight', 'bold');
  set(gca, 'XTick', []);
  set(gca, 'TickLength', [0 0])
  
  subplot(9, 1, 9);
  Ci = data(:, fields.Ci(3):fields.Ci(4));
  plot(0:stepSize:duration, Ci(1:keynum, max(Ci)>0), 'k');
  ylabel('C_i');
  xlabel('time (ms)')
  title('I. Superior Colliculus', 'FontWeight', 'bold');
  set(gca, 'XTick', [0:.5:2]);
  set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000'})
  set(gca, 'TickLength', [0 0])
  
  % Mark fixation offset with dotted line
  annotation(gcf, 'line', [0.5175 0.5175], [0.9069 0.1100], 'LineStyle', ':');
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Expanded plot
  %figure
  %fixLocation = 41;
  %cueLocation = [14 38 68];
  %
  %%LIP fixation cell (P^L_F)
  %subplot(9, 2, 1)
  %PLi = data(:, fields.PLi(3):fields.PLi(4));
  %plot(0:stepSize:duration, PLi(1:keynum, fixLocation))
  %ylabel('P^L_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('LIP Fixation Cell')
  %
  %% LIP movement cell (P^L_T)
  %subplot(9, 2, 3)
  %PLi = data(:, fields.PLi(3):fields.PLi(4));
  %plot(0:stepSize:duration, PLi(1:keynum, cueLocation))
  %ylabel('P^L_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('LIP Movement Cell')
  %
  %% 7a Onset Cell (Fixation Point) (P^Z_F)
  %subplot(9, 2, 5)
  %PYi = data(:, fields.PYi(3):fields.PYi(4));
  %plot(0:stepSize:duration, PYi(1:keynum, fixLocation))
  %ylabel('P^Y_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('PPC Area 7a Onset Cell (Direction of Gaze)')
  %
  %% 7a Onset Cell (Target) (P^Z_F)
  %subplot(9, 2, 7)
  %PYi = data(:, fields.PYi(3):fields.PYi(4));
  %plot(0:stepSize:duration, PYi(1:keynum, cueLocation))
  %ylabel('P^Y_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('PPC Area 7a Onset Cell (Target)')
  %
  %% dlPPC Spatial Working Memory Cell (M_T1)
  %subplot(9, 2, 9)
  %Mir = data(:, fields.Mir(3):fields.Mir(4));
  %plot(0:stepSize:duration, Mir(1:keynum, cueLocation))
  %ylabel('M_{T1}')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('dlPFC Spatial Working Memory Cell')
  %
  %% SEF Direction Cell (S^Z_T)
  %subplot(9, 2, 11)
  %SOi = data(:, fields.SOi(3):fields.SOi(4));
  %plot(0:stepSize:duration, SOi(1:keynum, cueLocation))
  %ylabel('S^O_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('SEF Direction Cell')
  %
  %% FEF Plan Cell (F^P_T)
  %subplot(9, 2, 13)
  %FPi = data(:, fields.FPi(3):fields.FPi(4));
  %plot(0:stepSize:duration, FPi(1:keynum, cueLocation))
  %ylabel('F^P_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('FEF Plan Cell')
  %
  %% FEF Output Cell (F^O_T)
  %subplot(9, 2, 15)
  %FOi = data(:, fields.FOi(3):fields.FOi(4));
  %plot(0:stepSize:duration, FOi(1:keynum, cueLocation))
  %ylabel('F^O_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('FEF Output Cell')
  %
  %% FEF Post-saccadic Cell (F^X_T)
  %subplot(9, 2, 17)
  %FXi = data(:, fields.FXi(3):fields.FXi(4));
  %plot(0:stepSize:duration, FXi(1:keynum, cueLocation))
  %ylabel('F^X_T')
  %axis([0 2 0 1])
  %set(gca, 'TickLength', [0; 0])
  %set(gca, 'XTick', [0 .5 1 1.5 2])
  %set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000'})
  %xlabel('time (ms)')
  %title('FEF Post-saccadic Cell')
  %
  %% Nigrothalamic SNr Saccade-Related Cell (B^N_T)
  %subplot(9, 2, 2)
  %BNi = data(:, fields.BNi(3):fields.BNi(4));
  %plot(0:stepSize:duration, BNi(1:keynum, cueLocation))
  %ylabel('B^N_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Nigrothalamic SNr Saccade-Related Cell')
  %
  %% Thalamus Plan Selection Cell (T_T)
  %subplot(9, 2, 4)
  %Ti = data(:, fields.Ti(3):fields.Ti(4));
  %plot(0:stepSize:duration, Ti(1:keynum, cueLocation))
  %ylabel('T_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Thalamus Plan Selection Cell')
  %
  %% Nigrocollicular Striatal Direct Fixation-Related Cell (G^D_F)
  %subplot(9, 2, 6)
  %GDi = data(:, fields.GDi(3):fields.GDi(4));
  %plot(0:stepSize:duration, GDi(1:keynum, fixLocation))
  %ylabel('G^D_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Nigrocollicular Striatal Direct Fixation-Related Cell')
  %
  %% Nigrocollicular Striatal Direct Saccade-Related Cell (G^D_T)
  %subplot(9, 2, 8)
  %GDi = data(:, fields.GDi(3):fields.GDi(4));
  %plot(0:stepSize:duration, GDi(1:keynum, cueLocation))
  %ylabel('G^D_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Nigrocollicular Striatal Direct Saccade-Related Cell')
  %
  %% Nigrocollicular Striatal Indirect Fixation-Related Cell (G^I_F)
  %subplot(9, 2, 10)
  %GIi = data(:, fields.GIi(3):fields.GIi(4));
  %plot(0:stepSize:duration, GIi(1:keynum, cueLocation))
  %ylabel('G^I_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Nigrocollicular Striatal Indirect Fixation-Related Cell')
  %
  %% Nigrocollicular SNr Fixation-Related Cell (G^N_F)
  %subplot(9, 2, 12)
  %GNi = data(:, fields.GNi(3):fields.GNi(4));
  %plot(0:stepSize:duration, GNi(1:keynum, fixLocation))
  %ylabel('G^N_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Nigrocollicular SNr Fixation-Related Cell')
  %
  %% Nigrocollicular SNr Saccade-Related Cell (G^N_T)
  %subplot(9, 2, 14)
  %GNi = data(:, fields.GNi(3):fields.GNi(4));
  %plot(0:stepSize:duration, GNi(1:keynum, cueLocation))
  %ylabel('G^N_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %title('Nigrocollicular SNr Saccade-Related Cell')
  %
  %% Superior Colliculus Fixation Cell (C_F)
  %subplot(9, 2, 16)
  %Ci = data(:, fields.Ci(3):fields.Ci(4));
  %plot(0:stepSize:duration, Ci(1:keynum, fixLocation))
  %ylabel('C_F')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [])
  %set(gca, 'TickLength', [0; 0])
  %title('Superior Colliculus Fixation Cell')
  %
  %% Superior Colliculus Burst Cell (C_T)
  %subplot(9, 2, 18)
  %Ci = data(:, fields.Ci(3):fields.Ci(4));
  %plot(0:stepSize:duration, Ci(1:keynum, cueLocation))
  %ylabel('C_T')
  %axis([0 2 0 1])
  %set(gca, 'XTick', [0 .5 1 1.5 2])
  %set(gca, 'XTickLabel', {'0', '500', '1000', '1500', '2000'})
  %set(gca, 'TickLength', [0; 0])
  %xlabel('time (ms)')
  %title('Superior Colliculus Burst Cell')
  
end
