% Add paths
dir_ = fileparts(mfilename('fullpath'));
found_ = false;
for i = 1:3
    commonDir_ = fullfile(fileparts(dir_), 'common');
    commonVrepDir_ = fullfile(commonDir_, 'vrep');
    if exist(commonDir_, 'file') && exist(commonVrepDir_, 'file')
        addpath(genpath(dir_));
        addpath(commonDir_);
        addpath(commonVrepDir_);
	found_ = true;
	break;
    end
    dir_ = fileparts(dir_);
end

if not(found_)
	error('Could not find exercises'' common folder!');
end
clear dir_ commonDir_ commonVrepDir_ found_;
