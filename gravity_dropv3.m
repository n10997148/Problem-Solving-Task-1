function gravity_dropv3(N1, N2, P)
    function [finalPositions] = dropper(sProb, eProb, wProb, P, N)
        grid = zeros(99); % initialise an empty 99x99 grid
        finalPositions = []; % initialise the finalPositions output array
    
        if rem(str2num(N),1) ~= 0 % if 'rand' is input, there will be decimal places
            startPos = round(97.*rand(1, P) + 1); % set the startPos array to the random array
        else
            startPos = ones([1,P]).*str2double(N); % set the startPos array to an array of a set value
        end
    
        for iteration = 1:P % for each particle
            x = startPos(iteration); % set x to the startPos
            y = 1; % set y to the top of the grid
            isLive = true; % set the particle to be 'live'
            while isLive % until the particle reaches the bottom (indicated by it being 'live' or 'dead')
                r = rand() * (sProb + wProb + eProb); % generate a random variable
                if r < sProb % if the variable is in the south movement range
                    if y == 99 || grid(y + 1, x) == 1 % if the particle has reached the bottom of the screen
                        isLive = false; % set the particle to 'dead'
                    else
                        y = y + 1; % move the particle south
                    end
                elseif r < sProb + wProb % otherwise if the variable is in the west movement range
                    if x <= 1 % if the particle has reached or spawned at the edge of the screen
                        x = 98; % set the particle to the opposite side of the grid, creating a wrapping functionality
                    elseif grid(y, x - 1) == 0
                        x = x - 1; % move the particle west
                    end
                elseif r < sProb + wProb + eProb % otherwise if the variable is in the east movement range
                    if x >= 98 % if the particle has reached or spawned at the edge of the screen
                        x = 1; % set the particle to the opposite side of the grid
                    elseif grid(y, x + 1) == 0
                        x = x + 1; % move the particle east
                    end
                end        
            end
            grid(y, x) = 1; % place the particle's final position in the grid
            finalPositions(1,iteration) = x; % update the finalPositions grid
            finalPositions(2,iteration) = iteration;
        end
    end
    
    allPlots = []; % initialise the grid to hold all finalPositions
    titles = []; % initialise an array to hold the titles
    
    N = [string(N1),string(N2)]; % input the starting positions to an array

    for i = 1:2 % for each of the two starting positions
        titles(i) = string(N(i)); % insert the starting position into the titles array
        titles = string(titles()); % ensure the titles are formatted correctly

        % generate a set of finalPositions for each of the probability scenarios
        figure1 = dropper(1/3,1/3,1/3,P,N(i));
        figure2 = dropper(2/3,1/6,1/6,P,N(i));
        figure3 = dropper(3/5,1/10,3/10,P,N(i));
        figure4 = dropper(3/5,3/10,1/10,P,N(i));
    
        allPlots = [allPlots, figure1, figure2, figure3, figure4]; % insert each of the finalPositions into allPlots
    end
    
    for figureNo = 1:2 % for each of the two figures to be generated
        figure % create a new figure
        for plotNo = 1:4 % for each subplot grid item
            count = plotNo + (4 * (figureNo - 1)); % calculate how far into allPlots the current figure data is
            startX = 1 + ((count - 1) * P); % calculate the start value of the figure data within allPlots
            endX = count * P; % calculate the end value of the figure within allPlots
            % plot the histogram and set its labels
            subplot(2, 2, plotNo)
            histogram(allPlots(1,startX:endX), 99)
            axis([0, 99, 0, 15]);
            xlabel('Position')
            ylabel('Frequency')
            
            % set the title
            if plotNo == 1
                title('Equal Thirds')
            elseif plotNo == 2
                title('Most Likely Down')
            elseif plotNo == 3
                title('More Likely Left')
            elseif plotNo == 4
                title('More Likely Right')
            end
        end
        
        % set the entire subplot grid title
        if rem(str2num(titles(figureNo)),1) ~= 0
            headerText = "Random";
        else
            headerText = string(titles(figureNo));
        end

        figureTitle = strcat("Starting Position is ", headerText);
        sgtitle(figureTitle)
    end
end
