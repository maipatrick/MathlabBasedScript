%% Code

close all



    



% Bedingungsvektor = [1, 131, 162, 163,164,165,166,167,169;
%     121, 251, 381, 400,420,421,422,423,424];
% Bedingungsvektor2 = [1, 1, 1, 1,1,1,1,1,1;
%     121, 121, 121, 121,121,121,121,122,123];
% 


ordner = dir(ueberordner);
n_dir = 1;
for d = 3:size(ordner,1)
    if ordner(d).isdir
        Geruest(n_dir).pathnametest = cellstr([char(ueberordner),'\', ordner(d).name, '\']);
        MATs = dir([char(Geruest(n_dir).pathnametest),'*.mat']);


        for e = 1:size(MATs,1)
            Geruest(n_dir).filenametest(e) = cellstr(MATs(e).name);
        end
        n_dir = n_dir+1;
        clear MATs
    end
end

for n = WCSS
    pathname = char(Geruest(n).pathnametest);
    filename = Geruest(n).filenametest;
    
    for i = WSSS
        
        tname1 = char(filename(1,i));
        tname = tname1(1:end-4);
        clear NORMAL
        load ([pathname, char(filename(1,i))], 'NORMAL');
        %%
        try
            plotmat_motrack(NORMAL, t, ti, tname, AngleNames, AxesNames, Leg, CurveType, ExpCond)
        catch
            fileID = fopen([OutputDirectory,'errors.txt'],'a');
            fprintf(fileID,'%6s',[pathname, char(filename(1,i))]);
            
            fclose(fileID);
        end
        %%
        close all
    end
end












