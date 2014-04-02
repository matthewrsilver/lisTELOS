function analysisData = HistedMillerBatchAnalysis(simResults,            ...
                                        possibleStimLocations, ...
                                        possibleCuePairs,      ...
                                        cuePairs,              ...
                                        possibleSoas,          ...
                                        fieldSize,             ...
                                        step,                  ...
                                        verbose)
  
  % Create variables to hold the analysis data.
  analysisData         = 0;
  controlLatencies     = [];
  controlSoas          = [];
  stimulationLatencies = [];
  stimulationSoas      = [];
  stimulationLocations = [];
  
  stimulationLatenciesByLocation = [];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                              %
  %          CREATE A CELL ARRAY TO HOLD SORTED RESULTS          %
  %                                                              %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % If verbose, print status message
  if verbose
    disp('Creating array to hold sorted results...')
  end
  
  % Make a cell array to contain the results during sorting.  The
  % cell array should look like this:
  
  %      |------- n = length(possibleStimLocations) -------| 
  % 
  %           1           2           3               n
  %      {   [ ]   } {   [ ]   } {   [ ]   } ... {   [ ]   }
  %
  sortedResults = cell(1, length(possibleStimLocations));
  
  for k = 1:length(sortedResults)
    
    % Each cell in the cell array created above needs to include
    % its own cell array which is the length of the possible cue
    % pairs that were tested for each stimulation location.
    % Following the same numbering convention as above, the cell
    % array should now look like this:  
    
    %         |------- n = length(possibleStimLocations) -------| 
    %        
    %             1           2           3               n
    %  ---  1 { { [ ] } } { { [ ] } } { { [ ] } } ... { { [ ] } }
    %   |    
    %   |   2   { [ ] }     { [ ] }     { [ ] }         { [ ] }
    %   |                                      
    %       3   { [ ] }     { [ ] }     { [ ] }         { [ ] }
    %   m                                                     
    %       4   { [ ] }     { [ ] }     { [ ] }         { [ ] }
    %   |                                                     
    %   |          :           :           :               :   
    %   |                                                     
    %  ---  m   { [ ] }     { [ ] }     { [ ] }         { [ ] }
    
    % where m = length(possibleCuePairs)
    
    
    sortedResults{k} = cell(1, length(possibleCuePairs));
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                              %
  %        POPULATE THIS CELL ARRAY WITH SORTED RESULTS          %
  %                                                              %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % If verbose, print status message
  if verbose
    disp('Sorting results...')
  end
  
  % First, reorganize all blocks of data so that data from the same
  % stimulation sites are together.  The variable whichSim iterates
  % through each simulation.  The number of total simulations can
  % be obtained by the statement "size(simResults,2)"
  for whichSim = 1:size(simResults, 2)
    
    % The following statements extract the stimulation location
    % and cue pair from the present simulation and then find the
    % indices of those values in the matrices "possibleCuePairs"
    % and "possibleStimLocations" by using the == operator.  
    currentLocation = possibleStimLocations == simResults{whichSim}{2}.stimLocation;
    currentPair     = possibleCuePairs      == simResults{whichSim}{2}.cuePair;
    
    % Once the stimulation location and cue pair of the present
    % simulation have been identified, the present simulation can
    % be positioned within the cell array sortedResults.
    
    % The following if statement checks to see if a simulation
    % with the aforementioned characteristics has already been
    % placed within sortedResults:
    
    if isempty(sortedResults{currentLocation}{currentPair})
      
      % If this is the first simulation of its kind, then the
      % results can simply be placed in the appropriate cell.
      sortedResults{currentLocation}{currentPair} = {simResults{whichSim}};       
    else
      
      % If other simulations of this kind of already been added
      % to sortedResults, then the present simulation must be
      % appended to the cell array which contains simulations
      % of this kind:
      sortedResults{currentLocation}{currentPair} = {sortedResults{currentLocation}{currentPair}{:} simResults{whichSim}};
    end
    
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                                                              %
  %      ANALYZE THE RESULTS NOW THAT THEY HAVE BEEN SORTED      %
  %                                                              %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % If verbose, print status message
  if verbose
    disp('Analyzing Results...')
  end
  
  % At this point, the cell array sortedResults contains all of the
  % simulation data with all simulations sharing the same stimulation
  % site and cue pair grouped into cell arrays.  Thus, each one of
  % these cell arrays, appearing in the n x m array shown in the
  % comment above wherever there are square brackets ( "[ ]" ),
  % contains data from each of the simulated SOAs that share all other
  % characteristics. In order to print a bias chart - as shown in 
  % Histed and Miller (2006), Figure 3 - one of these cell arrays is
  % necessary and sufficient.  These charts plot the probability of an
  % initial ipsiversive saccade against SOA for a single stimulation
  % location and cue pair.
  
  % To produce a single bias chart, one of these cell arrays bust
  % be grabbed and then pushed through analysis.  Each bias chart then
  % provides a single "bias" which is used to describe the effect of
  % stimulation at a specific location on eye movements for a specific
  % cue pair.  Since biases can be calculated as each bias chart is
  % produced, a veriable to hold all of these biases should be created now:
  
  storeAllBiases = zeros([fieldSize length(possibleCuePairs)]);
  errorCount     = 0;
  
  % To visit each of the cell arrays containing bais chart
  % information, iterate through the top level of sortedResults.  
  for chartStimLocation = 1:size(sortedResults,2)
    
    thisLocationControlLatency     = [];
    thisLocationControlSoa         = [];
    thisLocationStimulationLatency = [];
    thisLocationStimulationSoa     = [];
    
    % For each stimulation location, iterate through each of the
    % cue pairs. 
    for chartCuePair = 1:size(sortedResults{chartStimLocation},2)
      
      % Create a cell array which contains all of the trials
      % that should go into a single bias chart:
      trialInfo = sortedResults{chartStimLocation}{chartCuePair};
      
      % Create arrays to store representations of the number of
      % control and stimulation trials in which the ipsilateral
      % target was visited first.  The first column represents
      % the number of "ipsi-first" trials and the second column
      % represents the number of total trials:
      %
      %      SOAs  |    "ipsi-first"   total
      %            |
      %     -0.20  |       [ 1 ]       [10]
      %     -0.13  |       [ 2 ]       [10]
      %     -0.06  |       [ 4 ]       [10]
      %      0.00  |       [ 5 ]       [10]
      %      0.06  |       [ 6 ]       [10]
      %      0.13  |       [ 8 ]       [10]
      %      0.20  |       [ 9 ]       [10]
      
      stimTrials     = zeros(length(possibleSoas),2);
      controls       = zeros(length(possibleSoas),2);
      
      % Iterate through each of the trials to be included in
      % the present bias chart, stored in the cell array
      % called "trialInfo"
      for whichTrial = 1:size(trialInfo,2)
        
        
        % First, remove fixation saccades:
        SaccadeTargets = trialInfo{whichTrial}{1}.sacTargs(trialInfo{whichTrial}{1}.sacTargs ~= 41);
        SaccadeTimes   = trialInfo{whichTrial}{1}.sacTimes(trialInfo{whichTrial}{1}.sacTargs ~= 41);
        
        % if no saccades occurred, skip to the next trial...
        if length(SaccadeTargets) ~= 2
          
          disp(['******* Error: Number of saccades ('                   ...
                num2str(SaccadeTargets(:)')                             ...
                ') is invalid. Trial skipped (SOA = '                   ...
                num2str(trialInfo{whichTrial}{2}.soa) '. *******']);
          
          errorCount = errorCount+1;
          continue;
        else
        
          % Extract the saccade destinations for the current trial
          theCues   = cuePairs(trialInfo{whichTrial}{2}.cuePair,:);
          
          % Compare the FIRST destination with the most ipsilateral
          % destination... if they're the same then set ipsiFirst to 1,
          % otherwise set to zero.  Also, if there were no saccades, set to
          % zero.
          ipsiFirst = (theCues(1) == SaccadeTargets(1));
        
          % Extract the saccade times for the current trial
          %theTimes  = trialInfo{whichTrial}{1}.sacTimes;
          
        end
          
        
        % Now that the the direction of the first saccade has
        % been determined, and it is known whether or not
        % there was stimulation on this trial, we can update
        % the variables "stimTrials" and "controls" accordingly.
        % To do so, first establish whether the current trial
        % is a "control" trial (no stimulation) or a
        % stimulation trial:
        
        if trialInfo{whichTrial}{2}.stimPresent == 0
          
          % This is a control trial; update the variable
          % "controls."  The row in "controls" which
          % corresponds to the current trial's SOA needs to
          % be updated in two ways:
          
          % (1) increment the value of the second column.
          % This reflects the fact that that the direction 
          % of the first saccade has been measured for 
          % another trial.
          controls(trialInfo{whichTrial}{2}.soa == possibleSoas,2) = controls(trialInfo{whichTrial}{2}.soa == possibleSoas,2) + 1;
          
          % (2) if the ipsilateral target was visited
          % first, update the first column, which indicates
          % that another ipsi-first trial has occured.
          if ipsiFirst
            controls(trialInfo{whichTrial}{2}.soa == possibleSoas,1) = controls(trialInfo{whichTrial}{2}.soa == possibleSoas,1) + 1;
          end
          
          % Now store the latency information
          thisLocationControlLatency = [thisLocationControlLatency SaccadeTimes(1)];
          thisLocationControlSoa     = [thisLocationControlSoa     trialInfo{whichTrial}{2}.soa];
          
        else
          
          % This is a stimulation trial; update the
          % variable "stimTrials" in the same ways as
          % above:
          
          % (1) increment the value of the second column.
          stimTrials(trialInfo{whichTrial}{2}.soa == possibleSoas,2) = stimTrials(trialInfo{whichTrial}{2}.soa == possibleSoas,2) + 1;
          
          % (2) if "ipsi-first", increment first column.
          if ipsiFirst                                
            stimTrials(trialInfo{whichTrial}{2}.soa == possibleSoas,1) = stimTrials(trialInfo{whichTrial}{2}.soa == possibleSoas,1) + 1;
          end
          
          % Now store the latency information
          thisLocationStimulationLatency = [thisLocationStimulationLatency SaccadeTimes(1)];
          thisLocationStimulationSoa     = [thisLocationStimulationSoa     trialInfo{whichTrial}{2}.soa];
          
        end
        
        % End of processing for the current trial, move to
        % the next trial, continuing to update the values of
        % "control" and "stimtrials"
        
      end
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %                                                              %
      %                COMPUTE LINEAR REGRESSION LINES               %
      %                                                              %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      % If verbose, print status message
      if verbose
        disp('Computing regression lines...')
      end
      
      % For the current cue pair and stimulation location:
      
      % Compute the probability of an initial ipsilateral
      % saccade for all SOAs for both control and stimulation
      % trials.
      controlProbs   = controls(:,1)./controls(:,2);
      stimTrialProbs = stimTrials(:,1)./stimTrials(:,2);
      
      % Clean things up a bit... values of 0 and 1 get
      % messy...but I can't remember why since I did this part
      % of the code a long time ago
      controlProbs(controlProbs == 0) = .001;
      controlProbs(controlProbs == 1) = .999;
      stimTrialProbs(stimTrialProbs == 0) = .001;
      stimTrialProbs(stimTrialProbs == 1) = .999;
      
      % First, create the linear regulation line for the control trials.
      % Establish that this is a control trial by setting stimOn = 0
      % Compute using the method described on page 834 of Histed and 
      % Miller (2006)
      stimOn           = 0;
      p                = log(controlProbs./(1-controlProbs));
      d                = zeros(length(controlProbs), 3);
      d(:,1)           = 1;
      d(:,3)           = possibleSoas;
      d(:,2)           = stimOn;
      beta             = pinv(d)*p;
      controlRegLine   = linregHM(beta, [possibleSoas(1):.01:possibleSoas(end) stimOn]');
      controlChanceSOA = -(beta(1) + beta(2)*stimOn - (.5/(1-.5)))/beta(3);
      
      % Second, create the linear regression line for the stimulation
      % trials.  Establish a stimulation trial by setting stimOn = 1
      stimOn           = 1;
      p                = log(stimTrialProbs./(1-stimTrialProbs));
      d                = zeros(length(stimTrialProbs), 3);
      d(:,1)           = 1;
      d(:,3)           = possibleSoas;
      d(:,2)           = stimOn;
      beta             = pinv(d)*p;
      stimRegLine      = linregHM(beta, [possibleSoas(1):.01:possibleSoas(end) stimOn]');
      stimChanceSOA    = -(beta(1) + beta(2)*stimOn - (.5/(1-.5)))/beta(3);

      % Now that the SOA at which change performance occurs has been
      % determined, we can solve for the bias introduced by stimulation:
      bias             = stimChanceSOA - controlChanceSOA;
      
      % For the current cue pair and stimulation location, store the bias.
      storeAllBiases(trialInfo{whichTrial}{2}.stimLocation + prod(fieldSize)*(chartCuePair-1)) = bias;
      
      % Generate a plot with the current bias chart.
      hndl = figure('Visible', 'off');
      hold on
      
      plot(possibleSoas(1):.01:possibleSoas(end), controlRegLine, 'b', 'LineWidth', 3)
      plot(possibleSoas(1):.01:possibleSoas(end), stimRegLine,    'r', 'LineWidth', 3)
      
      legend('Control', 'Stimulation', 'Location', 'SouthEast')
      
      scatter(possibleSoas, controlProbs,   'bo', 'filled', 'LineWidth', 2, 'MarkerEdgeColor', 'b')
      scatter(possibleSoas, stimTrialProbs, 'ro', 'filled', 'LineWidth', 2, 'MarkerEdgeColor', 'r')
      
      ylabel('Fraction of responses to ipsilateral target first')
      xlabel('Cue SOA (ms)')
      
      title(['Electrode Position = ' num2str(trialInfo{whichTrial}{2}.stimLocation) '; Cues = ' num2str(cuePairs(trialInfo{whichTrial}{2}.cuePair,:))])   
      
      saveas(hndl, ['pos' num2str(trialInfo{whichTrial}{2}.stimLocation) '_cue' num2str(trialInfo{whichTrial}{2}.cuePair) '.eps'], 'epsc2')
      
    end
    
    % Analysis for a single stimulation location is completed here.
    stimulationLatenciesByLocation = [stimulationLatenciesByLocation mean(thisLocationStimulationLatency)];
    
    controlLatencies     = [controlLatencies     thisLocationControlLatency];
    controlSoas          = [controlSoas          thisLocationControlSoa];
    stimulationLatencies = [stimulationLatencies thisLocationStimulationLatency];
    stimulationSoas      = [stimulationSoas      thisLocationStimulationSoa];
    stimulationLocations = [stimulationLocations ones(size(thisLocationStimulationLatency))*trialInfo{whichTrial}{2}.stimLocation];
    
    
  end
 
  % Plot the latencies for control and stimulation trials
  
  figure
  subplot(1,2,1)
  hist(100*(controlLatencies-20), [200:.1:500])
  %axis([100 200 0 60])
  ylabel('Control')
  
  subplot(1,2,2)
  hist(100*(stimulationLatencies-20), [200:.1:500])
  %line(repmat(100*(stimulationLatenciesByLocation-20), 2, 1), [0 20])
  %axis([100 200 0 60])
  ylabel('Stimulation')
    
  % Now generate a set of figures, each corresponding to a cue
  % pair. Each figure shows the bias associated with stimulation at
  % all tested locations.  To generate a nice looking figure here,
  % use a lot of stimulation locations (perhaps all, or every
  % other).
  
  % Uncomment to use. These figures require a ton of simulations.
  
  %for biasChartNumber = 1:length(possibleCuePairs)
  %  figure
  %  imagesc(min(1000*(storeAllBiases(:,:,biasChartNumber)-2),200));
  %  axis image
  %  colorbar
  %end
  
  analysisData = storeAllBiases;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % This is the end of the analysis.... if for some 
  % reason there's no data, set analysisData to -1. 
  if isempty(analysisData)
    analysisData = -1;
  end
  
end

function yhat = linregHM(beta, X)

  Tsoa = X(1:end-1,1);
  Dstim = X(end,1);
  y = beta(1) + beta(2)*Dstim + beta(3).*Tsoa;
  yhat = exp(y)./(1 + exp(y));  
end

