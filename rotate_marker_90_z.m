function rotated_data = rotate_marker_90_z(marker_data)
    % This function rotates 3xN marker data 90 degrees clockwise around the z-axis.
    % marker_data: 3xN matrix where the first row is x, second row is y, and third row is z.
    % rotated_data: 3xN matrix after rotation
    
    % Define the 90-degree clockwise rotation matrix around the z-axis
    R_z = [0 1 0; -1 0 0; 0 0 1];
    
    % Perform the rotation by multiplying the marker data by the rotation matrix
    rotated_data = R_z * marker_data;

   %   R_x = [1 0 0; 0 -1 0; 0 0 -1];
      %    rotated_data = R_x * rotated_data;

       % Invertiere die y-Achse (2. Zeile der rotieren Daten), um die Richtung zu korrigieren
  % rotated_data(3, :) = -rotated_data(3, :);
end