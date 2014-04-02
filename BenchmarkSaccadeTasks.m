% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%                           Benchmark Saccade Tasks                            %
%                                                                              %
%   The function simulates four benchmark oculomotor tasks: the overlap task   %
%   saccade (gap 0) task,  gap 500 task,  and delayed saccade task.  Each of   %
%   these tasks  is described by Hikosaka, Sakamoto and Usui(1989), and as a   %
%   group  they  test a  number of different competencies  of the oculomotor   %
%   system.                                                                    %
%                                                                              %
%   That the model can simulate these tasks is important, but that the model   %
%   simulates  these tasks  with the appropriate  rank-ordering of  response   %
%   latencies is one of its key competencies.                                  %
%                                                                              %
%   This function takes  no arguments,  simply running each of the benchmark   %
%   tasks, printing simulation information, and returning saccade latencies.   %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function latencies = BenchmarkSaccadeTasks

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  % Initialize parameters for simulation  
  %
      
  % Add directories containing helper functions to MATLAB's execution path
  addpath tools tools/signalFunctions

  % Common task parameters
  duration     = 20;
  stepSize     = 0.001;
  cueLocations = [41 14];

  
  % Stimulation parameters set to have no effect
  stimLocation = 41;
  stimOnTime   = 20;
  stimOffTime  = 20;
  stimStrength = 0;
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % SACCADE (GAP 0) TASK
  %
  
  % Saccade task parameters
  useWM        = 0;
  cueOnTimes   = [0  5];
  cueOffTimes  = [5  10];
  
  % Run the task
  disp('Running the Saccade (Gap 0) Task (Simulation 1 of 4)')
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

  % Find the time at which eye position moved to the target location
  SaccadeTime    = sacTimes(sacTargets == cueLocations(2));
  
  % Compute the latency
  SaccadeLatency = (SaccadeTime - cueOffTimes(1))*100; 
  
  % Print latency
  disp(' ')
  disp(['Saccade Latency: ' num2str(SaccadeLatency) ' ms'])
  disp(' ')
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % OVERLAP TASK
  %
  
  % Overlap task parameters
  useWM        = 0;
  cueOnTimes   = [0  5];
  cueOffTimes  = [10 15];
  
  % Run the task
  disp('Running the Overlap Task (Simulation 2 of 4)')
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
  
  % Find the time at which eye position moved to the target location
  OverlapTime    = sacTimes(sacTargets == cueLocations(2));
  
  % Compute the latency
  OverlapLatency = (OverlapTime - cueOffTimes(1))*100; 

  % Print latency
  disp(' ')
  disp(['Saccade Latency: ' num2str(OverlapLatency) ' ms'])
  disp(' ')
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % GAP (GAP 500) TASK
  %
  
  % Gap task parameters
  useWM        = 0;
  cueOnTimes   = [0  10];
  cueOffTimes  = [5  15];
  
  % Run the task
  disp('Running the Gap 500 Task (Simulation 3 of 4)')
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
  
  % Find the time at which eye position moved to the target location
  GapTime    = sacTimes(sacTargets == cueLocations(2));
  
  % Compute the latency
  GapLatency = (GapTime - cueOnTimes(2))*100; 
  
  % Print latency
  disp(' ')
  disp(['Saccade Latency: ' num2str(GapLatency) ' ms'])
  disp(' ')
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % DELAYED SACCADE TASK
  %
  
  % Delayed saccade task parameters
  useWM        = 1;
  cueOnTimes   = [0  5];
  cueOffTimes  = [15 10];
  
  % Run the task
  disp('Running the Delayed Saccade Task (Simulation 4 of 4)')
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

  % Find the time at which eye position moved to the target location
  DelayedTime    = sacTimes(sacTargets == cueLocations(2));
  
  % Compute the latency
  DelayedLatency = (DelayedTime - cueOffTimes(1))*100; 
  
  % Print latency
  disp(' ')
  disp(['Saccade Latency: ' num2str(DelayedLatency) ' ms'])
  disp(' ')

  
  
  
  % Store the latencies so they can be returned 
  latencies = [SaccadeLatency OverlapLatency GapLatency DelayedLatency];
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % PLOT THE RESULTS
  %

  figure
  
  % Plot saccade task information
  subplot(4, 1, 2)
  baseEyePos = zeros(1, duration/stepSize);
  baseEyePos(round(SaccadeTime/stepSize):end) = .5;
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
  rectangle('Position', [5001 1 5000 .5], 'FaceColor', 'black')
  rectangle('Position', [1    2 5000 .5], 'FaceColor', 'black')
  title('Saccade (Gap 0) Task')
  
  % Plot overlap task information
  subplot(4, 1, 1)
  baseEyePos = zeros(1, duration/stepSize);
  baseEyePos(round(OverlapTime/stepSize):end) = .5;
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
  title('Overlap Task')
  
  % Plot gap task information
  subplot(4, 1, 3)
  baseEyePos = zeros(1, duration/stepSize);
  baseEyePos(round(GapTime/stepSize):end) = .5;
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
  rectangle('Position', [10001 1 5000 .5], 'FaceColor', 'black')
  rectangle('Position', [1    2  5000 .5], 'FaceColor', 'black')
  title('Gap 500 Task')
  
  % Plot delayed saccade task information
  subplot(4, 1, 4)
  baseEyePos = zeros(1, duration/stepSize);
  baseEyePos(round(DelayedTime/stepSize):end) = .5;
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
  rectangle('Position', [5001 1 5000  .5], 'FaceColor', 'black')
  rectangle('Position', [1    2 15000 .5], 'FaceColor', 'black')
  title('Delayed Saccade Task')

  % Add some labels to the figure
  text(    1, -.2, '0',    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
  text( 5001, -.2, '500',  'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
  text(10001, -.2, '1000', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
  text(15001, -.2, '1500', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
  text(20001, -.2, '2000', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
  text(10001, -1, 'time (ms)', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')

end
