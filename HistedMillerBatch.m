% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                                                              %
%                 Histed & Miller (2006) Batch Simulation Driver               %
%                                                                              %
%   This function simulates  multiple trials of the Histed and Miller (2006)   %
%   paradigm and  then  passes the  results of  those trials  to a  function   %
%   called  "HistedMillerBatchAnalysis"  which  analyzes  data and  produces   %
%   figures similar to those found in the paper.                               %
%                                                                              %
%   The user may specify simulation properties with the arguments:             %
%                                                                              %
%     /===========================================================\            %
%     | Property Name     | Description                           |            %
%     +-------------------+---------------------------------------+            %
%     | StimLocations     | A vector whose elements correspond to |            %
%     |                   | the electrode locations to be used.   |            %
%     +-------------------+---------------------------------------+            %
%     | CuePairs          | A vector whose elements correspond to |            %
%     |                   | the pairs of cues that should be      |            %
%     |                   | simulated.  Possible values for this  |            %
%     |                   | vector are [1..6] with each of these  |            %
%     |                   | values representing one of the pairs  |            %
%     |                   | of cues used in the paper.  For       |            %
%     |                   | example, if CuePairs is set to 5 then |            %
%     |                   | only simulations with cues at the     |            %
%     |                   | locations 20 and 56 will occur.       |            %
%     +-------------------+---------------------------------------+            %
%     | Soas              | A vector with elements corresponding  |            %
%     |                   | to stimulus onset asynchronies (SOAs) |            %
%     |                   | to be simulated.                      |            %
%     +-------------------+---------------------------------------+            %
%     | Stimulation       | A vector that specifies the possible  |            %
%     |                   | values for the variable stimPresent;  |            %
%     |                   | a value of 1 means that stimulation is|            %
%     |                   | applied on a trial and a value of 0   |            %
%     |                   | means that it is not present.         |            %
%     +-------------------+---------------------------------------+            %
%     | NumRepeats        | A scalar that specifies the number of |            %
%     |                   | times each combination of the above   |            %
%     |                   | simulation parameters should be run.  |            %
%     +-------------------+---------------------------------------+            %
%     | Verbose           | Toggles verbose and quiet command-line|            %
%     |                   | output modes.                         |            %
%     +-------------------+---------------------------------------+            %
%     | ProgressBar       | Toggles the appearance of a graphical |            %
%     |                   | progress bar to track simulations.    |            %
%     \===========================================================/            %
%                                                                              %
%                                                                              %
%   A typical example of a call to this function is:                           %
%                                                                              %
%     [analysisData simResults] =                                ...           %
%          HistedMillerBatch('StimLocations', 21,                ...           %
%                            'CuePairs',      [5 6],             ...           %
%                            'NumRepeats',    20,                ...           %
%                            'Verbose',       1,                 ...           %
%                            'ProgressBar',   1);                              %
%                                                                              %
%   The simulations often take very long (i.e. sometimes days).   Be sure to   %
%   prepare for a long simulation,  and definitely consider taking advantage   %
%   of the progress bar.                                                       %
%                                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function [analysisData simResults] = HistedMillerBatch(varargin)

  % Add directories containing helper functions to MATLAB's execution path
  addpath tools tools/signalFunctions

  %% Initial Values of Parameters and Simulation Controllers
  %
  %  Parameters that govern the timing of simulations, the structure and
  %  function of the network and the data analysis.  Once default values 
  %  are specified, several optional parameters are defined.
  %
  
  % Describe timing information
  step                 = 0.0001;            % Step size
  duration             = 3.0;               % Simulation duration
  beginCue             = 0.5;               % Onset time of first cue
  stimInterval         = 0.9;               % Duration of stimulation
  soas                 = [-0.20,    ...     % All possible SOAs
                          -0.13,    ...
                          -0.06,    ...
                           0.00,    ...
                           0.06,    ...
                           0.13,    ...
                           0.20];
  
  % Describe the shape of the network
  fieldSize            = [9,  9];           % Size of stimulus array
  cuePairs             = [26, 14;  ...      % Possible pairs of cues
                          62, 26;  ...
                          68, 62;  ...
                          68, 56;  ...
                          56, 20;  ...
                          20, 14];  
  
  % Variables used to control simulations
  iterateStimLocations = 1:prod(fieldSize); % Stim locations to use
  iterateCuePairs      = 1:size(cuePairs,1);% Cue pairs to use
  iterateSoas          = soas;              % SOAs to use
  iterateStimulation   = [0 1];             % Stim values to use
  numRepeatSims        = 20;                % Number of sim iterations
  verbose              = 0;                 % Verbosity of simulation
  useWaitBar           = 0;                 % Use progress bar or not
  
  % Simulation defaults
  kernelSize           = max(fieldSize)*3;  % Size of Gaussian kernel
  stimSpread           = 3;                 % Breadth of Gaussian

  
  %% Override Initial Values with User-Defined Values
  %
  %  The parameter values defined above are default values.  HMbatch
  %  takes a variable number of arguments which can specify user-defined
  %  values.
  %
  
  for arg = 1:2:nargin    
      switch varargin{arg}
          case 'StimLocations'
              if ~strcmp(varargin{arg+1},'all')
                  iterateStimLocations = varargin{arg+1};
              end
          case 'CuePairs'
              if ~strcmp(varargin{arg+1},'all')
                  iterateCuePairs      = varargin{arg+1};
              end
          case 'Soas'
              if ~strcmp(varargin{arg+1},'all')
                  iterateSoas          = varargin{arg+1};
              end
          case 'Stimulation'
              if ~strcmp(varargin{arg+1},'all')
                  iterateStimulation   = varargin{arg+1};
              end
          case 'NumRepeats'
              numRepeatSims            = varargin{arg+1};
          case 'Verbose'
              verbose                  = varargin{arg+1};
          case 'ProgressBar'
              useWaitBar               = varargin{arg+1};
      end
  end

  
  %% Prepare to Begin Simulation
  %
  %  Now that all parameters are fully specified, initialize the
  %  progress bar and prepare to count simulations.
  %
  
  if(useWaitBar)
    waitbarhandle = waitbar(0,  'Initializing Waitbar...');
  end
  
  % Tools for counting simulations
  numSims              = 1;
  numTotalSims         = length(iterateStimLocations) * ...
                         length(iterateCuePairs) *      ...
                         length(iterateSoas) *          ...
                         length(iterateStimulation) *   ...
                         numRepeatSims;
  
  % Variable to store simulation results
  simResults           = {};
  
  
  
  %% Begin Simulation: Iterate Through Trial Types
  %    
  %  Begin the simulation itself.  Most of this code deals with iterating
  %  through the various conditions so that all of the desired trial 
  %  types occur.
  %
          
  % Iterate through stimulation locations
  for stimLocation = iterateStimLocations
    
      if verbose display(stimLocation); end
      
      % For each stimulation location,
      % iterate through cue pairs
      for cuePair = iterateCuePairs
          if verbose display(cuePairs(cuePair, :)); end
          
          cueLocations = [41 cuePairs(cuePair, :)];
          
          % For each stimulation location and cue pair, 
          % iterate through the SOAs
          for soa = iterateSoas
              if verbose display(soa); end
              
              if soa > 0
                cueOn        = [0 beginCue     beginCue+soa];
              else
                cueOn        = [0 beginCue-soa beginCue];
              end
                
              cueOff       = [2.0 1.0 1.0];
              cueStrength  = [1   1   1];
              
              % For each stimulation lcoation, cue pair, and SOA,
              % iterate through control and stimulation trials   
              for stimPresent = iterateStimulation
                 
                  % For each stimulation location, cue pair, SOA and the
                  % status of stimulation, repeat the trial as many times
                  % as is specified by numRepeatSims.
                  for i = 1:numRepeatSims
                    
                    % Update the progress bar
                    if(useWaitBar)
                      waitbar((numSims-1)/numTotalSims,               ...
                              waitbarhandle,                          ...
                              ['Running simulation ' num2str(numSims) ...
                               ' of ' num2str(numTotalSims)])
                    end
                    
                    disp(['Running H&M Trial (Simulation ' ...
                         num2str(numSims) ' of ' num2str(numTotalSims)  ')'])
                    disp('**********************************************************')
                    [fields data sacTimes sacTargs] = simulateTrial(  ...
                              'Step',         step,                   ...
                              'Duration',     duration,               ...
                              'CueLocations', cueLocations,           ...
                              'CueOnTimes',   cueOn,                  ...
                              'CueOffTimes',  cueOff,                 ...
                              'StimOnTime',   1.0,                    ...
                              'StimOffTime',  1.9,                    ...
                              'StimStrength', stimPresent*.4,         ...
                              'StimLocation', stimLocation);
                                        
                    disp(' ')
                    
                    % Update the simulation count
                    numSims = numSims + 1;
                    
                    % Save the information...
                    simResults = { simResults{:}                          ...
                                   {struct('sacTimes',     sacTimes,      ...
                                           'sacTargs',     sacTargs);     ...
                                    struct('stimLocation', stimLocation,  ...
                                           'cuePair',      cuePair,       ...
                                           'soa',          soa,           ...
                                           'stimPresent',  stimPresent)}
                                 };
                    

                  end
              end
          end
      end
  end
  

   
  %% Data Analysis, Using HistedMillerBatchAnalysis.m
  %
  %  The data analysis is involved, so it's placed in a separate file called
  %  HistedMillerBatchAnalysis.m that accepts the simulation results along with 
  %  some basic information about the trial types used in the simulation.
  %
  
  % Since these simulations tend to take so long, save a backup of the 
  % results to disk.  This ought to be toggled by the user, or at least have
  % a filename with a time stamp!
  save('results/backupData.mat', 'simResults');
  
  % Provide the user with some information about running the analysis again at a 
  % later time, since simulations take so long that running the simulation again
  % just to get the analysis is not feasible.
  display('To run analysis again enter:');
  fprintf(['analysisData = HistedMillerBatchAnalysis(simResults, ...\n' ...
           '[' num2str(iterateStimLocations) '], ...\n'                 ...
           '[' num2str(iterateCuePairs)      '], ...\n'                 ...
           '[26, 14; 62, 26; 68, 62; 68, 56; 56, 20; 20, 14], ...\n'    ...
           '[' num2str(iterateSoas)          '], ...\n'                 ...
           '[' fieldSize                     '], ...\n'                 ...
            num2str(step)                     ', ...\n'                 ...
            num2str(verbose)                  ');\n']);

  
  % Run the analysis.
  analysisData = HistedMillerBatchAnalysis(simResults,               ...
					   iterateStimLocations,     ...
					   iterateCuePairs,          ...
					   cuePairs,                 ...
					   iterateSoas,              ...
					   fieldSize,                ...
					   step,                     ...
					   verbose);

  if (useWaitBar)
    close(waitbarhandle)
  end
  
end

