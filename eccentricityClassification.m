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
MinDegree = [str2num(config.MinDegree)];
MaxDegree = [str2num(config.MaxDegree)];
wbFG = {fullfile(config.track)}

for dd = 1:length(MinDegree)
    eccen.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd)))) = ...
        bsc_loadAndParseROI(fullfile(sprintf('Ecc%sto%s.nii.gz',num2str(MinDegree(dd)),num2str(MaxDegree(dd)))));
end

[mergedFG, pre_classification]=bsc_mergeFGandClass(wbFG);
pre_fg_classified = bsc_makeFGsFromClassification_v4(pre_classification,wbFG{:});

% need to edit this for loop for multiple tracts in classification (i.e.
% both left and right hemisphere OR, or OT and OR, etc). currently works
% with one tract at a time
for ifg = 1:length(pre_fg_classified)
    for dd = 1:length(MinDegree)
        [~, keep.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd))))] = ...
            wma_SegmentFascicleFromConnectome(pre_fg_classified{ifg}, ...
            [{eccen.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd))))} ],...
            {'endpoints' }, 'dud');
        keep.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd)))) = ...
            keep.(sprintf('Ecc%sto%s',num2str(MinDegree(dd)),num2str(MaxDegree(dd)))) * dd;
    end
end

index_pre = [keep.(sprintf('Ecc%sto%s',num2str(MinDegree(1)),num2str(MaxDegree(1)))) ...
    keep.(sprintf('Ecc%sto%s',num2str(MinDegree(2)),num2str(MaxDegree(2)))) ...
    keep.(sprintf('Ecc%sto%s',num2str(MinDegree(3)),num2str(MaxDegree(3))))];

for ii = 1:length(index_pre)
    if isequal(median(index_pre(ii,:)),0)
        index(ii) = max(index_pre(ii,:));
    elseif isequal(median(index_pre(ii,:)),2) && isequal(min(index_pre(ii,:)),1)
        index(ii) = min(index_pre(ii,:));
    elseif isequal(median(index_pre(ii,:)),2) || isequal(median(index_pre(ii,:)),1)
        index(ii) = median(index_pre(ii,:));
    end
end

classification = [];
classification.index = index';

% create new classification structure
classification.names = {'macular','periphery','far_periphery'};
fg_classified = bsc_makeFGsFromClassification_v4(classification,wbFG{:});

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
