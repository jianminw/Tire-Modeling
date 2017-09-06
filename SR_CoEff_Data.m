classdef SR_CoEff_Data

    % A simple class to store data. Rather self explanatory
    
    properties
        pressure
        camber
        force
        slipAngle
        coeff
        overturning
        aligning
    end
    methods
        function obj = SR_CoEff_Data()
            coeff = zeros(4,1);
        end
    end
end