% Code Name: NFL Mock Draft 2023
% Code Description: A mock first round of the upcoming 2023 draft
% Author: Nicolas Chamberlain
% Email: chamben9@my.earu.edu
% Class: EGR 115 - Section 10
% Date: 4/7/2023

clear
clc
close all
% Assign the prospects and teams excel sheet to variables
prospects = readcell('NFL_Mock_Draft_Data.xlsx','UseExcel',true,'Sheet','Prospects'); %<SM:READ>
teams = readcell('NFL_Mock_Draft_Data.xlsx','UseExcel',true,'Sheet','Teams');
% Organizes teams by pick number
pickisin = sortrows(teams,5);
% Welcome message
fprintf(['Welcome to the 2023 NFL First Round Mock Draft. This program will allow you to draft\n' ...
    'a prospect for whichever NFL team that you choose. Any team that you do not choose\n' ...
    'will be autopicked by the computer.\n'])
userteam = input('Which NFL team would you like to draft for in the first round (Carolina Panthers, Houston Texans, etc.)? ','s');
% Error checking for userteam
while isempty(userteam) || ismember(lower(userteam),lower(teams(:,1))) == 0

    fprintf('Error. The team you entered may be invalid or may not have a first round pick.\n')
    userteam = input('Please enter a valid NFL location and team (Carolina Panthers, Houston Texans, etc.): ','s');

end

ontheboard = prospects; % This is the same as the prospects matrix, avoids messing with the excel sheet
fprintf('The 2023 NFL Mock Draft will now begin!\n')

for k = 1:height(pickisin) % The entire process of drafting is within this for loop

    fprintf('\n\t\t\t\tThe %s are on the clock.\n',char(pickisin(k,1)))
    % If the current drafting team is the users team this if statement will
    % trigger
    if strcmpi(pickisin(k,1),userteam) %<SM:STRING>

        userpick = input('It is now your pick, would you like to see players for a specific position? ','s');
        % Error checking for either 'yes' or 'no'
        while isempty(userpick) || strcmpi(userpick,'yes') == 0 && strcmpi(userpick,'no') == 0 || ~isnan(str2double(userpick))

            userpick = input('Error. Please enter yes or no: ','s');

        end
        % If the user says yes this if statement activates, if not they will simply choose a player
        if strcmpi(userpick,'yes')

            fprintf(['There are 11 positions to choose from:\n' ...
                '\tQuarterback = QB\n' ...
                '\tWide Reciever = WR\n' ...
                '\tTackle = T\n' ...
                '\tGuard = G\n' ...
                '\tCenter = C\n' ...
                '\tRunning Back = RB\n' ...
                '\tTight End = TE\n' ...
                '\tDefensive Back = DB\n' ...
                '\tLinebacker = LB\n' ...
                '\tDefensive Line = DL\n' ...
                '\tEdge Rusher = ED\n'])
            userpickrepeat = 'yes';
            % This will allow the positions to be reset after being repeated, without
            % showing the large fprintf again
            while strcmpi(userpickrepeat,'yes')
                % Empty array for error checking
                userchoice = {};
                userposition = input('Please enter the abbreviation of the position you would like to look at: ','s');
                % Error checking userposition
                while isempty(userposition) || ismember(upper(userposition),ontheboard(:,2)) == 0

                    fprintf('Error. The position you entered was invalid.\n')
                    userposition = input('Please enter the abbreviation of the position you want to look at: ','s');

                end

                for u = 1:height(ontheboard)

                    if strcmp(ontheboard(u,1),'PICKED') == 0

                        if strcmpi(ontheboard(u,2),userposition)
                            % Augmenting the position that the user chooses into a new array
                            userchoice = [userchoice; ontheboard(u,:)];

                        end

                    end

                end

                if isempty(userchoice) == 0
                    % The selected position will be displayed with all player names, school,
                    % and stats in a table
                    label = {'Name','School','Season Grade','Production Score','Athleticism Score'};
                    positiontable = table(string(userchoice(:,1)),string(userchoice(:,3)),cell2mat(userchoice(:,4)), ...
                        cell2mat(userchoice(:,5)),cell2mat(userchoice(:,6)),'VariableNames',label);
                    disp(positiontable)
                    fprintf('These are the current available %s''s.\n',upper(userposition))
                    % The user can choose a different position to look at
                    userpickrepeat = input('Would you like to look at a different position? ','s');

                elseif isempty(userchoice)
                    % This will display if there are no more players
                    % available at the position
                    fprintf('There are no more available %s''s.\n',upper(userposition))
                    userpickrepeat = input('Would you like to look at a different position? ','s');

                end
                % Error checking repeat input
                while isempty(userpickrepeat) || strcmpi(userpickrepeat,'yes') == 0 && strcmpi(userpickrepeat,'no') == 0 || ~isnan(str2double(userpickrepeat))

                    userpickrepeat = input('Error. Please enter yes or no: ','s');

                end

            end


        end

        userprospect = input('What player would you like to draft (Enter first and last name)? ','s');

        while isempty(userprospect) || ismember(lower(userprospect),lower(ontheboard(:,1))) == 0 || strcmpi(userprospect,'PICKED') %<SM:BOP> %<SM:WHILE>

            fprintf('Error. That player is either not in the database or has already been selected.\n')
            userprospect = input('Please select another player: ','s');

        end

        for u = 1:height(ontheboard) %<SM:FOR>
            % This will find the player that the user has selected
            if strcmpi(ontheboard(u,1),userprospect) %<SM:IF> %<SM:NEST>
                % If the player exists then their data will be placed into the pickisin
                % matrix to be displayed in the command window
                pickisin(k,[6,7,8]) = ontheboard(u,[1,2,3]);
                ontheboard(u,1) = {'PICKED'}; % The player they selected will have their name removed

            end

        end
        % For any team that is not the users team this elseif statement will
        % trigger and autodraft the player for that team
    elseif strcmpi(pickisin(k,1),userteam) == 0
        % These two cell arrays are cleared everytime that a computer is picking
        cpuselect = {};
        cpufinalist = {};
        % This while statement prevents the computer from having no options to
        % select from
        while isempty(cpuselect) %<SM:WHILE>
            % This variable allows there to be some randomness in the selecting of the
            % players so that each draft is not the same
            positionodds = rand; %<SM:RANDGEN>
            % These if statements represent the odds of the team selecting their first
            % second and third choice
            if positionodds <= (0.85-(k/100)) %<SM:RANDUSE> %<SM:IF>
                % After the position to draft is selected it gets replaced with 'PICKED' so
                % that the team cannot draft another player of that position if they have
                % multiple picks
                teamchoice = pickisin(k,2); %<SM:SLICE>
                pickisin(k,2) = {'PICKED'};
                pickisin = teamchoiceremove(pickisin,k,2);

            elseif positionodds > (0.85-(k/100)) && positionodds <= 0.92 %<SM:ROP> %<SM:BOP>

                teamchoice = pickisin(k,3);
                pickisin(k,3) = {'PICKED'};
                pickisin = teamchoiceremove(pickisin,k,3);

            elseif positionodds > 0.92 %<SM:ROP>

                teamchoice = pickisin(k,4);
                pickisin(k,4) = {'PICKED'};
                pickisin = teamchoiceremove(pickisin,k,4);

            end
            % This for loop checks the board for all players of the selected position
            % only if they have not been picked
            for u = 1:height(ontheboard) %<SM:FOR>

                if strcmp(ontheboard(u,1),'PICKED') == 0

                    if strcmp(ontheboard(u,2),teamchoice)

                        cpuselect = [cpuselect;  ontheboard(u,:)]; %<SM:AUG>
                        % New array with all players of the position

                    end

                end

            end

        end

        avgscore = []; % New array meant to hold the average overall rating of each player

        for u = 1:height(cpuselect)
            % This is the math for the average score, placed in a for loop so that it
            % is done for every player
            avgscore =[avgscore, mean(cell2mat(cpuselect(u,4:end)))];

        end

        avgscore = avgscore'; % Makes avgscore array vertical
        cpuselect = [cpuselect, num2cell(avgscore)]; % Adds avgscore to cpuselect
        [maxavg, locmaxavg] = max(avgscore); % Finds the highest average score

        for u = 1:height(cpuselect)
            % This compares the average score of every player to the highest average
            % score
            procompare = maxavg - avgscore(u);

            if procompare <= 5
                % If the player is within 5 of the highest average they will be moved into
                % the cpufinalist array
                cpufinalist = [cpufinalist; cpuselect(u,:)];

            end

        end

        [finalistrow,finalistcol] = size(cpufinalist);
        prorand = ceil(rand*finalistrow); % This selects a random player from cpufinalist
        pickisin(k,[6,7,8]) = cpufinalist(prorand,[1,2,3]); % This adds the player into the pickisin array

        for u = 1:height(ontheboard)

            if strcmpi(ontheboard(u,1),pickisin(k,6))
                % This finds the selected player and displays them as picked
                ontheboard(u,1) = {'PICKED'};

            end

        end

    end
    % This adds a delay to the displaying of each draft pick
    pause(2) %<SM:NEWFUN>
    fprintf('\tWith the #%d overall pick in the draft,\n\tThe %s have selected %s, %s, %s \n',k,char(pickisin(k,1)),char(pickisin(k,6)),char(pickisin(k,7)),char(pickisin(k,8)))
    pause(1)

