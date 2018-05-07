function [connection] = simulation_setup()

    global isoctave;
    isoctave = isOctaveFcn();
    
    fileDir = fileparts(mfilename('fullpath')); % path to this m-file
    paths = fileDir;

    
    % add the correct paths depending on the architecture
    if (~isoctave)
        libDir = [fileDir, '/../libs/matlab'];
        if(strcmp(computer,'GLNXA64'))
            paths = [paths, ':', fileDir, '/matlab'];  
            paths = [paths, ':', libDir, '/linuxLibrary64Bit'];
        elseif(strcmp(computer,'GLNX8632'))
            paths = [paths, ':', fileDir, '/matlab'];  
            paths = [paths, ':', libDir, '/linuxLibrary32Bit'];
        elseif(strcmp(computer,'PCWIN'))
            paths = [paths, ';', fileDir, '/matlab'];  
            paths = [paths, ';', libDir, '/windowsLibrary32Bit'];
        elseif(strcmp(computer,'PCWIN64'))
			paths = [paths, ';', fileDir, '/matlab'];  
            paths = [paths, ';', libDir, '/windowsLibrary64Bit'];
        elseif(strcmp(computer,'MACI64'))
			paths = [paths, ':', fileDir, '/matlab'];  
            paths = [paths, ':', libDir, '/macLibrary'];    
        else
            error('Not supported operation system detected');
        end
    else
        libDir = [fileDir, '/../libs/octave'];
        if(strcmp(computer,'x86_64-pc-linux-gnu'))
            paths = [paths, ':', fileDir, '/octave'];  
            paths = [paths, ':', libDir, '/linuxLibrary64Bit'];
            octFile = strcat(libDir, '/linuxLibrary64Bit');
        elseif(strcmp(computer,'i686-pc-linux-gnu') || strcmp(computer,'i586-pc-linux-gnu'))
            paths = [paths, ':', fileDir, '/octave'];  
            paths = [paths, ':', libDir, '/linuxLibrary32Bit'];
            octFile = strcat(libDir, '/linuxLibrary32Bit');
        elseif(ispc())
            paths = [paths, ';', fileDir, '/octave'];  
            paths = [paths, ';', libDir, '/windowsLibrary'];
            octFile = strcat(libDir, '/windowsLibrary');
        elseif(ismac())
            paths = [paths, ':', fileDir, '/octave'];  
            paths = [paths, ':', libDir, '/macLibrary'];
            octFile = strcat(libDir, '/macLibrary');
        else
            error('Not supported operation system detected');
        end
    end

    addpath( paths );
        
        
    if (isoctave)
        connection.vrep = remApiSetup(strcat(octFile, '/remApi.oct'));
    else
        connection.vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    end

end

function in = isOctaveFcn ()
    persistent inout;

    if isempty(inout),
        inout = exist('OCTAVE_VERSION','builtin') ~= 0;
    end;
    in = inout;
end