function [Dkl0, DklNew] = Part2(binCount)
    function [binsProb, binsAverage] = Probabilities(data, binCount, dataSize)
        format long
    
        binSize = (max(data) - min(data)) / binCount; % set the binSize by dividing the data range by the binCount
        
        bins = zeros([binCount,1]); % initialise the bins array
        
        for i = 1:dataSize % for each item in the given dataset
           for j = 1:binCount % check each bin
                if data(i) >= min(data) + (binSize * (j - 1)) && data(i) <= min(data) + binSize * j 
                    bins(j) = bins(j) + 1; % if data is within the bin range, add a tally to that bin
                    break;
                end
           end
        end
        
        binsAverage = bins; % initialise the bins probabilities
        
        for i = 1:binCount
            binsAverage(i) = bins(i) / dataSize; % set each bin probablity as a percent of the total
        end
        
        binsProb = zeros(binCount,1); % initialise bin cumulative probability
        
        for i = 1:binCount % for each bin 
            if i == 1
                binsProb(i) = binsAverage(i); % set the base case
            else
                binsProb(i) = binsAverage(i) + binsProb(i - 1); % set the bin cumulative probability to itself plus all before it
            end
        end
    end
    
    rng(13) % initialise the random number generator seed for replicable results
    
    data0 = importdata('sample2022.txt'); % import the data0 dataset
    data0Size = size(data0); % initialise the data0Size variable as an array
    data0Size = data0Size(1); % convert the data0Size variable to an integer
    
    [data0Prob, data0Avg] = Probabilities(data0, binCount, data0Size); % get the probability deatils of data0
    
    dataNew = zeros([data0Size, 1]); % initialise dataNew
    u = rand([data0Size, 1]); % initialise the random variable dataset
    
    for i = 1:data0Size % for each particle
        for j = 1:binCount % for each bin
            if u(i) < data0Prob(j)
                dataNew(i) = j; % if the particle is within the cumulative probability range of that bin, add a count to the bin
                break;
            end
        end
    end
    
    [dataNewProb, dataNewAvg] = Probabilities(dataNew, binCount, data0Size); % get the probability details of dataNew
    
    % plot the histogram figures for each of the datasets
    figure
    subplot(1,2,1)
    histogram(data0, binCount)
    title('data0')
    xlabel('Bins')
    ylabel('Frequency')
    subplot(1,2,2)
    histogram(dataNew, binCount)
    title('dataNew')
    xlabel('Bins')
    ylabel('Frequency')
    sgtitle(num2str(binCount) + " bins")
    
    % initialise the Kullback-Leibler measure values for each direction
    Dkl0 = 0;
    DklNew = 0;

    for i = 1:binCount % for each bin
        % cumulatively add the formula for the Dkl for each direction
        Dkl0 = Dkl0 + (data0Avg(i) * (log10(data0Avg(i) / dataNewAvg(i))));
        DklNew = DklNew + (dataNewAvg(i) * (log10(dataNewAvg(i) / data0Avg(i))));
    end
end