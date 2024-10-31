function F = readinzebrisforce(file)

s = xml2struct(file);
%%
T = s.measurement.movements.movement.clips.clip{1,1}.data.quant;
DBegin = str2num(s.measurement.movements.movement.clips.clip{1,1}.begin.Text)
Freq = str2num(s.measurement.movements.movement.clips.clip{1,1}.frequency.Text)
dbefore = round(DBegin*Freq)-1
nframes = length(T);
S = zeros(160,64,nframes);

sensors_size_x = str2num(s.measurement.movements.movement.clips.clip{1,1}.cell_size.x.Text)/10; %in cm
sensors_size_y = str2num(s.measurement.movements.movement.clips.clip{1,1}.cell_size.y.Text)/10; % in cm
sensors_area = sensors_size_x*sensors_size_y; %in cm²

D{1,nframes} = [];
F = zeros(1,nframes);

for i = 1:nframes
    FBegin.X(i) = str2num(s.measurement.movements.movement.clips.clip{1,1}.data.quant{i}.cell_begin.x.Text);
    FBegin.Y(i) = str2num(s.measurement.movements.movement.clips.clip{1,1}.data.quant{i}.cell_begin.y.Text);
    FCount.X(i) = str2num(s.measurement.movements.movement.clips.clip{1,1}.data.quant{i}.cell_count.x.Text);
    FCount.Y(i) = str2num(s.measurement.movements.movement.clips.clip{1,1}.data.quant{i}.cell_count.y.Text);
    D{i} = str2num(s.measurement.movements.movement.clips.clip{1,1}.data.quant{i}.cells.Text);
    
    S(FBegin.Y(i):FBegin.Y(i) + FCount.Y(i) - 1,   FBegin.X(i): FBegin.X(i) + FCount.X(i) - 1, i) = D{i}(end:-1:1,:);
    F(i) = sum(sum(S(:,:,i).*sensors_area));
end
F = [zeros(1,dbefore), F];
 


