% Developed by: Timothy Shih for the Nihjout Lab at Duke University
% Date: 8/15/2012
%
% Information:
%
%   This function takes the model object and outputs two arrays.
%   One contains the reaction objects and the other names of the returned
%   reaction objects.
%
% Input Parameters:
%
%   obj - The Simbiology model object, with all settings ready for
%   simulation. 
%
% Output Parameters:
%
%   reactions - a vertical vector containing the active reaction Simbiology
%   objects.
%
%   names - list of active reaction names. Corresponds to the returned 
%   reaction objects 
%
% Dependencies:
%
%   Simbiology
%
function [reactions, names] = getActiveReactions(obj)

% Create reaction object matrix to return.
x = [];

%% Get all reactions
reactionObj = get(obj, 'Reactions');

%% Loop over each reaction.
for i= 1:length(reactionObj)
    
    % Get single reaction obj
    temp = reactionObj(i);
    
    % If it is add it to matrix
    if get(temp, 'Active') == 1
        x = [x; temp];
    end
end

%% Set outputs
reactions = x;
names = get(reactions, 'Name');