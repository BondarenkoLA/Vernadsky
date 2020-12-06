function err=IonogramHour(file_name_source, file_name_recipient, title_str )
%-------------------------------------------------------------------------------------------------------------------------
% Plot digital ionogram from USRP ionosonde Hour 
%-------------------------------------------------------------------------------------------------------------------------
% Входные данные
%   file_name_source - имя файла данных,
%   file_name_recipient- имя файла png,
%   title- название графика.
% Выходные данные
%   0- файл был записан
%   -1- не найден файл данных,
%   -2- нарушен формат файла
%   -3- нарушено соглашение о названии файла по времени. В данных
%   фиксируетс_ врем_
%   
%Пример вызова
%   IonogramHour('e:\\Koloskov\\SFTP_ROOT_FOLDER\\Vernadsky\\Tmp\\20200131_2300_iono.ion',...
%                 'e:\\Koloskov\\SFTP_ROOT_FOLDER\\Vernadsky\\New_Ionosonde_Data\\2020\\01\\FIG\\20200131_2300.png',...
%                 'Ionosonde IPS-42 Vernadsky Geomagnetic Observatory_31/01/2020 23:00')
%-------------------------------------------------------------------------------------------------------------------------
% Автор Бондаренко Л.А. 2020г , алгоритм Колосков А.В.
%-------------------------------------------------------------------------------------------------------------------------



fId = fopen(file_name_source,'rt');     

if fId==-1                                              % Check correct file opening
    err=-1; return; end;

% Read top part of header

s = fgetl(fId);                     
if ~strcmp(s, 'HEADER') % Check correct start of header
    err=-2; fclose(fId); end; 

s = fgetl(fId);
s = fgetl(fId);
s = fgets(fId); sTitle=s(length('Observatory : ')+1:length(s));             % 4-а_ строка
s = fgetl(fId); 
sTitle = [sTitle s(length('Location    :')+1:length(s))];   % название в две строки, если strcat в одну
s = fgetl(fId);
z0 = fscanf(fId,'z0 = %f\n');                                               % 7-а_ строка
dz = fscanf(fId,'dz = %f\n'); 
                         % т.к. следующа_ переменна_ называетс_ также с Ns
                         % чтобы не было цикличности читаем в строку
s = fgets(fId);Nstrob = sscanf(s,'Nstrob = %f');
s = fgets(fId); Nsound = sscanf(s,'Nsound = %f');
Ncheaps = fscanf(fId,'Ncheaps = %f\n');
Tcheap = fscanf(fId,'Tcheap = %f\n');

s = fgets(fId);                     
if ~strcmp(s(1:length(s)-1), 'Frequency Set')    % Check correct block frequency
    err=-2; fclose(fId); end; 

 Freq = fscanf(fId,'%f',[2 Inf]);               % читаем массив чисел, пока невстретим символы

 [DT,count] = fscanf(fId,'END\nBEGIN\nTIME=%d.%d.%d %d:%d:%d\n');
 if count~=6 err=-2; fclose(fId); end;
 
 s=sprintf('%04d%02d%02d_%02d%02d_iono.ion',DT(3),DT(2),DT(1),DT(4),DT(5));
 if  length(file_name_source)-(strfind(file_name_source,s)-1) ~=length(s) % данные не соответствуют названию файла
     err=-3; fclose(fId); end; 

  
 
 s = fgets(fId);   
 if ~strcmp(s(1:(length(s)-1)),'DATA') err=-2; fclose(fId); end; 
           

 % Read ionogram data array 
               
 IonoLin = fscanf(fId,'%f',[942 Inf]);          % читаем массив и формируем 942 строки
                                                % Read END footer string 
 s = fgets(fId);
 if ~strcmp(s(1:(length(s)-1)),'END') err=-2; fclose(fId); end;           % Check correct file footer

                   
 fclose(fId);                                   % Close data ionogram file     
                    


% Make title
sTitle =strcat(sTitle, strcat(' LT, N = ',int2str(Nsound)));
% Make Tick arrays and limits (for plotting)
FrMi=min(Freq(2,:)*1e6);
FrMa = max(Freq(2,:)*1e6);

FrMiPlus = ceil(FrMi);
FrMaMinus = floor(FrMa);
if (FrMa-FrMi)>2e6
    if floor(FrMa)/1e6 < 11
                            XTickArr = (ceil(FrMi/1e6):(floor(FrMa)/1e6))*1e6;
    else
                            XTickArr = [ceil(FrMi/1e6):9  10:2:floor(FrMa/1e6)]*1e6;
    end
else
                        FrMiPlus = FrMi;
                        FrMaPlus = FrMa;  
                        XTickArr = linspace(FrMi,FrMa,4);
end

% Make figure
f = figure('units','pixels','outerposition',[100 100 700 700],'Visible','off');
% Plot 2.5D pcolor plot of ionogram
% Convert Iono array to log scale
% Make heights array
%heights=z0+dz*[0:Nstrob-1]';
hs=pcolor(Freq(2,:),z0+dz*[0:Nstrob-1]',20*log10(IonoLin/1e2));
% Set plot properties
ax = gca;
ax.XScale = 'log';
ax.XTick = XTickArr/1e6;
ax.XLim = [FrMiPlus/1e6 FrMaMinus/1e6];
ax.TickDir = 'both';
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.Layer = 'top';
ax.Box = 'on';
ax.FontSize = 12;
hs.EdgeColor = 'none';
% Set colormap
colormap jet;

% Make title and labels
title(sTitle);
xlabel('Freq [MHz]');
ylabel('h'' [km]');
% Make colorbar
cb = colorbar;
title(cb,'SNR [dB]');

% set out iono file name and save as png
print(file_name_recipient,'-dpng');

close(f);    
% close all opend files if any
fclose('all');
end    