end

fprintf('\nThis concludes the 2023 NFL Mock Draft!\n')
% The positiontotal function will assign the variable to total number of
% that position drafted
positions = {'QB','WR','RB','TE','C','T','G','DB','LB','DL','ED'};
total_plot = [];
position_plot = {};

for k = 1:length(positions)
    % Sets the total equal to the number of players drafted at that position
    total(k,1) = positiontotal(positions{k},pickisin); %<SM:PDF_PARAM> %<SM:PDF_RETURN>
    % Adds the position to the plot only if there was at least 1 selected
    if total(k,1) > 0
        % Augmenting the number of players drafted at the position and the
        % position name for the plot
        total_plot = [total_plot;total(k,1)];
        position_plot = [position_plot;positions{k}];

    end

end

pie(total_plot,position_plot) %<SM:PLOT>
colormap("parula")
title('Most Drafted Position in The Mock Draft')

%% Functions

function runningtotal = positiontotal(position,matrix) %<SM:PDF>
% function runningtotal = positiontotal(position,matrix)
%
% This function will find the total amount of players that exist at the
% position of your choosing in the matrix of your choosing
runningtotal = 0;
for k = 1:height(matrix)

    if strcmpi(matrix(k,7),position)

        runningtotal = runningtotal + 1; %<SM:RTOTAL>

    end

end

end

function matrix = teamchoiceremove(matrix,constant,choice)
% function matrix = teamchoiceremove(matrix,constant)
%
% This function will remove the first chosen position as an option for the
% same team in any other draft picks. This is only used for teams with
% multiple picks to stop them from taking two players of the same position
for u = 1:height(matrix)

    if strcmp(matrix(constant,1),matrix(u,1))

        matrix(u,choice) = {'PICKED'};

    end

end

end