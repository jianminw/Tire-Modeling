function y = Tire_Hash(pressure, camber, force)
    pressure = round(pressure / 2) - 4;
    force = round(force / 50) - 1;
    camber = round(camber);
    if (max([pressure+1, force, camber]) > 4 || min([pressure, force, camber]) < 0)
        y = 0;
    else
        y = pressure * 25 + camber * 5 + force + 1;
    end
end