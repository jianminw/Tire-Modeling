function coEff = Slip_Angle_Modeling(CR25)
    %ET = CR25.ET; % [s] elapsed time
    P = CR25.P;   % [kpa] pressue
    SA = CR25.SA; % [deg] slip angle
    IA = CR25.IA; % [deg] camber angle
    %FX = CR25.FX; % [N] longitudinal force
    FY = CR25.FY; % [N] lateral force
    FZ = CR25.FZ; % [N] normal force
    MX = CR25.MX; % [N*m] overturning moment
    MZ = CR25.MZ; % [N*m] aligning torque
    %SR = CR25.SR; % [unitless] Slip ratio based on load radius
    %SL = CR25.SL; % [unitless] Slip ratio based on effective radius
    pos = CR25.pos;
    % pre-allocate space to variables. 
    coEff(1:100) = SA_CoEff_Data();
                
    maxSideForces = zeros(5, 5);
               
    for i = 1:2:length(pos)-rem(length(pos),2)-1
        datax = SA(pos(i):5:pos(i+1));
        datay = -FY(pos(i):5:pos(i+1));
        
        overturning = MX(pos(i):pos(i+1));
        aligning = MZ(pos(i):pos(i+1));

        % extracting pressure, camber and normal force data
        pressure = P(pos(i):pos(i+1)) / 6.89476; %convert to psi
        camber = IA(pos(i):pos(i+1));
        force = -FZ(pos(i):pos(i+1)) / 4.44822; %convert to lbs

        % hash functions to map pressure, camber and normal force to index
        % values
        p = round(mean(pressure) / 2) - 4;
        f = round(mean(force) / 50 - 1);
        c = round(mean(camber));

        %check for the hashed values to be in correct values. 
        if (max([p+1, f, c]) < 5)
            if (min([p, f, c]) >= 0)
                tempdata = SA_CoEff_Data;
                temp = Pacejka(datax, datay);
                % might have issues if directly assigning arrays over. 
                % maybe not in MatLab, where arrays are still basic data
                % structures
                for j = 1:4
                    tempdata.coeff(j) = temp(j);
                end
                tempdata.pressure = mean(pressure);
                tempdata.camber = mean(camber);
                tempdata.force = mean(force);
                
                tempdata.overturning = max(abs(overturning));
                tempdata.aligning = max(abs(aligning));

                % figuring out where to put all of the data
                % data from similar points are replaced because the
                % interpolations is easier with a round 100 points in a rough 4
                % by 5 by 5 grid. 
                index = p*25 + c*5 + f + 1;
                coEff(index) = tempdata;
                % use index = 1 to 100 when testing
                if (p == 1)
                    %disp( mean(force) )
                    %disp( temp(3) / mean(force) / 4.45 )
                    %hold all
                    
                    % plotting coefficients of friction to normal force
                    %force = -FZ(pos(i):5:pos(i+1));
                    %scatter(force, datay ./ force)
                    
                    %scatter(degtorad(datax), datay)
                    
                    maxSideForces(c+1, f+1) = max(datay);
                    
                    %x = temp;
                    %y = @(xdata) x(3)*sin(x(2)*atan(x(1)*xdata - x(4)*(x(1)*xdata - atan(x(1)*xdata))));
                    %fplot(y, [degtorad(min(datax)) degtorad(max(datax))], 'r')
                end
            end
        end
    end
    
    for p = 0:3
        for c = 0:4
            for f = 0:4
                index = p*25 + c*5 + f + 1;
                temp = coEff(index).coeff;
                disp(temp(4));
            end
        end
    end
    
    % just save the base coefficients
    save('SA_Pacejka_Coeffs.mat', 'coEff');
    
    %disp(maxSideForces);

    %coEff = SA_interpolation(coEff); 

    % export variables for use in other scripts
    %save('Pacejka_Interpolation_SA.mat', 'coEff');
    
end