function  error=FigureFormatAverage(f,timeInterval,method)
%==========================================================================
% Форматирование графика дл_ суток  в виде средней картинки 
% Входные данные
%   f  - header окна
%   timeInterval -  двухмарный массив начало и конец временного интервала. 
%                   формат datanum . timeInterval(1)<timeInterval(2)
%   method =0   -   название оси y переносится к левой кранице окна
%                   используя top
%          =1   -   название оси y переносится к левой кранице окна
%                   используя cap      
%          =2   -   уменьшать  размер шрифта названия
%          =3   -   уменьшать размер шрифта меток на оси  
% 
%          =4   -   перенести метки оси вправо
%          =5   -   перенести название оси в качестве дегенды
%          =6   -   название оси y переносится к границе меток
%                   используя baseline
% Внимание!!!!
%   форматирование проводиться X оси. 
%  error =0 успешно сформатированный график
%     -1  название оси Y не поместилось
%==========================================================================



Param =struct('h',    450, ...                      % структура, определ_юша_ форматируемые параметры
              'w',    600, ...
              'XTick',8,   ...                      % восемь засечек по оси х
              'FontSizeTitle', [10], ...            % размер шрифта заголовка
              'FontWeightTitle', 'normal', ...      % стиль шрифта заголовка
              'FontSize', [10], ...                 % размер шрифта делений по ос_м
              'FontSizeXLabel', [10], ...           % размер надписи по оси x
              'FontSizeYLabel', [10], ...           % размер надписи по оси y
              'Position', [0.055 0.0756 0.8700 0.8778], ...% положение и размер одного графика
              'PositionColorBar', [ 0.937 0.0723 0.03 0.8778]);   %положение и размер ColorBar
             
             
if nargin <3 
    method=0;
end  
error=0;
% исправление некорректности временного входного интервала             
if size(timeInterval,2)==1 
        timeInterval(2)=timeInterval(1)+1;          % по умолчанию интервал составл_ет сутки
end 
if timeInterval(2)<=timeInterval(1)
        timeInterval(2)=timeInterval(1)+1;          % по умолчанию интервал составл_ет сутки
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
%flag_colorbar=sum(strcmp(get(asi,'Tag'),'Colorbar'));       % признак того, что один из графиков ColorBar

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
    set(xy,'FontSize' ,Param.FontSize);                      % установка размера фонта дл_ осей    
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
    
    dt=timeInterval(2)-timeInterval(1);
    if dt>2                                                 % большой временной интервал поэтому метки будут включать мес_ц и день
        dt=dt/Param.XTick*2;                                % шаг по оси х
        set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick/2]*dt));% установка делений по оси х
        temp=datestr(get(xy,'XTick'),0);                    % формат вывода меток 'dd-mmm-yyyy HH:MM:SS'
        set(xy,'XTickLabel',[temp(:,1:6) temp(:,12:17)]);   % присваивание меток в виде 'dd-mmm HH:MM'
        clear temp;
    else    
        dt=dt/Param.XTick;                                  % шаг по оси х
        set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick]*dt));% установка делений по оси х
        set(xy,'XTickLabel',datestr(get(xy,'XTick'),15));   % форматирование меток оси х согласно функции datestr( ,15) т.е. чч:мм
    end        
    set(xy,'XGrid','on');                      %    
                                                                                                                                                                  
% смещение надписи на Y      
    yl=get(xy,'YLabel');
    set (xy, 'Units','pixels');                             % оси и метка оси должны быть 
    set(yl,'Units','pixels');                               % в одной системе измерений
    p=get(xy,'Position');
    pt=get(xy,'TightInset');  
    set(xy,'YTickLabel',get(xy,'YTickLabel'));              % этот фокус позволяет вычислить 
                                                            % свойство'TightIset' без
                                                            % подписи оси а учитывая только метки
    
    pl=get(yl, 'Position');
    for j=1:1:8                                             % сдвиг производить не больше 8-ех раз 
      set(yl,'VerticalAlignment','top', ...                 % сдвигаем название оси к левой границе окна 	
                     'Position',[-p(1) pl(2) pl(3)]);
      pt=get(xy,'TightInset');     
      pl=get(yl, 'Position');
      pe=get(yl,'Extent');
      
      if pl(1)*(-1)-pe(3)>= pt(1);                          % надпись вместилась
          break;
      end    
      switch method 
           case 0
               if p(1)-pe(3)<pt(1)   
                   error=error-1;
               end    
               break;      
           case 1
              set(yl,'VerticalAlignment','cap', ...         % сдвигаем название оси к левой границе окна 	
                     'Position',[-p(1) pl(2) pl(3)]);
               break;         
           case 2
              if  get(xy,'FontSize')<8                      % уменьшать размер шрифта меток осей не меньше 6-го размера
                  method =3;
                  continue;
              end
              set(xy,'FontSize' ,get(xy,'FontSize')-1); 
           case 3
              if  get(yl,'FontSize')<8                      % уменьшать размер название оси не меньше 6-го размера                 
                  break;
              end
              set(yl,'FontSize' ,get(yl,'FontSize')-1); 
           case 4                                           % перенести метки оси вправо
              set(xy,'YAxisLocation','right');
              pt=get(xy,'TightInset');
              set(yl,'VerticalAlignment','bottom', ...
                     'Position',[-pt(1)/2 pl(2) pl(3)]);
              break;   
           case 5                                           % внести название оси в качестве легенды 
               legend(xy,get(yl,'String'));
               set(yl,'Visible','off');
               break; 
           case  6
              set(yl,'VerticalAlignment','baseline', ...         % сдвигаем название оси к меткам 	
                 'Position',[-pt(1) pl(2) pl(3)]); 
              break;             
      end
    end  
    set(yl,'Units','normalized');                           % без этого не будут пересчитыватьсяположения при изменении размеров окна 
    set(xy, 'Units','normalized');    
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
