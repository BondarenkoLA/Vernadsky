function  FigureFormatBig(f,timeInterval)
%==========================================================================
% Форматирование графика ддл_ интервала времени  в виде большой картинки 
% Входные данные
%   f  - header окна
%   timeInterval -  двухмарный массив начало и конец временного интервала. 
%                   формат datanum . timeInterval(1)<timeInterval(2)
%                   название оси y переносится к левой кранице окна
%                   используя top
% Внимание!!!!
%   форматирование проводиться X оси. 
%  error =0 успешно сформатированный график
%     -1  название оси Y не поместилось
%==========================================================================


    
Param =struct('h',    1025, ...                      % структура, определ_юша_ форматируемые параметры
              'w',    1280, ...
              'XTick',12,   ...                      % восемь засечек по оси х
              'dT',   1/96+1/86400,  ...             % по умолчанию  у нас сутки=1 
              'FontSizeTitle', [16], ...             % размер шрифта заголовка
              'FontWeightTitle', 'normal', ...       % стиль шрифта заголовка
              'FontSize',      [16], ...             % размер шрифта делений по оси 
              'FontSizeXLabel', [16], ...            % размер надписи по оси x
              'FontSizeYLabel', [16], ...            % размер надписи по оси y
              'Position', [0.055    0.1100    0.85    0.8150], ...% положение и размер одного графика
              'PositionColorBar', [ 0.92    0.1067    0.0444    0.8178]);   %положение и размер ColorBar
                          
             
             
% исправление некорректности временного входного интервала    
            
if size(timeInterval,2)==1 
        timeInterval(2)=timeInterval(1)+0.1250;          % по умолчанию интервал составл_ет 3часа
end 
if timeInterval(2)<=timeInterval(1)
        timeInterval(2)=timeInterval(1)+0.1250;          % по умолчанию интервал составл_ет 3 часа
end



% установка параметров fig 


tempU=get (f, 'Units');
set (f, 'Units', 'pixels');
colormap(jet);
asi=get(f,'Children');                                      % header непосредственно всех осей
set(asi(strcmp(get(asi,'Type'),'axes')),'ActivePositionProperty','position');
set(asi(strcmp(get(asi,'Tag'),'Colorbar')),'Location','manual');    % дл_ возможности перемещения 
set (f, 'position', [40 40 Param.w Param.h]);               % Установка ширины и высоты окна 
set (f, 'Units', tempU);

for i=1:size(asi,1)
    axis xy;                                                % Установа декартовой системы координат
    xy=asi(i);
    set(get(xy,'Title'),'FontSize',Param.FontSizeTitle);    % установка размера шрифта дл_ заголовка
    set(get(xy,'Title'),'FontWeight',Param.FontWeightTitle);% установка стиля шрифта дл_ заголовка
    set(get(xy,'YLabel'),'FontSize',Param.FontSizeYLabel);  
    set(get(xy,'XLabel'),'FontSize',Param.FontSizeXLabel);   % установка размера шрифта дл_ надписи оси х
    % основное форматирование проводитьс первой оси 

    set (xy, 'Units', 'normalized');
    p=get(xy,'Position');
    set(xy,'FontSize' ,Param.FontSize);                     % установка размера фонта дл_ осей    
 
    if strcmp(get(xy,'Tag'),'legend')==1;                    % если это легенда - пропускаем
        set(xy, 'FontSmoothing', 'off');
        continue;
    end
    if strcmp(get(xy,'Tag'),'Colorbar')==1                  % данные оси относ_тс_ к ос_м ColorBar    
        p=get(asi(strcmp(get(asi,'Type'),'axes')),'Position');
        set(xy, 'Position',[Param.PositionColorBar(1) p(2) ...       % установка положение осей  только оси x
                           Param.PositionColorBar(3) p(4)]);         % Положение и размер ColorBar              
        continue    
    end    
    set(xy,'Position',[Param.Position(1) p(2) ...            % установка положение осей  только оси x
                           Param.Position(3) p(4)]);
    set(xy,'XLim',timeInterval);                             % установка границ оси х
    
    dt=(timeInterval(2)-timeInterval(1))/Param.XTick;  % при суточном интервале= 1/8
    set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick]*dt));         % установка делений по оси х
    set(xy,'XTickLabel',datestr(get(xy,'XTick'),15));               % форматирование меток оси х согласно функции datestr( ,15) т.е. чч:мм

    set(xy,'XGrid','on');                                 
                                                                                                                                                               
% смещение надписи на Y      
    yl=get(xy,'YLabel');
    set (xy, 'Units','pixels');                             % оси и метка оси должны быть 
    set(yl,'Units','pixels');                               % в одной системе измерений
    p=get(xy,'Position');
    pt=get(xy,'TightInset');  
    set(xy,'YTickLabel',get(xy,'YTickLabel'));              % этот фокус позволяет вычислить 
                                                            % свойство'TightIset' без
                                                            % подписи оси а учитывая только метки
    
    pt=get(xy,'TightInset');     
    pl=get(yl, 'Position');
    pe=get(yl,'Extent');
    set(yl,'VerticalAlignment','top', ...         % сдвигаем название оси к левой границе окна 	
                     'Position',[-p(1) pl(2) pl(3)]);
   
    set(yl,'Units','normalized');                           % без этого не будут пересчитыватьсяположения при изменении размеров окна 
    set (xy, 'Units','normalized');    
end
refresh(f);
% установки дл_ твердой копии 
% Используетс_ командой   print(f, '-r96', '-dpng', FileName) дл_  записи в файл  FileName.png 
% Установка размера и положени_ нужны дл_ получени_ точного размера картинки Param.w*Param.h в файле FileName.png 
dpi=get(0,'ScreenPixelsPerInch');                       % кол-во  pixel на дюйм на экране обычно=96
set(f, 'paperunits', 'points', ...                      % 72 point в одном дюйме
           'papersize',  [fix(Param.w*72/dpi)+1 fix(Param.h*72/dpi)+1], ...
           'paperposition', [0 0 fix(Param.w*72/dpi) fix(Param.h*72/dpi)]);
drawnow;
drawnow;






     