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
rois = fullfile(config.rois);
%varea = split(config.visualArea);
varea = config.visualArea;
tracts = split(config.tractNames);
operations = split(config.operations);
MinDegree = [str2num(config.MinDegree)];
MaxDegree = [str2num(config.MaxDegree)];
pre_classification = load(config.classification,'classification');
wbFG = config.wbFG;

% make pre_fg_classified to make identification easier
pre_fg_classified = bsc_makeFGsFromClassification_v4(pre_classification.classification,wbFG)

% get classification number index for each inputted tract and their fiber
% indices in the classification structure
for tt = 1:length(tracts)
    tractsIndex(tt) = find(contains(pre_classification.classification.names,tracts{tt}));
    tractsIndices.(tracts{tt}) = find(pre_classification.classification.index == tractsIndex(tt));
end

for dd = 1:length(MinDegree)
  eccen.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd)))) = ...
      bsc_loadAndParseROI(fullfile(sprintf('%s/ROI%s.Ecc%sto%s.nii.gz',rois,varea,num2str(MinDegree(dd)),num2str(MaxDegree(dd)))));
end

% need to edit this for loop for multiple tracts in classification (i.e.
% both left and right hemisphere OR, or OT and OR, etc). currently works
% with one tract at a time
for ifg = 1:length(tractsIndex)
    for dd = 1:length(MinDegree)
        [~, keep.(sprintf('%s_Ecc%sto%s',tracts{ifg},num2str(MinDegree(dd)),num2str(MaxDegree(dd))))] = ...
            wma_SegmentFascicleFromConnectome(pre_fg_classified{tractsIndex(ifg)}, ...
            [{eccen.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd))))} ],...
            {operations{ifg} }, 'dud');
    end
end

% create new classification structure of tracts binned by eccentricity
classification.index = pre_classification.classification.index*0;
count = 0;
for ifg = 1:length(tracts)
    for dd = 1:length(MinDegree)
        count = count+1;
        classification.names{count} = sprintf('%s_Ecc%sto%s',tracts{ifg},num2str(MinDegree(dd)),num2str(MaxDegree(dd)));
        indices = find(keep.(sprintf('%s_Ecc%sto%s',tracts{ifg},num2str(MinDegree(dd)),num2str(MaxDegree(dd)))) == 1);
        cleaned_indices = tractsIndices.(tracts{ifg})(indices);
        classification.index(cleaned_indices) = count;
    end
end

% create new classification structure
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
   %fiber_count = min(1000, numel(tracts{it}.fibers));
   %tract.coords = tracts{it}.fibers(randperm(fiber_count)); 
   fiber_count = length(tracts{it}.fibers);
   tract.coords = tracts{it}.fibers;
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
