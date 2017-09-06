function f = SA_interpolation(coEff)
    %lots of for loops, basically it's a 100 variable system of equations
    %to solve for the 100 coefficients of each function for the pacejka
    %coefficients. 
    m = zeros(100);
    initial = zeros(100, 4);
    
    %I guess this looks cleaner than the other monstrocity of for loops. 
    
    for row = 1:100
        d = coEff(row);
        pressure = d.pressure;
        camber = d.camber;
        force = d.force / 50;
        % One hundred different exponential combinations, in order
        % to make the correct interpolation curve. Three separate
        % for loops are used to avoid a lot of modulus math. 
        for x = 0:3
            for y = 0:4
                for z = 0:4
                    % this is a simple function that is a bijection between
                    % [4]x[5]x[5] to [100]
                    % Any bijection between those two sets would work, but
                    % it must be the same as the one used in Pacejka_Model
                    column = x*25 + y*5 + z + 1;
                    m(row, column) = pressure^x * camber^y * force^z; 
                end
            end
        end
        % Setting target values
        for j = 1:4
            initial(row, j) = d.coeff(j);
        end
    end
    
    % Solving 4 systems of equations with 100 equations and 100 variables
    % each
    f = m \ initial;
    
    % check that the values actually match up
    % set testValues to true to test and false to skip
    testValues = true;
    m = 1:100;
    if testValues
        for row = 1:100
            d = coEff(row);
            pressure = d.pressure;
            camber = d.camber;
            force = d.force / 50;
            % One hundred different exponential combinations, in order
            % to make the correct interpolation curve. Three separate
            % for loops are used to avoid a lot of modulus math. 
            for x = 0:3
                for y = 0:4
                    for z = 0:4
                        % this is a simple function that is a bijection between
                        % [4]x[5]x[5] to [100]
                        % Any bijection between those two sets would work, but
                        % it must be the same as the one used in Pacejka_Model
                        column = x*25 + y*5 + z + 1;
                        m(column) = pressure^x * camber^y * force^z; 
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