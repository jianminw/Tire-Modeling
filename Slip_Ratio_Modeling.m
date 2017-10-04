function coEff = Slip_Ratio_Modeling(DR25)
    %ET = DR25.ET; % [s] elapsed time
    P = DR25.P;   % [kpa] pressue
    SA = DR25.SA; % [deg] slip angle
    IA = DR25.IA; % [deg] camber angle
    FX = DR25.FX; % [N] longitudinal force
    %FY = DR25.FY; % [N] lateral force
    FZ = DR25.FZ; % [N] normal force
    MX = DR25.MX; % [N*m] overturning moment
    MZ = DR25.MZ; % [N*m] aligning torque
    %SR = DR25.SR; % [unitless] Slip ratio based on load radius
    SL = DR25.SL; % [unitless] Slip ratio based on effective radius
    pos = DR25.pos;
    
    % Need to add the beginning and end points to the pos array
    pos = cat(1, 1, pos, length(SL));
    
    % pre-allocated space to variables
    coEff(1,144) = SR_CoEff_Data();
    
    for i = 1:length(pos)-1
        dataX = SL(pos(i):5:pos(i+1));
        dataY = FX(pos(i):5:pos(i+1));
        
        overturning = MX(pos(i):pos(i+1));
        aligning = MZ(pos(i):pos(i+1));
        
        pressure = P(pos(i):pos(i+1)) / 6.89476; %convert to psi
        camber = IA(pos(i):pos(i+1));
        force = -FZ(pos(i):pos(i+1)) / 4.44822; %convert to lbs
        slipAngle = -SA(pos(i):pos(i+1));

        tempData = SR_CoEff_Data;
        temp = Pacejka(dataX, dataY);
        
        for j = 1:4
            tempData.coeff(j) = temp(j);
        end
        
        tempData.pressure = mean(pressure);
        tempData.camber = mean(camber);
        tempData.slipAngle = mean(slipAngle);
        tempData.force = mean(force);
                
        tempData.overturning = max(abs(overturning));
        %disp(tempData.overturning);
        tempData.aligning = max(abs(aligning));
        %disp(tempData.aligning);
        
        p = round((mean(pressure) - 8) / 2); %results: 0, 1, 2, 3
        c = round(mean(camber) / 2); %results: 0, 1, 2
        f = round(mean(force) / 50 - 2); %results: -1, 1, 2, 3
        s = round(mean(slipAngle) / 3); % results: 0, 1, 2
        
        if (f < 0)
            f = 0; 
            %adjustment for the fact that forces are not evenly spaced
        end
        
        index = p*3*4*3 + c*3*4 + f*3 + s + 1;
        
        coEff(index) = tempData;
        
        % use 1 to 144 when testing
        if (p == 2 && c == 0 && s == 0)
            
            %hold all
            %force = -FZ(pos(i):5:pos(i+1));
            %scatter(force, dataY)
            %{
            disp( mean(force) )
            disp( temp(3) / mean(force) / 4.45 )
            figure
            hold all
            scatter(degtorad(dataX), dataY, 'r')
            x = temp;
            y = @(xdata) x(3)*sin(x(2)*atan(x(1)*xdata - x(4)*(x(1)*xdata - atan(x(1)*xdata))));
            fplot(y, [degtorad(min(dataX)) degtorad(max(dataX))], 'r')
            %}
        end
    end
    
    save('SR_Pacejka_Coeffs.mat', 'coEff');
    
    %coEff = SR_interpolation(coEff);
    
    % export variables for use in other scripts
    %save('Pacejka_Interpolation_SR.mat', 'coEff');
end