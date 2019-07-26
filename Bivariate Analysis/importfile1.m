% customized MATLAB function to read .gss files

function [scalebar_x1,scalebar_y1,synapticAreaOutline_x,synapticAreaOutline_y,smallGoldParticleCoordinates_x,smallGoldParticleCoordinates_y,largeGoldParticleCoordinates_x,largeGoldParticleCoordinates_y] = importfile1(filename, startRow, endRow)
%IMPORTFILE1 Import numeric data from a text file as column vectors.
%   [SCALEBAR_X1,SCALEBAR_Y1,SYNAPTICAREAOUTLINE_X,SYNAPTICAREAOUTLINE_Y,SMALLGOLDPARTICLECOORDINATES_X,SMALLGOLDPARTICLECOORDINATES_Y,LARGEGOLDPARTICLECOORDINATES_X,LARGEGOLDPARTICLECOORDINATES_Y]
%   = IMPORTFILE1(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [SCALEBAR_X1,SCALEBAR_Y1,SYNAPTICAREAOUTLINE_X,SYNAPTICAREAOUTLINE_Y,SMALLGOLDPARTICLECOORDINATES_X,SMALLGOLDPARTICLECOORDINATES_Y,LARGEGOLDPARTICLECOORDINATES_X,LARGEGOLDPARTICLECOORDINATES_Y]
%   = IMPORTFILE1(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [scalebar_x1,scalebar_y1,synapticAreaOutline_x,synapticAreaOutline_y,smallGoldParticleCoordinates_x,smallGoldParticleCoordinates_y,largeGoldParticleCoordinates_x,largeGoldParticleCoordinates_y] = importfile1('ml_01-40k-b.gss',3, 50);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/03/30 14:13:15

%% Initialize variables.
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[3,4,5,6,7,8]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [3,4,5,6,7,8]);
rawCellColumns = raw(:, [1,2]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
scalebar_x1 = rawCellColumns(:, 1);
scalebar_y1 = rawCellColumns(:, 2);
synapticAreaOutline_x = cell2mat(rawNumericColumns(:, 1));
synapticAreaOutline_y = cell2mat(rawNumericColumns(:, 2));
smallGoldParticleCoordinates_x = cell2mat(rawNumericColumns(:, 3));
smallGoldParticleCoordinates_y = cell2mat(rawNumericColumns(:, 4));
largeGoldParticleCoordinates_x = cell2mat(rawNumericColumns(:, 5));
largeGoldParticleCoordinates_y = cell2mat(rawNumericColumns(:, 6));


