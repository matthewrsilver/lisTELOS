% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%            Yang, Heinen and Missal Visually-Guided Saccade Task              %
%                                                                              %
%   This task has the same structure as the saccade (gap 0) task,  though it   % 
%   also includes microstimulation at two intervals (early, late).  Yang and   %
%   colleagues  observed that  SEF microstimulation in  this task  sometimes   %
%   altered saccade latency.  The simulations in this function capture three   %
%   of the observed latency differences: ipsilateral delay,  bilateral delay   %
%   and contralateral facilitation.                                            %
%                                                                              %
%   That the model can simulate these tasks,  reproducing observations about   %
%   microstimulation changing saccade latency,  and also simulate the Histed   %
%   and Miller (2006) task  without latency changes following stimulation is   %
%   a fundamental competency of the model.                                     %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function YangOthersTask

  %%  Establish Key Parameter Values
  %
  %   It's nice to have these in variables for plotting and/or analysis later.
  %

  step                  = 0.0001;  
  duration              = 1.0;     
  cueOnTimes            = [0.0  0.5];
  cueOffTimes           = [0.5  1.0];

  %%  Run Contralateral Control Simulations
  %
  %   During control simulations, there is no microstimulation.
  %   The results can then be used as controls against the
  %   stimulation trials that follow.
  %

  % Specify parameters for the control contralateral simulation  
  saccadeTarget         = 14;
  cueLocations          = [41 saccadeTarget];
  
  % Run the contralateral control simulation  
  disp('Running the Control "Contralateral" Task (Simulation 1 of 8)')
  disp('**********************************************************')
  disp('Stim Interval:  None');
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] =             ...
    simulateTrial('Step',         step,         ...
		  'Duration',     duration,     ...
		  'UseWM',        0,            ...
		  'CueLocations', cueLocations, ...
		  'CueOnTimes',   cueOnTimes,   ...
		  'CueOffTimes',  cueOffTimes,  ...
		  'StimStrength', 0);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  contraControlStep    = floor(sacTimes(2)/step);
  contraControlLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(contraControlLatency)]); 
  disp(' ');
  
  
        
  %%  Run Ipsilateral Control Simulations
  %
  %   During control simulations, there is no microstimulation.  
  %   The results can then be used as controls against the
  %   stimulation trials that follow.
  %
        
  % Specify parameters for the control ipsilateral simulation
  saccadeTarget         = 68;
  cueLocations          = [41 saccadeTarget];
  
  % Run the ipsilateral control simulation
  disp('Running the Control "Ipsilateral" Task (Simulation 2 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  None');
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] =               ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimStrength', 0);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  ipsiControlStep    = floor(sacTimes(2)/step);
  ipsiControlLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(ipsiControlLatency)]); 
  disp(' ');
  
  
  %% Plot Control Data
  %
  %  Now that the control simulations are finished, we can plot
  %  control data in each of the three subplots.  Then, as the
  %  rest of the simulations are run, data can be filled in.

  figure('Position', [518 20 500 900]);
  
  % Control data for Ipsilateral Delay plot
  subplot(3, 1, 1)
  axis([4000 10000 -2 2])
  hold on
  x = zeros(1, duration/step);
  x(contraControlStep:end) = 1;
  plot(smooth(x, 201, 'lowess'))
  
  x = zeros(1, duration/step);
  x(ipsiControlStep:end) = -1;
  plot(smooth(x, 201, 'lowess'));
  
  % Control data for Bilateral Delay plot
  subplot(3, 1, 2)
  axis([4000 10000 -2 2])
  hold on
  x = zeros(1, duration/step);
  x(contraControlStep:end) = 1;
  plot(smooth(x, 201, 'lowess'))
  
  x = zeros(1, duration/step);
  x(ipsiControlStep:end) = -1;
  plot(smooth(x, 201, 'lowess'));
  
  % Control data for Contralateral Facilitation plot
  subplot(3, 1, 3)
  axis([4000 10000 -2 2])
  hold on
  x = zeros(1, duration/step);
  x(contraControlStep:end) = 1;
  plot(smooth(x, 201, 'lowess'))
  
  x = zeros(1, duration/step);
  x(ipsiControlStep:end) = -1;
  plot(smooth(x, 201, 'lowess'));
  
  
  
  %%  Run Ipsilateral Delay Simulation (Ipsilateral Target)
  %
  %   
  
  % Set parameters for Ipsilateral Delay (Ipsilateral Target)
  saccadeTarget         = 14;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 60;
  stimOnTime            = 0.575;
  stimOffTime           = 0.675;
  
  % Run Ipsilateral Delay (Ipsilateral Target)
  disp('Running the Ipsilateral Delay Example (Simulation 3 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Late');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] =               ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  ipsiStep    = floor(sacTimes(2)/step);
  ipsiLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(ipsiLatency)]); 
  disp(' ');
  
  
  
  %%  Run Ipsilateral Delay Simulation (Contralateral Target)
  %
  %   
  
  % Set parameters for Ipsilateral Delay (Contralateral Target)
  saccadeTarget         = 68;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 60;
  stimOnTime            = 0.575;
  stimOffTime           = 0.675;
  
  disp('Running the Ipsilateral Delay Example (Simulation 4 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Late');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] = ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;

  
  % Store latency information and display
  contraStep    = floor(sacTimes(2)/step);
  contraLatency = 1000*(sacTimes(2)-.5);
  
  disp(' '); 
  disp(['Latency:        ' num2str(contraLatency)]); 
  disp(' ');

  
  
  %%  Plot Ipsilateral Delay Simulation
  %
  %   

  % Finalize Ipsilateral Delay Plot
  subplot(3, 1, 1)
  title('ipsilateral delay')  
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(9000, 0.6, 'contra', 'HorizontalAlignment', 'center')
  text(9000, -0.8, 'ipsi', 'HorizontalAlignment', 'center')
  line([5750 6750], [-1.2 -1.2], 'Color', 'black')
  
  % Plot ipsilateral data
  x = zeros(1, duration/step);
  x(ipsiStep:end) = -1;
  plot(smooth(x, 201, 'lowess'), 'r')
  
  % Plot contralateral data
  x = zeros(1, duration/step);
  x(contraStep:end) = 1;
  plot(smooth(x, 201, 'lowess'), 'r')

  
  
  
  %%  Run Bilateral Delay Simulation (Ipsilateral Target)
  %
  %   
  
  % Set parameters for Bilateral Delay (Ipsilateral Target)
  saccadeTarget         = 14;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 44;
  stimOnTime            = 0.575;
  stimOffTime           = 0.675;
  
  disp('Running the Bilateral Delay Example (Simulation 5 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Late');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] =               ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  ipsiStep    = floor(sacTimes(2)/step);
  ipsiLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(ipsiLatency)]);
  disp(' ');
  
  
  
  %%  Run Bilateral Delay Simulation (Contralateral Target)
  %
  %   

  % Set parameters for Bilateral Delay (Contralateral Target)
  saccadeTarget         = 68;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 44;
  stimOnTime            = 0.575;
  stimOffTime           = 0.675;
  
  disp('Running the Bilateral Delay Example (Simulation 6 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Late');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]);
  disp(' ');
  
  [fields data sacTimes sacTargs] = ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  contraStep    = floor(sacTimes(2)/step);
  contraLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(contraLatency)]);
  disp(' ');
  
  
  %%  Plot Bilateral Delay Simulation
  %
  %   

  % Finalize Bilateral Delay plot
  subplot(3, 1, 2)
  title('bilateral delay')
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(9000, 0.6, 'contra', 'HorizontalAlignment', 'center')
  text(9000, -0.8, 'ipsi', 'HorizontalAlignment', 'center')
  line([5750 6750], [-1.2 -1.2], 'Color', 'black')
  
  % Plot ipsilateral data
  x = zeros(1, duration/step);
  x(ipsiStep:end) = -1;
  plot(smooth(x, 201, 'lowess'), 'r')
  
  % Plot contralateral data
  x = zeros(1, duration/step);
  x(contraStep:end) = 1;
  plot(smooth(x, 201, 'lowess'), 'r')
  

  
  %%  Run Contralateral Facilitation Simulation (Contralateral Target)
  %
  %   
    
  % Set parameters for contralateral facilitation (contralateral target)
  saccadeTarget         = 14;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 14;
  stimOnTime            = 0.475;
  stimOffTime           = 0.575;
  
  disp('Running the Contralateral Facilitation Example (Simulation 7 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Early');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] =               ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);

  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  contraStep    = floor(sacTimes(2)/step);
  contraLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(contraLatency)]);
  disp(' ');

  
  
  %%  Run Contralateral Facilitation Simulation (Ipsilateral Target)
  %
  % 
  
  % Set parameters for contralateral facilitation (ipsilateral target)
  saccadeTarget         = 68;
  cueLocations          = [41 saccadeTarget];
  stimLocation          = 14;
  stimOnTime            = 0.475;
  stimOffTime           = 0.575;

  disp('Running the Contralateral Facilitation Example (Simulation 8 of 8)')
  disp('**********************************************************')  
  disp('Stim Interval:  Early');
  disp(['Stim Location:  ' num2str(stimLocation)]);
  disp(['Saccade Target: ' num2str(saccadeTarget)]); disp(' ');
  
  [fields data sacTimes sacTargs] = ...
      simulateTrial('Step',         step,         ...
                    'Duration',     duration,     ...
                    'UseWM',        0,            ...
                    'CueLocations', cueLocations, ...
                    'CueOnTimes',   cueOnTimes,   ...
                    'CueOffTimes',  cueOffTimes,  ...
                    'StimLocation', stimLocation, ...
                    'StimOnTime',   stimOnTime,   ...
                    'StimOffTime',  stimOffTime);
  
  % Correct outputs back into seconds
  sacTimes = sacTimes./10;
  
  % Store latency information and display
  ipsiStep    = floor(sacTimes(2)/step);
  ipsiLatency = 1000*(sacTimes(2)-.5);
  
  disp(' ');
  disp(['Latency:        ' num2str(ipsiLatency)]);
  disp(' ');

  
  
  %%  Plot Contralateral Facilitation Simulation
  %
  % 

  % Finalize contralateral facilitation plot
  subplot(3, 1, 3);
  title('contralateral facilitation')
  set(gca, 'XTick', [])
  set(gca, 'YTick', [])
  set(gca, 'Box', 'off')
  set(gca, 'XColor', 'white')
  set(gca, 'YColor', 'white')
  set(gca, 'TickLength', [0; 0])
  text(9000, 0.6, 'contra', 'HorizontalAlignment', 'center')
  text(9000, -0.8, 'ipsi', 'HorizontalAlignment', 'center')
  line([4750 5750], [-1.2 -1.2], 'Color', 'black')

  % Plot contralateral data
  x = zeros(1, duration/step);
  x(contraStep:end) = 1;
  plot(smooth(x, 201, 'lowess'), 'r')
  
  % Plot ipsilateral data
  x = zeros(1, duration/step);
  x(ipsiStep:end) = -1;
  plot(smooth(x, 201, 'lowess'), 'r')
  
end
