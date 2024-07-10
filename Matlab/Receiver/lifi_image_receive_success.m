clc;
clear all;

% Create serial object for Arduino
s = serialport("COM9", 115200);
configureTerminator(s, "LF"); % Set terminator to newline character

% Initialize an empty string to store received data
receivedData = "";
% Define the end-of-line character
endOfLine = char(10); % Assuming
% newline character

% Main loop to continuously read data from Arduino
while true
    if s.NumBytesAvailable > 0
        % Read one character from Arduino
        data = read(s, 1, "char");
        
        % Append received character to the string
        receivedData = receivedData + data;
        
        % Display received character
        fprintf('Received character: %s\n', data);
        
            
    end
end
