% Decode the Base64 string back to byte array
decodedBytes = matlab.net.base64decode(receivedData);
% Specify the file path to save the image
newImagePath = 'RestoredImage.png';
% Open the file in binary write mode
fileID = fopen(newImagePath, 'wb');
% Write the decoded bytes to the file
fwrite(fileID, decodedBytes, 'uint8');
% Close the file
fclose(fileID);
imshow('RestoredImage.png')
