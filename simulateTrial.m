%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                   Simulate a trial with the lisTELOS model                   %
%                                                                              %
%                                                                              %
%  This function runs a single trial (by default of the immediate              %
%  serial recall task) through the lisTELOS model.  Usage:                     %
%                                                                              %
%    >> [fields data sacTimes sacTargs] = simulateTrial([options]);            %
%                                                                              %
%  The user may specify simulation properties with the optional arguments:     %
%                                                                              %
%     /===========================================================\            %
%     | Property Name     | Description                           |            %
%     +===================+=======================================+            %
%     | Step              | Step size (fixed) used by ODE solver. |            %
%     +-------------------+---------------------------------------+            %
%     | Duration          | Duration of trial, in seconds.        |            %
%     +-------------------+---------------------------------------+            %
%     | Verbose           | Toggle messages to command line.      |            %
%     +-------------------+---------------------------------------+            %
%     | CountCells        | Number of counting cells in the       |            %
%     |                   | model; should always be greater than  |            %
%     |                   | or equal to the number of stimuli     |            %
%     |                   | being presented, including the        |            %
%     |                   | fixation point.                       |            %
%     +-------------------+---------------------------------------+            %
%     | FieldSize         | The size [x y] of each of the fields  |            %
%     |                   | in the model, in terms of number of   |            %
%     |                   | cells.                                |            %
%     +-------------------+---------------------------------------+            %
%     | UseWM             | Toggle the use of working memory.     |            %
%     |                   | When useWM is set to 0, cells in the  |            %
%     |                   | model working memory can not be       |            %
%     |                   | excited (see Silver et Al., 2011).    |            %
%     |                   | Eliminating working memory allows for |            %
%     |                   | more accurate simulation of simple    |            %
%     |                   | visuomotor tasks that are unlikely    |            %
%     |                   | to recruit memory cells.              |            %
%     +-------------------+---------------------------------------+            %
%     | UseDelay          | Toggle the presence of a delay that   |            %
%     |                   | alters the time that visual stimuli   |            %
%     |                   | are presented to the system.  This    |            %
%     |                   | delay corresponds to the visual       |            %
%     |                   | response latency of parietal areas,   |            %
%     |                   | which comprise the earliest stages    |            %
%     |                   | of the model. The delay represents    |            %
%     |                   | early visual processing.              |            %
%     +-------------------+---------------------------------------+            %
%     | FixLocation       | Set the position within the field     |            %
%     |                   | corresponding to the fixation point.  |            %
%     +-------------------+---------------------------------------+            %
%     | CueLocations      | The locations of all of the visual    |            %
%     |                   | cues that will be presented during    |            %
%     |                   | the simulation.  Each cue location    |            %
%     |                   | should be provided as a single scalar |            %
%     |                   | corresponding to the index of a cell  |            %
%     |                   | if the field is viewed as a vector.   |            %
%     |                   |                                       |            %
%     |                   | In a field with size [9 9] the values |            %
%     |                   | range from 1 - 81.  An example of     |            %
%     |                   | CueLocations is [41 38 14 38] which   |            %
%     |                   | specifies four locations.             |            %
%     +-------------------+---------------------------------------+            %
%     | CueOnTimes        | The time from the beginning of the    |            %
%     |                   | simulation (seconds) at which each    |            %
%     |                   | cue in CueLocations is presented.     |            %
%     |                   | A vector of the same length as        |            %
%     |                   | CueLocations should be used.  For     |            %
%     |                   | example: [0 1 3 5]                    |            %
%     +-------------------+---------------------------------------+            %
%     | CueOffTimes       | The time from the beginning of the    |            %
%     |                   | simulation (seconds) at which each    |            %
%     |                   | cue in CueLocations is presented.     |            %
%     +-------------------+---------------------------------------+            %
%     | StimLocation      | The position of the stimulation site. |            %
%     |                   | The Gaussian used to model the effect |            %
%     |                   | of microstimulation is centered here. |            %
%     +-------------------+---------------------------------------+            %
%     | StimOnTime        | The time from the beginning of the    |            %
%     |                   | simulation (seconds) at which         |            %
%     |                   | stimulation begins.                   |            %
%     +-------------------+---------------------------------------+            %
%     | StimOffTime       | The time from the beginning of the    |            %
%     |                   | simulation (seconds) at which         |            %
%     |                   | stimulation ends.                     |            %
%     +-------------------+---------------------------------------+            %
%     | StimSpread        | The standard deviation of the         |            %
%     |                   | Gaussian used to model stimulation.   |            %
%     +-------------------+---------------------------------------+            %
%     | StimStrength      | The strength of microstimulation,     |            %
%     |                   | or the scale of the Gaussian.         |            %
%     \===========================================================/            %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [fields data sacTimes sacTargs] = simulateTrial(varargin)

  % Add directories containing helper functions to MATLAB's execution path
  addpath tools tools/signalFunctions

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Describe default values that drive the simulation
  %
  
  % Default values describing the simulation itself:
  step           = 0.0001;             % step size (s)
  duration       = 2;                  % duration of simulation (s)
  verbose        = 0;                  % control the verbosity of system output

  % Default model state variables
  eyePos         = 1;                  % position of eye updated throughout
  lastSac        = -1.00;              % time of last saccade (-1.00 for none)
  inSaccade      = 0;                  % used for evaluation of saccades
  
  % Default values describing the shape of the system:
  countCells     = 4;                  % number of counting cells
  fieldSize      = [9 9];              % the size of fields in the model
  fixLocation    = 41;                 % position of the fixation point
  useWM          = 1;                  % engage working memory?
  useDelay       = 1;                  % add delay for visual inputs?  

  % Default values describing the inputs to the system:
  cueLocations   = [41 38 14 38];      % positions of the cues
  cueOnTimes     = [ 0 .1 .3 .5];      % cue onsets (s*10)
  cueOffTimes    = [ 1 .2 .4 .6];      % cue offsets (s*10)
  cueStrengths   = [ 1  1  1  1];      % "salience" of cues
  inputDelay     = 0.5;                % ~visual response latency of PPC

  % Default values describing microstimulation:
  stimLocation   = 1;                  % position of the stimulating electrode 
  stimOnTime     = 0;                  % time microstimulation starts (s*10)
  stimOffTime    = 0;                  % time microstimulation ends (s*10)
  stimSpread     = 3;                  % the spread of the stimulation
  stimStrength   = 0.4;                % strength of microstimulation
  
  % Model parameters
  A              = 0.10;               % passive decay
  B              = 1.00;               % saturation constant
  threshSC       = 0.3;                % saccade threshold in SC
  
  % Create variables to store saccade times and targets
  sacTimes       = [];
  sacTargs       = [];
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Override default values with user-defined values
  %
  
  for arg = 1:2:nargin    
      switch varargin{arg}
          % Override simulation parameters
          case 'Step'
              step         = varargin{arg+1};
          case 'Duration'
              duration     = varargin{arg+1};
          case 'Verbose'
              verbose      = varargin{arg+1};
          
          % Override system shape parameters
          case 'CountCells'
              countCells   = varargin{arg+1};
          case 'FieldSize'
              fieldSize    = varargin{arg+1};
          case 'UseWM'
              useWM        = varargin{arg+1};
          case 'UseDelay'
              useDelay     = varargin{arg+1};
          case 'FixLocation'
              fixLocation  = varargin{arg+1};
              
          % Override input parameters    
          case 'CueLocations'
              cueLocations = varargin{arg+1};
          case 'CueOnTimes'
              cueOnTimes   = varargin{arg+1};
          case 'CueOffTimes'
              cueOffTimes  = varargin{arg+1};
              
          % Override stimulation parameters    
          case 'StimLocation'
              stimLocation = varargin{arg+1};
          case 'StimOnTime'
              stimOnTime   = varargin{arg+1};
          case 'StimOffTime'
              stimOffTime  = varargin{arg+1};
          case 'StimSpread'
              stimSpread   = varargin{arg+1};
          case 'StimStrength'
              stimStrength = varargin{arg+1};         
              
      end
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % TEMPORARILY ADJUST ALL TIMING VALUES SUPPLIED
  %
  % This change allows users to specify stimulation timings in
  % seconds, rather than the extremely clumsy 100s-of-milliseconds
  % which is used within simulateTrial. Eventually, simulateTrial
  % itself should be changed so it uses a resonable unit, but for
  % now it's enough to correct input and output...
  
  step        = step*10;
  duration    = duration*10;
  cueOnTimes  = cueOnTimes*10;
  cueOffTimes = cueOffTimes*10;
  stimOnTime  = stimOnTime*10;
  stimOffTime = stimOffTime*10;
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Use default and user-defined values to generate certain important
  % other values and data structures for the system.
  %
  
  % Though fields are 2D, they're represented by vectors; must compute length
  fieldLength    = prod(fieldSize);  % the length of the vectorized field rep. 
  
  % Apply the delay to inputs, to account for early visual processing that 
  % occurs prior to the excitation of this model's early stages.  This is 
  %required to produce meaningful response latency and saccade latency data.
  if useDelay
    cueOnTimes     = cueOnTimes  + inputDelay;
    cueOffTimes    = cueOffTimes + inputDelay;
  end

  % Construct a representation of inputs through time
  Input = zeros((duration/step)+1, prod(fieldSize));
  for i = 1:length(cueLocations);
    Input(floor((cueOnTimes(i)/step)+1):floor((cueOffTimes(i)/step)+1), cueLocations(i)) = 1;
  end  
 
  % Construct a representation of stimulation through time
  kernelSize = max(fieldSize)*3;
      
  % First, use fspecial to create a nice Gaussian.  The convolution
  % kernel that I'm producing with fspecial is large so that the
  % kernel can be easily overlaid on SEF with its peak at any node in
  % SEF.  It is best to pick an odd number so that there is only one
  % maximum node.
  h           = fspecial('gaussian',kernelSize,stimSpread);
  h           = h/max(max(h));               % normalized gauss kern
  [c,r]       = max(h);                      % find info about max
  [nothing,c] = max(c);                      % c = the column of max
  r           = max(r);                      % r = the row of max
  
  % Select the inputSizeVertical x inputSizeHorizontal window around
  % the center of the Gaussian that places the center at the
  % appropriate stimulation site.
  kern = h( r - mod(stimLocation-1,fieldSize(1)):                   ...
            r - mod(stimLocation-1,fieldSize(1)) + fieldSize(1)-1,  ...
            c - floor((stimLocation-1)/fieldSize(2)):               ...
            c - floor((stimLocation-1)/fieldSize(2)) + fieldSize(2)-1 );
      
  kern = kern(:)*stimStrength;
  
  Stim = zeros(fieldLength, duration/step + 1);
  
  Stim(:, floor(stimOnTime/step)+1:floor(stimOffTime/step)+1)        ...
      = repmat(kern, 1, floor((stimOffTime-stimOnTime)/step)+1);
  
  % Now scale the stimulation according to stimStrength
  Stim = repmat(Stim, countCells, 1);
  


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Build transformation matrices:
  %
  
  % Weight matrix for collapsing rank reps into rank-independent reps
  F              = repmat(eye(fieldLength), 1, countCells);

  % Weight matrix (presumably LEARNED) so FP excites indirect pathway
  OnlyFP         = zeros(fieldLength);
  OnlyFP(:, fixLocation)          = 1;
  OnlyFP(fixLocation,fixLocation) = 0;
  
  % The (binary-valued) counting cell population
  PCi            = zeros(1,countCells);
  
  % Generate the three-dimensional transformation matrix which utilizes
  % eye position information (p) to map cue representations from
  % retinotopic to craniotopic coordinates.
  mapRtoC        = zeros(fieldLength,fieldLength,fieldLength);
  
  for p = 1:fieldLength
    diagDisp = fixLocation - p;
    mapRtoC(:, :, p) = diag(ones(1, fieldLength - abs(diagDisp)), diagDisp);
  end

  % Using the map from retinotopic to craniotopic coordinates, we can
  % generate an inverse mapping from craniotopic to retinotopic
  % coordinates
  mapCtoR(:, :, 1:fieldLength) = mapRtoC(:, :, fieldLength:-1:1); 
  
  % PPC output needs to be adjusted on the way to WM so that FP
  % representations don't get instated...
  noFP      = ones(fieldLength,1);
  noFP(fixLocation) = 0;
  noFP      = repmat(noFP, countCells, 1);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Describe the field sizes and initial values:
  %
  
  %     name                size             init
  %-----------------------------------------------
  
  % PPC
  fields.PXi     = [fieldLength               0];
  fields.PIi     = [fieldLength               0];
  fields.PYi     = [fieldLength               0];
  fields.PLi     = [fieldLength               0];
  
  % PFC
  fields.Mir     = [fieldLength*countCells    0];
  fields.MQir    = [fieldLength*countCells    0];

  % SEF
  fields.SXir    = [fieldLength*countCells    0];
  fields.SIir    = [fieldLength*countCells    0];
  fields.SYir    = [fieldLength*countCells    0];
  fields.ZDir    = [fieldLength*countCells    1];
  fields.ZAir    = [fieldLength*countCells    1];
  fields.SOi     = [fieldLength               0];
  
  % FEF
  fields.FPi     = [fieldLength               0];
  fields.FIi     = [fieldLength               0];
  fields.FOi     = [fieldLength               0];
  fields.FXi     = [fieldLength               0];
  
  % BG (These are equilibrium values)
  fields.MD      = [1                         -.58];
  fields.MI      = [1                         -.58];
  fields.MG      = [1                         0.428571428571429];
  fields.MN      = [1                          .4894];
  
  fields.BDi     = [fieldLength               -.58];
  fields.BIi     = [fieldLength               -.58];
  fields.BGi     = [fieldLength               0.428571428571429];
  fields.BNi     = [fieldLength               .4894];
  
  fields.GDi     = [fieldLength               -.58];
  fields.GIi     = [fieldLength               -.58];
  fields.GGi     = [fieldLength               0.428571428571429];
  fields.GNi     = [fieldLength               .4894];  
  
  % Rehearsal Gate
  fields.R       = [1                         1];
  
  % Thal
  fields.Ti      = [fieldLength               0];
  
  % SC
  fields.Ci      = [fieldLength               0];
  
  % Build a vector for initial activity
  initVals       = cell2mat(struct2cell(structfun(@(x) ones(x(1),1)*x(2), ...
                                        fields,                           ...
                                        'UniformOutput',                  ...
                                        false)));          
  
  % Iterate through the fields above and determine the start and end
  % values of the fields within the activity vector:
  names          = fieldnames(fields);
  cursor         = 0;
  
  for i = 1:size(names, 1)
    curName      = names(i);
    curValue     = getfield(fields, curName{:}); 
    fields       = setfield(fields, curName{:}, [curValue cursor+1 cursor+curValue(1)]);
    cursor       = cursor+curValue(1);
  end  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Run the simulation
  %  
  
  data = ode4(@dt, 0:step:duration, initVals);
  
  function dinf = dt(t, infs) 

    % update the counting cell population
    if any(t == cueOnTimes)
      
      % is the current cue the fixation point?
      presentCueIsFP = cueLocations(t == cueOnTimes) == fixLocation;
      
      if length(presentCueIsFP(presentCueIsFP == 1)) ~= 1
        
        % find the FIRST cue that matches.... this could be done differently...
        newRank      = find((t == cueOnTimes(cueLocations ~= 41)) == 1, 1);
        PCi          = zeros(1,countCells);
        PCi(newRank) = 1;
        
      end
      
    end
    
    % get the state of microstimulation for the current time step
    sigma = Stim(:,floor(t/step)+1);
    
    % get the state of the input for the current time step
    I     = Input(floor(t/step)+1,:)';
    
    % get the infinitesimal values for the fields at the current time step

    % PPC
    PXi   = infs(fields.PXi(3):fields.PXi(4));
    PIi   = infs(fields.PIi(3):fields.PIi(4));
    PYi   = infs(fields.PYi(3):fields.PYi(4));
    PLi   = infs(fields.PLi(3):fields.PLi(4));
    
    
    % PFC
    Mir   = infs(fields.Mir(3):fields.Mir(4));
    MQir  = infs(fields.MQir(3):fields.MQir(4));    
    
    % SEF
    SXir  = infs(fields.SXir(3):fields.SXir(4));
    SIir  = infs(fields.SIir(3):fields.SIir(4));
    SYir  = infs(fields.SYir(3):fields.SYir(4));
    ZDir  = infs(fields.ZDir(3):fields.ZDir(4));
    ZAir  = infs(fields.ZAir(3):fields.ZAir(4));
    SOi   = infs(fields.SOi(3):fields.SOi(4));
    
    % FEF
    FPi   = infs(fields.FPi(3):fields.FPi(4));
    FIi   = infs(fields.FIi(3):fields.FIi(4));
    FOi   = infs(fields.FOi(3):fields.FOi(4));
    FXi   = infs(fields.FXi(3):fields.FXi(4));
  
    % BG
    MD    = infs(fields.MD(3):fields.MD(4));
    MI    = infs(fields.MI(3):fields.MI(4));
    MG    = infs(fields.MG(3):fields.MG(4));
    MN    = infs(fields.MN(3):fields.MN(4));
    
    BDi   = infs(fields.BDi(3):fields.BDi(4));
    BIi   = infs(fields.BIi(3):fields.BIi(4));
    BGi   = infs(fields.BGi(3):fields.BGi(4));
    BNi   = infs(fields.BNi(3):fields.BNi(4));
    
    GDi   = infs(fields.GDi(3):fields.GDi(4));
    GIi   = infs(fields.GIi(3):fields.GIi(4));
    GGi   = infs(fields.GGi(3):fields.GGi(4));
    GNi   = infs(fields.GNi(3):fields.GNi(4));
    
    % Thalamus
    R     = infs(fields.R(3):fields.R(4));
    Ti    = infs(fields.Ti(3):fields.Ti(4));
    
    % SC
    Ci    = infs(fields.Ci(3):fields.Ci(4));
    
    % Rectify selection field nodes and wm nodes
    Mir   = max(0, Mir);
    SXir  = max(0, SXir);
    SIir  = max(0, SIir);
    SYir  = max(0, SYir);    
    
    
    % First, check to see if SC has met saccade requirements...
    if max(max(Ci)) > threshSC && t ~= lastSac && ~inSaccade

      % Get the position SC is driving towards
      saccadeTo = find(Ci>threshSC);
      if length(saccadeTo)>1
        disp('ERROR... multiple saccade targets:')
        saccadeTo
      end
      
      % remap saccadeTo so that it is a craniotopic value
      tempThing = zeros(fieldLength, 1);
      tempThing(saccadeTo(1)) = 1;
      newPos    = find(mapRtoC(:,:,eyePos)*tempThing == 1);
      
      
      % If that position is different from the present position
      if newPos ~= eyePos
        % We have a saccade!!
        initTime  = t;
        lastSac   = t;
        sacTimes  = [sacTimes t/10];
        sacTargs  = [sacTargs newPos]; 
        inSaccade = 1;
        eyePos    = newPos;
        disp(['Saccade initiated to ' num2str(eyePos) ...
              ' at t=' num2str(initTime/10) ' seconds.'])
        
        % Evaluate the saccade...
        if I(fixLocation)==1
          % If the fixation light is on
          if eyePos ~= fixLocation
            % And gaze is not directed to FP
            disp('Fixation broken.')
          else
            % And gaze is directed to FP
            disp('Correct acquisition of FP')
          end
          
        else
          
          % If the fixation point is not present and gaze is still directed at the FP
          if eyePos == fixLocation
            disp('Still fixating unnecessarily')
          end
        end
      end
      
    else
      if max(max(Ci)) < threshSC
        inSaccade = 0;
      end
    end
    
    % Now that we know where the eyes are, adjust I based on eye position....
    I = mapCtoR(:,:,eyePos)*I;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                    POSTERIOR PARIETAL CORTEX                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
    % Posterior parietal cortex layer 1
    dPXi  = -PXi + (1 - PXi) .* I;
    dPXi  = dPXi*10;
    
    % Posterior parietal cortex interneurons
    dPIi  = -PIi + (1 - PIi) .* f1(PXi);
    dPIi  = dPIi*10;
    
    % Posterior parietal cortex layer 2
    dPYi    = -0.2*PYi + (1 - PYi) .* (20 * f1(PXi)) - 300 * PYi.*(PIi.^2);
    dPYi    = dPYi*10;
    
    % Lateral intraparietal cortex;
    dPLi  = -PLi + (1 - PLi) .* ( 4*f2(PYi) + f3(PLi) + 2*FOi ) - PLi.*(1 + 100*sumOverKnotI(max(0,PLi).^4) + 0.3*sumOverKnotI(FOi));
    dPLi  = dPLi*10;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                    PREFRONTAL WORKING MEMORY                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Noise Term
    N     = (randn(length(Mir), 1))*1;
    PPC   = zeros(size(Mir));
    PPC(:)= (mapRtoC(:,:,eyePos)*(noFP(1:fieldLength, :).*PYi))*PCi;
    
    % Motor Working Memory
    dMir  = - 0.1*Mir + (1 - Mir) .* (0.7*f4(Mir).*(1+N) + useWM*(2*f5(noFP.*PPC))) - Mir.*(0.4*sumOverKnotI(MQir) + 1000*f(SYir));
    
    % Motor Working Memory Interneurons
    dMQir = - 0.1*MQir + (1 - MQir) .* (0.2*Mir);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                       SEF SELECTION FIELD                         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Intermediate Selection Layer
    dSXir = -2*SXir + (1 - SXir) .* (0.9*f4(Mir)*R + 10*(f6(SYir).*ZAir) + sigma) - SXir.*f2(SIir);

    % Interneurons in Selection layer
    dSIir = -2*SIir + (1 - SIir) .* (2*sumOverKnotI(f7(SXir)) + sigma);
    dSIir = dSIir*10;
    
    % Selection Layer
    dSYir = -2*SYir + (1 - SYir) .* (25*(f6(SXir).*ZDir) + sigma) - 15*SYir.*f2(SIir);
    dSYir = dSYir*10;    
    
    % Descending Habituative Gate
    dZDir = 0.10*(1 - ZDir) - ZDir.*(f6(SXir) + 20*f6(SXir).^2);

    % Ascending Habituative Gate
    dZAir = 0.01*(1 - ZAir) - ZAir.*(f6(SYir) + 25*f6(SYir).^2);
    
    % Output Layer
    dSOi  = -SOi + (1 - SOi).*(10*F*f8(SYir) + sigma(1:fieldLength)).*(1 + 1.5*mapRtoC(:,:,eyePos)*f3(FPi)) - 0.6*SOi.*(sumOverKnotI(mapRtoC(:,:,eyePos)*f3(FPi)));
    dSOi  = dSOi*10;
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                          FEF OUTPUT FIELD                         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dFPi  = -2*FPi + (1 - FPi).*(20*(mapCtoR(:,:,eyePos)*g(SOi)) + PLi) - FPi.*(sumOverKnotI(mapCtoR(:,:,eyePos)*g(SOi)) + 5*FXi + 2*FIi);
    dFPi  = dFPi*10;
  
    dFIi  = -0.1*FIi + (1 - FIi).*(sumOverKnotI(f2(FPi)) + 0.8*sumOverKnotI(PLi));
    dFIi  = dFIi*10;
    
    dFOi  = -FOi + (1 - FOi).*(3*(FPi.*Ti)) - FOi.*(6*FXi);
    dFOi  = dFOi*10;
    
    dFXi  = -2*FXi + (1 - FXi).*(100*(max(0,Ci-threshSC)>0));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                         BG: WORKING MEMORY                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dMD   = (1 - MD).*50 - (MD+0.58); 
    
    dMI   = (1 - MI).*(5*sum(OnlyFP*max(0, PLi - 0.25))) - (MI + 0.58);
    
    dMG   = (1 - MG) *0.5 - (MG+1.0).*(0.2 + 0.8*max(0,MI));
    
    dMN   = (1 - MN) *100 - (MN+1.0).*(54*max(0,MD) + 80*max(0,MG));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                           BG: FEF OUTPUT                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dBDi  = (1 - BDi).*(3*PLi + 20*FPi) - (BDi + 0.58).*(1 + 9*(sum(FPi)) );
    
    dBIi  =    - (BIi+.58);
    
    dBGi  = (1 - BGi)*0.5 - (BGi + 1.0).*(0.2 + 0.8*max(0,BIi));
    
    dBNi  = (1 - BNi)*100 - (BNi + 1.0).*(54*max(0,BDi) + 80*max(0,BGi));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                            BG: SC OUTPUT                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    GDi_excitatory  = 50*max(0,PLi - 0.25) + 100*f10(FOi);
    GDi_inhibitory  = 1 + 20*(sum(max(0,PLi-0.25)) + sum(f10(FOi)))*ones(size(GDi));
    
    dGDi = (1 - GDi).*GDi_excitatory - (GDi+0.58).*GDi_inhibitory; 
    
    dGIi = (1 - GIi).* (5*(OnlyFP*max(0, PLi - 0.25))) - (GIi + 0.58);
    
    dGGi = (1 - GGi) *0.50 - (GGi+1.0).*(0.2 + 0.8*max(0,GIi));
    
    dGNi = (1 - GNi) *100 - (GNi+1.0).*(54*max(0,GDi) + 80*max(0,GGi));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                                Thalamus                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dR    = -0.1*R + (1 - R).*(20*(max(0,.3-MN)>0));
    dR   = dR*20;
    
    dTi   = -0.1*Ti + (1 - Ti).*(10*(max(0,.3-BNi)>0));
    dTi   = dTi*15;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %                          Superior Colliculus                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dCi   = (1 - Ci).*(50*f7(PLi) + 40*f7(FOi)) - Ci.*(800*max(0, GNi - .3) + 10);
    
    % return the new values
    dinf  = [dPXi;  dPIi;  dPYi;  dPLi;               ...
             dMir;  dMQir;                            ...
             dSXir; dSIir; dSYir; dZDir; dZAir; dSOi; ...
             dFPi;  dFIi;  dFOi;  dFXi;               ...
             dMD;   dMI;   dMG;   dMN;                ...
             dBDi;  dBIi;  dBGi;  dBNi;               ...
             dGDi;  dGIi;  dGGi;  dGNi;               ...
             dR;    dTi;   dCi];
    
end


end

