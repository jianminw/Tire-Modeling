function f = SR_interpolation(coEff)
    %lots of for loops, basically it's a 100 variable system of equations
    %to solve for the 100 coefficients of each function for the pacejka
    %coefficients. 
    m = zeros(144);
    initial = zeros(144, 4);
    
    %I guess this looks cleaner than the other monstrocity of for loops. 
    
    for row = 1:144
        d = coEff(row);
        pressure = d.pressure;
        camber = d.camber;
        force = d.force / 50;
        slipAngle = d.slipAngle;
        % One hundred different exponential combinations, in order
        % to make the correct interpolation curve. Three separate
        % for loops are used to avoid a lot of modulus math. 
        for p = 0:3
            for c = 0:2
                for l = 0:3
                    for s = 0:2
                        % this is a simple function that is a bijection between
                        % [4]x[3]x[4]x[3] to [144d]
                        % Any bijection between those two sets would work, but
                        % it must be the same as the one used in Pacejka_Model
                        column = p*3*4*3 + c*3*4 + l*3 + s + 1;
                        m(row, column) = pressure^p * camber^c * force^l * slipAngle^s; 
                    end
                end
            end
        end
        % Setting target values
        for j = 1:4
            initial(row, j) = d.coeff(j);
        end
    end
    
    % Solving 4 systems of equations with 144 equations and 144 variables
    % each
    f = m \ initial;
    
    % Test that the values work for the specified positions, at the very
    % least. Set to true to test and false to skip. 
    testValues = true;
    m = 1:144;
    if testValues
        for row = 1:144
            d = coEff(row);
            pressure = d.pressure;
            camber = d.camber;
            force = d.force / 50;
            slipAngle = d.slipAngle;
            % One hundred different exponential combinations, in order
            % to make the correct interpolation curve. Three separate
            % for loops are used to avoid a lot of modulus math. 
            for p = 0:3
                for c = 0:2
                    for l = 0:3
                        for s = 0:2
                            % this is a simple function that is a bijection between
                            % [4]x[3]x[4]x[3] to [144d]
                            % Any bijection between those two sets would work, but
                            % it must be the same as the one used in Pacejka_Model
                            column = p*3*4*3 + c*3*4 + l*3 + s + 1;
                            m(column) = pressure^p * camber^c * force^l * slipAngle^s; 
                        end
                    end
                end
            end
            computedCoEff = m * f;
            difference = computedCoEff - d.coeff;
            differenceSquare = difference * difference';
            assert(differenceSquare < 0.0001);
        end
    end
end