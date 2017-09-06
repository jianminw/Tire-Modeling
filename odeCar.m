%CARNEGIE MELLON RACING
%Vehicle Dynamics Department
%The Differential Equation model for the racecar under accel
%Input: the current state of the car, and the time stamp
%Output: the state derivative
function yp = odeCar(t,y,parms)
    %Unpack the Parms
    wRad = parms.wRad; cdmass = parms.cdmass;
    %STATE LIST
    % y(1) = X position of the car
    % y(2) = X Velocity of the car
    % y(3) = rear wheel rpm 
    % y(4) = front wheel rpm 
    thistorque = activeTorqueFun(t,y,parms);
    accel = tracForceFun(y,thistorque,parms)/cdmass;

    yp = zeros(2,1);
    yp(1) = y(2); % change in position is equal to velocity
    yp(2) = accel; % change in velocity is = acceleration
    % accel = F/m, Force = tireFunction(current state, First pass is neglecting
    % aero, only considering tractive effects
end

%Helper Functions
%OUTPUT: the tractive force due to the tires
%INPUT: the state of the car and the torque
function force = tracForceFun(y,torque,parms)
    %Unpack the Parms
    wRad = parms.wRad;
    if torque == 0
        force = 0;
    else
        normF = rearNormF(y,torque,parms);
        sr = srfun(torque,normF,parms);
        force = normF*mufun(sr,normF,parms);
        force = force*2; % Two times the force because two wheels
    end
end

%OUTPUT: The torque that the motor is outputting under the constant Max
%Throttle Scheme
function torque = maxTorqueFun(t,y,parms)
    global torquehistory
    rMax = round(parms.rMax); tPeak = parms.tPeak; tMin = parms.tMin; 
    rKnee = round(parms.rKnee); thresh = parms.Thresh; cut = parms.cut; wRad = parms.wRad;
    maxtors = ones(rMax,1); %each index is an rpm, I am going to map a torque to it now
    maxtors = tPeak.*maxtors;
    m = (tMin-tPeak)/(rMax-rKnee);
    for i = 1:rMax-round(rKnee)
        maxtors(i+rKnee) = tPeak+m*i;
    end
    %The max torque motor curve is right
    
    %Get the last available torque to determine the current slip ratio

    sortedTors = sort(torquehistory,1);
    if size(sortedTors,1) == 1
        lastTorq = sortedTors(1,2);
    else
        deltTime = t-sortedTors(1,1);
        timeIndex = 1;
        for i = 2:size(sortedTors,1)
            if t-sortedTors(i,1) < deltTime
                deltTime = t-sortedTors(i,1);
                timeIndex = i;
            end
        end
        lastTorq = sortedTors(i,1);
    end
    rearWheelVelocity = rwheelomg(t,y,parms,lastTorq);
    rads = rearWheelVelocity*parms.gR;% the current motor velocity
    if round(rads) >= rMax % This if block determines what the max torque 
        maxtorque = 0;
        'max RPM reached'; % is at any given rpm
    elseif round(rads) <= 2
        maxtorque = tPeak*parms.gR;
        '0 RPM';
    else
        maxtorque = maxtors(round(rads)+1)*parms.gR;
        'Nonzero RPM';
    end
    torque = maxtorque;
    index = size(torquehistory,1);
    torquehistory(index+1,1) = t;
    torquehistory(index+1,2) = torque;
    sortedTors = sort(torquehistory,1);
    %determine the front wheel velocity as well
    frads = fwheelomg(t,y,parms);
end

%OUTPUT: The torque that the motor needs to output assuming the
%proportional control scheme
%INPUT: Time, state of the car, prameters
function torque = propTorqueFun(t,y,parms)
    global torquehistory
    rMax = round(parms.rMax); tPeak = parms.tPeak; tMin = parms.tMin; 
    rKnee = round(parms.rKnee); thresh = parms.Thresh; cut = parms.cut; 
    wRad = parms.wRad; prop = parms.prop;
    maxtors = ones(rMax,1); %each index is an rpm, I am going to map a torque to it now
    maxtors = tPeak.*maxtors;
    m = (tMin-tPeak)/(rMax-rKnee);
    for i = 1:rMax-round(rKnee)
        maxtors(i+rKnee) = tPeak+m*i;
    end
    %The max torque motor curve is right
    
    %Get the last available torque to determine the current slip ratio

    sortedTors = sort(torquehistory,1);
    if size(sortedTors,1) == 1
        lastTorq = sortedTors(1,2);
    else
        deltTime = t-sortedTors(1,1);
        timeIndex = 1;
        for i = 2:size(sortedTors,1)
            if t-sortedTors(i,1) < deltTime
                deltTime = t-sortedTors(i,1);
                timeIndex = i;
            end
        end
        lastTorq = sortedTors(i,1);
    end
    rearWheelVelocity = rwheelomg(t,y,parms,lastTorq);
    rads = rearWheelVelocity*parms.gR;% the current motor velocity
    if round(rads) >= rMax % This if block determines what the max torque 
        maxtorque = 0;
        'max RPM reached'; % is at any given rpm
    elseif round(rads) <= 2
        maxtorque = tPeak*parms.gR;
        '0 RPM';
    else
        maxtorque = maxtors(round(rads)+1)*parms.gR;
        'Nonzero RPM';
    end
    torque = maxtorque*prop;
    index = size(torquehistory,1);
    torquehistory(index+1,1) = t;
    torquehistory(index+1,2) = torque;
    sortedTors = sort(torquehistory,1);
    %determine the front wheel velocity as well
    frads = fwheelomg(t,y,parms);
end

%OUTPUT: The torque that the motor needs to output given a the back off
%when slipping control scheme
%INPUT: State of the car
function torque = activeTorqueFun(t,y,parms)
    %y(3) = rear wheel rpm
    %y(4) = front wheel rpm
    global torquehistory
    global torqueAllowable
    %built the gear ratio into the max torque profile
    rMax = round(parms.rMax); tPeak = parms.tPeak; tMin = parms.tMin; 
    rKnee = round(parms.rKnee); thresh = parms.Thresh; cut = parms.cut;
    gain = parms.gain;
    %Finding the most recent torque
    lastTorque = tPeak;
    torqueAllowable = tPeak*.3;
    index = size(torquehistory,1);
    sortedTors = sort(torquehistory,1);
    if size(sortedTors,1) == 1
        lastTorque = sortedTors(1,2);
    else
        deltTime = t-sortedTors(1,1);
        timeIndex = 1;
        while i == 2:size(sortedTors,1)
            if t-sortedTors(i,1) < deltTime
                deltTime = t-sortedTors(i,1);
                timeIndex = i;
            end
            lastTorque = sortedTors(timeIndex,2);
        end
    end
    %find the wheel speeds
    %front wheel speed
    fomg = fwheelomg(t,y,parms);
    %rear wheel speed
    romg = rwheelomg(t,y,parms,lastTorque);
    
    maxtors = ones(rMax,1); %each index is an rpm, I am going to map a torque to it now
    maxtors = tPeak.*maxtors;
    m = (tMin-tPeak)/(rMax-rKnee);
    for j = 1:rMax-round(rKnee)
        maxtors(j+rKnee) = tPeak+m*j;
    end
    %The max torque motor curve is right
    rads = romg*parms.gR;% the current motor velocity
    if round(rads) >= rMax % This if block determines what the max torque 
        maxtorque = 0;
        'max RPM reached'; % is at any given rpm
    elseif round(rads)+1 == 1
        maxtorque = tPeak;
        '0 RPM';
    else
        maxtorque = maxtors(round(rads)+1);
        'Nonzero RPM';
    end
    %Control Structures
    %%Comparative Wheel Speeds - looks at the front wheel speed and the rear
    %wheel speed, if the rear wheels are spinning much faster than the
    %front, reduce torque by some amount of proportion, begin at peak
    %torque
    if (romg/fomg-1) >= thresh
        torqueAllowable = sortedTors(timeIndex,2)*(1-cut);% the most recent torque minus the cut proportion
        'we cut the torque'
    else
        torqueAllowable = lastTorque*(1+gain);
        'we increased the torque'
    end
    if torqueAllowable > maxtorque
        torque = maxtorque;
        'the torque requested is greater than the torque available'
    end
    torque = torqueAllowable;
    torquehistory(index+1,1) = t;
    torquehistory(index+1,2) = torque;
end

%OUTPUT: the normal force on the front tire
%INPUT: State and total longitudinal force
function normF = frontNormF(y,torque,parms)
    %Unpack Parms
    cdmass = parms.cdmass; cgd = parms.cgd; G = parms.G; cgh = parms.cgh; 
    wb = parms.wb; wRad = parms.wRad;

    %First Pass, the front normal force is equal to the static weight
    %distribution
    %normF = parms.cdmass*(1-parms.cgd);
    
    %Second Pass - Solved using acceleration and rigid body statics, any CG
    %migration caused by deflection of the tire etc is negligible. 
    normF = (cdmass*G*cgd-torque/wRad*cgh)/wb/2;
end

%OUTPUT: the normal force on the rear tire
%INPUT: state and total longitudinal force
function normF = rearNormF(y,torque,parms)
    %Unpack Parms
    cdmass = parms.cdmass; cgd = parms.cgd; G = parms.G; cgh = parms.cgh; 
    wRad = parms.wRad; wb = parms.wb;
    %First Pass, the rear normal force is equal to the static weight
    %distribution
    %normF = parms.cdmass*parms.cgd;
    
    %Second Pass - Solved using acceleration and rigid body statics, any CG
    %migration caused by deflectin of the tire, etc is negligible
    normF = cdmass*G - (cdmass*G*cgd-torque/wRad*cgh)/wb/2;
end

%OUTPUT: The resultant coefficient of friction
%INPUT: slip ratio, normal force
function mu = mufun(sR,fz,parms)
    %Vehicle data
    g = 9.81;
    cdmass = 330;
    freeload = cdmass*g*.25; %static weight distribution
    maxload = cdmass*g*.5; %all the weight is on the rear wheels, two rear wheels
    
    %Tire Data
    srLinfree = parms.srLinfree;
    srPeakfree = parms.srPeakfree; % corresponds to 12 percent slip
    srSlipfree = parms.srSlipfree;

    muLinfree = parms.muLinfree; % the coefficients at nominal load
    muPeakfree = parms.muPeakfree;
    muSlipfree = parms.muSlipfree;

    degmULin = parms.degmULin; % the amount that each coefficient degrades by between 
    %             nominal load and max load
    degMuPeak = parms.degMuPeak;
    degMuSlip = parms.degMuSlip;
    
    degSrLin = parms.degSrLin;
    degSrPeak = parms.degSrPeak;
    degSrSlip = parms.degSrSlip;
    
    muLinload = muLinfree-degmULin; % the resulting coefficients when the 
    %                               wheel is under max load
    muPeakload = muPeakfree - degMuPeak;
    muSlipload = muSlipfree - degMuSlip;
    
    muLin = muLinfree - degmULin/(maxload-freeload)*(fz-freeload); %find the 
    %slope of the linear range
    muPeak = muPeakfree - degMuPeak/(maxload-freeload)*(fz-freeload);
    muSlip = muSlipfree - degMuSlip/(maxload-freeload)*(fz-freeload);
    
    srLin = srLinfree + degSrLin/(maxload-freeload)*(fz-freeload);
    srPeak = srPeakfree + degSrPeak/(maxload-freeload)*(fz-freeload);
    srSlip = srSlipfree + degSrSlip/(maxload-freeload)*(fz-freeload);
    
    
    if sR < srLin % linear range of the tires
        mu = muLin/srLin*sR;
    elseif sR < srPeak %from linear to peak
        m = muLin/srLin;
        a = (muLin-muPeak)/(srLin^2-2*srPeak*srLin+srPeak^2);
        b = -2*a*srPeak;
        c = muPeak + a*srPeak^2;
        mu = a*sR^2+b*sR+c;
    elseif sR < srSlip %from peak to slipping
        a = (muSlip-muPeak)/(srSlip^2-2*srPeak*srSlip+srPeak^2);
        c = muPeak+a*srPeak^2;
        b = -2*a*srPeak;
        mu = a*sR^2 + b*sR + c;
    else % full slipping
        mu = muSlip;    
    end
end

%OUTPUT: The resultant slip ratio
%INPUT: the input torque and normal force
function sr = srfun(torque,normalForce,parms)
    % First Pass  - sr is a linear superposition of torque and normalForce
    ktorque = .002;
    kload = .001;
    sr = ktorque*torque+kload*(normalForce-parms.cdmass*parms.cgd);

end

%OUTPUT: Front Wheel Velocity
%INPUT: Time, State of the vehicle, parameters, and torque
function rads = fwheelomg(t,y,parms)
    global fwheelomgHist
    wRad = parms.wRad;
    rads = y(2)/wRad;
    index = size(fwheelomgHist,1);
    fwheelomgHist(index+1,1) = t;
    fwheelomgHist(index+1,2) = rads;
end

%OUTPUT: Rear Wheel Velocity
%INPUT: Time, state of the vehicle, parameters
function rads = rwheelomg(t,y,parms,torque)
    global rwheelomgHist
    wRad = parms.wRad;
    rads = y(2)/wRad*(1+srfun(torque,rearNormF(y,torque,parms),parms));%omega = velocity/radius
    index = size(rwheelomgHist,1);
    rwheelomgHist(index+1,1) = t;
    rwheelomgHist(index+1,2) = rads;
end


