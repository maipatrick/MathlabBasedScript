function ANALOG = getAnalogChannel(FileName, ChannelName)
if ischar(ChannelName)
    M = c3dserver;
    openc3d(M,0,FileName);
    start = M.GetVideoFrame(0);
    ende = M.GetVideoFrame(1);
    IND_ADDED_MARKER = M.AddMarker;
    index2 = M.GetParameterIndex('ANALOG', 'LABELS');
    n_channels = M.GetParameterLength(index2);
    for w = 1:n_channels
        if strcmp(M.GetParameterValue(index2,w-1), ChannelName)
            ANALOG(1,:) = cell2mat(M.GetAnalogDataEx(w-1,start,ende,'1',0,0,'1'));
            break
        end
    end
    closec3d(M);
else
    M = c3dserver;
    openc3d(M,0,FileName);
    start = M.GetVideoFrame(0);
    ende = M.GetVideoFrame(1);
    index2 = M.GetParameterIndex('ANALOG', 'LABELS');
    n_channels = M.GetParameterLength(index2);
    for w = ChannelName
        
        ANALOG(1,:) = cell2mat(M.GetAnalogDataEx(w-1,start,ende,'1',0,0,'1'));
        break
    end
end

