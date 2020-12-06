function err=IonogramDay()
%-------------------------------------------------------------------------------------------------------------------------
% Read data ionosonde and plot ionogramm 15min  
%-------------------------------------------------------------------------------------------------------------------------
% Входные данные
%   file_name_source - имя файла данных,
%   file_name_recipient- имя файла png,
%   title- название графика.
% Выходные данные
%   0- файл был записан
%   -1- не найден файл данных
%Пример вызова
%   Ionogram15min('E:\\PROG2013\\ИОНОЗОНД\\Vernadsky\\Ionosonde_Data\\Tmp\\00h30m.ion', _
%                 'E:\\PROG2013\\ИОНОЗОНД\\Vernadsky\\Ionosonde_Data\\2020\\01\\FIG\\n_202001310030.png', _
%                 'Ionosonde IPS-42 Vernadsky Geomagnetic Observatory_31/01/2020 00:30')
%-------------------------------------------------------------------------------------------------------------------------
% Автор Бондаренко Л.А. 2020г , алгоритм Колосков А.В.
%-------------------------------------------------------------------------------------------------------------------------

% Plot digital ionogram from USRP ionosonde

% Clear workspace
clear all;

% Set file name 
TestFileName = '20201109_0000_iono.ion';

% Open file
fii = fopen(TestFileName,'rt');

% Check correct file opening
if fii~=-1

    % Read top part of header
    s01 = fgets(fii);

    % Check correct start of header
    if strcmp(s01(1:(length(s01)-1)),'HEADER')

        % Read rest top part of header if it OK
        s02 = fgets(fii);
        s03 = fgets(fii);
        s04 = fgets(fii);
        s05 = fgets(fii);
        s06 = fgets(fii);
        s07 = fgets(fii);
        s08 = fgets(fii);
        s09 = fgets(fii);
        s10 = fgets(fii);
        s11 = fgets(fii);
        s12 = fgets(fii);
        s13 = fgets(fii);

        % Check correct start of frequency array
        if strcmp(s13(1:(length(s13)-1)),'Frequency Set')

            % Read sounding frequency array
            sizeFreq = [2 Inf];
            Freq = fscanf(fii,'%f',sizeFreq);
            % Read end of header
            s14 = fgets(fii);
            s15 = fgets(fii);
            s16 = fgets(fii);
            s17 = fgets(fii);

            % Check correct start of iono array
            if strcmp(s17(1:(length(s17)-1)),'DATA')

                % Read ionogram data array 
                sizeIono = [942 Inf];
                IonoLin = fscanf(fii,'%f',sizeIono);
                % Read END footer string 
                s18 = fgets(fii);

                % Check correct file footer
                if strcmp(s18(1:(length(s18)-1)),'END')

                    % Close ionogram file
                    fclose(fii);

                    % Parsing strings and set digital parameters
                    z0 = sscanf(s07,'z0 = %f');
                    dz = sscanf(s08,'dz = %f'); 
                    Nstrob = sscanf(s09,'Nstrob = %f');
                    Nsound = sscanf(s10,'Nsound = %f');
                    Ncheaps = sscanf(s11,'Ncheaps = %f');
                    Tcheap = sscanf(s12,'Tcheap = %f');
                    DT = sscanf(s16,'TIME=%d.%d.%d %d:%d:%d');

                    % Make title
                    sTitle = [s04(15:length(s04)) s05(14:length(s05)) s16(6:(length(s16)-4)) ' LT, N = ' int2str(Nsound)];

                    % Convert Iono array to log scale
                    IonoLin = IonoLin/1e2;
                    IonoLog = 20*log10(IonoLin);

                    % Make array of sounding frequency 
                    freqs(1,:) = Freq(2,:);
                    % Make Tick arrays and limits (for plotting)
                    FrMi = min(freqs*1e6);
                    FrMa = max(freqs*1e6);
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
                    % Make heights array
                    for j=1:Nstrob
                        heights(j,1) = z0+dz*(j-1);
                    end

                    % Make figure
                    f = figure('units','pixels','outerposition',[100 100 700 700]);
                    % Plot 2.5D pcolor plot of ionogram
                    hs = pcolor(freqs,heights,IonoLog);
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
                    % title([datestr(dt,'YYYY-mm-DD HH:MM'),' ',sTIM,' ',' Num points = ',int2str(total_num)]);

                    % Make colorbar
                    cb = colorbar;
                    title(cb,'SNR [dB]');
                    % ylim([heights(ind_from) heights(ind_to)]);

                    % set out iono file name and save as png
                    ionoFileName = sprintf('%04d%02d%02d_%02d%02d_iono',DT(3),DT(2),DT(1),DT(4),DT(5));
                    print(ionoFileName,'-dpng');

                    % close ionogram figure
                    close(f);

                    end % if

                end % if

        end % if

    end % if
    
end % if
    
% close all opend files if any
fclose('all');
    