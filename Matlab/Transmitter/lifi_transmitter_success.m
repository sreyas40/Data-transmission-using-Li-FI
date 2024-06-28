clc;
clear all;
close all;

s = serialport("COM5", 115200);
%text data to be sent, use writeline(s,message) in the command window to send text data
message="All laws in force in the territory of India immediately before the commencement of this Constitution, in so far as they are inconsistent with the provisions of this Part, shall, to the extent of such inconsistency, be void.";

% Specify the path to your JPEG image
imagePath = 'Save.png';
% Open the file in binary read mode
fileID = fopen(imagePath, 'rb');
% Read the file as bytes
imageBytes = fread(fileID, '*uint8');
% Close the file
fclose(fileID);
% Encode the byte array into Base64
encodedBase64 = matlab.net.base64encode(imageBytes);
imageSize= size(imageBytes)




dataLength = length(encodedBase64)



%inputString = 'All laws in force in the territory of India immediately before the commencement of this Constitution, in so far as they are inconsistent with the provisions of this Part, shall, to the extent of such inconsistency, be void.';
inputString= encodedBase64
splitSize = 98;
splitStrings = splitString(inputString, splitSize);

delay = 3; % Define the delay between each transmission

pause(2)
% Send each chunk with a delay
for i = 1:length(splitStrings)
    writeline(s, splitStrings{i});
    pause(delay); % Delay between each transmission
end

disp("Data sent to Arduino.");

function splitStrings = splitString(inputString, splitSize)
    % Get the length of the input string
    len = length(inputString);

    % Calculate the number of splits needed
    numSplits = ceil(len / splitSize);

    % Initialize the cell array to store split strings
    splitStrings = cell(1, numSplits);

    % Loop through the string and split it into smaller strings
    for i = 1:numSplits
        startIndex = (i - 1) * splitSize + 1;
        endIndex = min(i * splitSize, len);
        splitStrings{i} = inputString(startIndex:endIndex);
        disp(splitStrings{i})
    end
end
