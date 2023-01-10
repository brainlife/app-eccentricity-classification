function [] = classificationGenerator()

if ~isdeployed
    disp('loading path')
    addpath(genpath('/N/u/hayashis/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
    addpath(genpath('/N/u/brlife/git/wma_tools'))
end

% Load configuration file
config = loadjson('config.json')

% load tract names to sample from
fid = fopen('./names.txt');
names = textscan(fid,'%s','delimiter','\n');
names = names{1};
track_names = {};

% Set tck file path/s
disp('merging tcks')
tcks=dir('track*_parc*.tck')
for ii = 1:length(tcks)
    tmp = fgRead(tcks(ii).name);
    if length(tmp.fibers) > 0
        tmpname = split(tcks(ii).name,'_');
        parcname = tmpname{2};
        tmpname = tmpname{1};
        tmpname = split(tmpname,'track');
        tmpname = str2num(tmpname{2});
        fgPath{ii} = tcks(ii).name;
        track_names{ii} = strcat(names{tmpname},'_',parcname);
    end
end

% remove empty cells
fgPath = fgPath(~cellfun('isempty',fgPath));
track_names = track_names(~cellfun('isempty',track_names));

% create classification structure
disp(fgPath)
[mergedFG, classification]=bsc_mergeFGandClass(fgPath);
%fgWrite(mergedFG, 'track/track.tck', 'tck');

if ~exist('wmc', 'dir')
    mkdir('wmc')
end
if ~exist('wmc/tracts', 'dir')
    mkdir('wmc/tracts')
end

% Amend name of tract in classification structure
for ii = 1:length(track_names)
    classification.names{ii} = strcat(track_names{ii});
end
save('wmc/classification.mat','classification')

% split up fg again to create tracts.json
fg_classified = bsc_makeFGsFromClassification_v4(classification,mergedFG);
tracts = fg2Array(fg_classified);
%cm = parula(length(tracts));
cm = distinguishable_colors(length(tracts));
for it = 1:length(tracts)
   tract.name   = strrep(tracts{it}.name, '_', ' ');
   all_tracts(it).name = strrep(tracts{it}.name, '_', ' ');
   all_tracts(it).color = cm(it,:);
   tract.color  = cm(it,:);

   %tract.coords = tracts(it).fibers;
   %pick randomly up to 1000 fibers (pick all if there are less than 1000)
   fiber_count = length(tracts{it}.fibers);
   tract.coords = tracts{it}.fibers; 
   
   savejson('', tract, fullfile('wmc','tracts', sprintf('%i.json',it)));
   all_tracts(it).filename = sprintf('%i.json',it);
   clear tract
end

% Save json outputs
savejson('', all_tracts, fullfile('wmc/tracts/tracts.json'));

% Create and write output_fibercounts.txt file
for ii = 1 : length(fg_classified)
    name = fg_classified{ii}.name;
    num_fibers = length(fg_classified{ii}.fibers);
    
    fibercounts(ii) = num_fibers;
    tract_info{ii,1} = name;
    tract_info{ii,2} = num_fibers;
end

T = cell2table(tract_info);
T.Properties.VariableNames = {'Tracts', 'FiberCount'};

writetable(T, fullfile('wmc','output_fibercounts.txt'));

exit;
end
