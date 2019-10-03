function [ ] = eccentricityClassification()

if ~isdeployed
    disp('loading path')

    %for IU HPC
    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
    addpath(genpath('/N/u/brlife/git/wma_tools'))

    %for old VM
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
    addpath(genpath('/usr/local/wma_tools'))
end

% Set top directory
topdir = pwd;

% Load configuration file
config = loadjson('config.json');

% parse arguments
eccentricity = niftiRead(fullfile(config.eccentricity,'eccentricity.nii.gz'));
load(config.wmc);
out_ijk = eccentricity.qto_ijk;
wbFG = fullfile(config.track)

% need to edit this for loop for multiple tracts in classification (i.e.
% both left and right hemisphere OR, or OT and OR, etc). currently works
% with one tract at a time
for ifg = 1:length(fg_classified)
    fg = fg_classified{ifg};
    fprintf('%s\n',fg.name);
    
    % convert to output space
    fg = dtiXformFiberCoords(fg, out_ijk, 'img');

    % initialize endpoint outputs
    iep = zeros(length(fg.fibers), 3);

    % for every fiber, pull the end points
    for ii = 1:length(fg.fibers)
        iep(ii,:) = fg.fibers{ii}(:,end)';
    end

    % combine fiber endpoints & round
    iepRound = round(iep)+1;
    ep = iepRound;

    % find eccentricity for endpoints
    for ii = 1:length(ep)
        ecc(ii) = eccentricity.data(ep(ii,1),ep(ii,2),ep(ii,3));
    end
    
    % create index for streamlines based on eccentricity critera: R1 = 0-3,
    % R2 = 15-90
    for ii = 1:length(ecc)
        if ecc(ii) >= 0 && ecc(ii) < 3
            index(ii) = 1;
        elseif ecc(ii) >= 15 && ecc(ii) <= 90
            index(ii) = 2;
        else
            index(ii) = 0;
        end
    end
end

% create new classification structure
classification.names = {'R1','R2'};
classification.index = index';
fg_classified = bsc_makeFGsFromClassification_v4(classification,wbFG);

% save classification structure
save('output.mat','classification','fg_classified','-v7.3');

% create tracts for json structures for visualization
tracts = fg2Array(fg_classified);

mkdir('tracts');

% Make colors for the tracts
%cm = parula(length(tracts));
cm = distinguishable_colors(length(tracts));
for it = 1:length(tracts)
   tract.name   = strrep(tracts{it}.name, '_', ' ');
   all_tracts(it).name = strrep(tracts{it}.name, '_', ' ');
   all_tracts(it).color = cm(it,:);
   tract.color  = cm(it,:);

   %tract.coords = tracts(it).fibers;
   %pick randomly up to 1000 fibers (pick all if there are less than 1000)
   fiber_count = min(1000, numel(tracts{it}.fibers));
   tract.coords = tracts{it}.fibers(randperm(fiber_count)); 
   
   savejson('', tract, fullfile('tracts',sprintf('%i.json',it)));
   all_tracts(it).filename = sprintf('%i.json',it);
   clear tract
end

% Save json outputs
savejson('', all_tracts, fullfile('tracts/tracts.json'));

% Create and write output_fibercounts.txt file
for i = 1 : length(fg_classified)
    name = fg_classified{i}.name;
    num_fibers = length(fg_classified{i}.fibers);
    
    fibercounts(i) = num_fibers;
    tract_info{i,1} = name;
    tract_info{i,2} = num_fibers;
end

T = cell2table(tract_info);
T.Properties.VariableNames = {'Tracts', 'FiberCount'};

writetable(T, 'output_fibercounts.txt');


end
