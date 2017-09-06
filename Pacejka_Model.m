function Pacejka_Model()
    input.pressure = 9;
    input.camber = 2.3;
    input.load = 137;
    bounds.pressureUpper = 14;
    bounds.pressureLower = 8;
    bounds.camberUpper = 4;
    bounds.camberLower = 0;
    bounds.loadUpper = 250;
    bounds.loadLower = 50;
    % slipAngle = 0.06; 
    if (not(checkBounds(input, bounds)))
        return
    end
    % divide load by 50 so that quartics don't go to ridiculous numbers. 
    input.load = input.load / 50;
    coEff = zeros(100, 4);
    load('Pacejka_Interpolation.mat', 'coEff');
    % Can't think of a better name for this variable. m stores combinations
    % of powers of pressure, camber and load to multiply with the
    % coefficients of the interpolation function. 
    m = zeros(1,100);
    % setting numbers for the input
    for x = 0:3
        for y = 0:4
            for z = 0:4
                % IMPORTANT: This map below from (x,y,z) to column MUST be
                % the same as the one in interpolation!!!!
                column = x*25 + y*5 + z + 1;
                m(column) = input.pressure^x * input.camber^y * input.load^z; 
            end
        end
    end
    % 1 x 100 matrix multiplied by 100 x 4 matrix gives a 1 x 4 matrix
    coEff = m * coEff;
    % make the pacejka function and graphs it 
    y = @(x) coEff(3)*sin(coEff(2)*atan(coEff(1)*x - coEff(4)*(coEff(1)*x - atan(coEff(1)*x))));
    % force = y(slipAngle)
    fplot(y, [degtorad(-15) degtorad(15)], 'r')
    % This script takes over 1 second to run, but most of that is graphing.
    % Simply calculating the side force at one specific slip angle takes
    % around 30 milliseconds (0.032 s). 
end

function result = checkBounds(inputs, bounds)
    result = true;
    if (inputs.pressure > bounds.pressureUpper || inputs.pressure < bounds.pressureLower)
        result = false;
    elseif (inputs.camber > bounds.camberUpper || inputs.camber < bounds.camberLower)
        result = false;
    elseif (inputs.load > bounds.loadUpper || inputs.load < bounds.loadLower)
        result = false;
    end
end