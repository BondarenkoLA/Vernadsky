function  error=FigureFormatAverage(f,timeInterval,method)
%==========================================================================
% �������������� ������� ��_ �����  � ���� ������� �������� 
% ������� ������
%   f  - header ����
%   timeInterval -  ���������� ������ ������ � ����� ���������� ���������. 
%                   ������ datanum . timeInterval(1)<timeInterval(2)
%   method =0   -   �������� ��� y ����������� � ����� ������� ����
%                   ��������� top
%          =1   -   �������� ��� y ����������� � ����� ������� ����
%                   ��������� cap      
%          =2   -   ���������  ������ ������ ��������
%          =3   -   ��������� ������ ������ ����� �� ���  
% 
%          =4   -   ��������� ����� ��� ������
%          =5   -   ��������� �������� ��� � �������� �������
%          =6   -   �������� ��� y ����������� � ������� �����
%                   ��������� baseline
% ��������!!!!
%   �������������� ����������� X ���. 
%  error =0 ������� ���������������� ������
%     -1  �������� ��� Y �� �����������
%==========================================================================



Param =struct('h',    450, ...                      % ���������, �������_���_ ������������� ���������
              'w',    600, ...
              'XTick',8,   ...                      % ������ ������� �� ��� �
              'FontSizeTitle', [10], ...            % ������ ������ ���������
              'FontWeightTitle', 'normal', ...      % ����� ������ ���������
              'FontSize', [10], ...                 % ������ ������ ������� �� ��_�
              'FontSizeXLabel', [10], ...           % ������ ������� �� ��� x
              'FontSizeYLabel', [10], ...           % ������ ������� �� ��� y
              'Position', [0.055 0.0756 0.8700 0.8778], ...% ��������� � ������ ������ �������
              'PositionColorBar', [ 0.937 0.0723 0.03 0.8778]);   %��������� � ������ ColorBar
             
             
if nargin <3 
    method=0;
end  
error=0;
% ����������� �������������� ���������� �������� ���������             
if size(timeInterval,2)==1 
        timeInterval(2)=timeInterval(1)+1;          % �� ��������� �������� �������_�� �����
end 
if timeInterval(2)<=timeInterval(1)
        timeInterval(2)=timeInterval(1)+1;          % �� ��������� �������� �������_�� �����
end 

% ��������� ���������� fig 


tempU=get (f, 'Units');
set (f, 'Units', 'pixels');
colormap(jet);
asi=get(f,'Children');                                      % header ��������������� ���� ����
set(asi(strcmp(get(asi,'Type'),'axes')),'ActivePositionProperty','position');
set(asi(strcmp(get(asi,'Tag'),'Colorbar')),'Location','manual');    % ��_ ����������� ����������� 
set (f, 'position', [40 40 Param.w Param.h]);               % ��������� ������ � ������ ���� 
set (f, 'Units', tempU);
%flag_colorbar=sum(strcmp(get(asi,'Tag'),'Colorbar'));       % ������� ����, ��� ���� �� �������� ColorBar

for i=1:size(asi,1)
    axis xy;                                                % �������� ���������� ������� ���������
    xy=asi(i);
    set(get(xy,'Title'),'FontSize',Param.FontSizeTitle);    % ��������� ������� ������ ��_ ���������
    set(get(xy,'Title'),'FontWeight',Param.FontWeightTitle);% ��������� ����� ������ ��_ ���������
    set(get(xy,'YLabel'),'FontSize',Param.FontSizeYLabel);  
    set(get(xy,'XLabel'),'FontSize',Param.FontSizeXLabel);   % ��������� ������� ������ ��_ ������� ��� �
    % �������� �������������� ���������� ������ ��� 
     
    set (xy, 'Units', 'normalized');
    p=get(xy,'Position');
    set(xy,'FontSize' ,Param.FontSize);                      % ��������� ������� ����� ��_ ����    
    if strcmp(get(xy,'Tag'),'legend')==1;                    % ���� ��� ������� - ����������
        set(xy, 'FontSmoothing', 'off');
        continue;
    end
    if strcmp(get(xy,'Tag'),'Colorbar')==1                  % ������ ��� �����_��_ � ��_� ColorBar
        p=get(asi(strcmp(get(asi,'Type'),'axes')),'Position');
        set(xy, 'Position',[Param.PositionColorBar(1) p(2) ...       % ��������� ��������� ����  ������ ��� x
                           Param.PositionColorBar(3) p(4)]);         % ��������� � ������ ColorBar            
        continue    
    end    
    set(xy,'Position',[Param.Position(1) p(2) ...            % ��������� ��������� ����  ������ ��� x
                           Param.Position(3) p(4)]);
    set(xy,'XLim',timeInterval);                             % ��������� ������ ��� �
    
    dt=timeInterval(2)-timeInterval(1);
    if dt>2                                                 % ������� ��������� �������� ������� ����� ����� �������� ���_� � ����
        dt=dt/Param.XTick*2;                                % ��� �� ��� �
        set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick/2]*dt));% ��������� ������� �� ��� �
        temp=datestr(get(xy,'XTick'),0);                    % ������ ������ ����� 'dd-mmm-yyyy HH:MM:SS'
        set(xy,'XTickLabel',[temp(:,1:6) temp(:,12:17)]);   % ������������ ����� � ���� 'dd-mmm HH:MM'
        clear temp;
    else    
        dt=dt/Param.XTick;                                  % ��� �� ��� �
        set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick]*dt));% ��������� ������� �� ��� �
        set(xy,'XTickLabel',datestr(get(xy,'XTick'),15));   % �������������� ����� ��� � �������� ������� datestr( ,15) �.�. ��:��
    end        
    set(xy,'XGrid','on');                      %    
                                                                                                                                                                  
% �������� ������� �� Y      
    yl=get(xy,'YLabel');
    set (xy, 'Units','pixels');                             % ��� � ����� ��� ������ ���� 
    set(yl,'Units','pixels');                               % � ����� ������� ���������
    p=get(xy,'Position');
    pt=get(xy,'TightInset');  
    set(xy,'YTickLabel',get(xy,'YTickLabel'));              % ���� ����� ��������� ��������� 
                                                            % ��������'TightIset' ���
                                                            % ������� ��� � �������� ������ �����
    
    pl=get(yl, 'Position');
    for j=1:1:8                                             % ����� ����������� �� ������ 8-�� ��� 
      set(yl,'VerticalAlignment','top', ...                 % �������� �������� ��� � ����� ������� ���� 	
                     'Position',[-p(1) pl(2) pl(3)]);
      pt=get(xy,'TightInset');     
      pl=get(yl, 'Position');
      pe=get(yl,'Extent');
      
      if pl(1)*(-1)-pe(3)>= pt(1);                          % ������� ����������
          break;
      end    
      switch method 
           case 0
               if p(1)-pe(3)<pt(1)   
                   error=error-1;
               end    
               break;      
           case 1
              set(yl,'VerticalAlignment','cap', ...         % �������� �������� ��� � ����� ������� ���� 	
                     'Position',[-p(1) pl(2) pl(3)]);
               break;         
           case 2
              if  get(xy,'FontSize')<8                      % ��������� ������ ������ ����� ���� �� ������ 6-�� �������
                  method =3;
                  continue;
              end
              set(xy,'FontSize' ,get(xy,'FontSize')-1); 
           case 3
              if  get(yl,'FontSize')<8                      % ��������� ������ �������� ��� �� ������ 6-�� �������                 
                  break;
              end
              set(yl,'FontSize' ,get(yl,'FontSize')-1); 
           case 4                                           % ��������� ����� ��� ������
              set(xy,'YAxisLocation','right');
              pt=get(xy,'TightInset');
              set(yl,'VerticalAlignment','bottom', ...
                     'Position',[-pt(1)/2 pl(2) pl(3)]);
              break;   
           case 5                                           % ������ �������� ��� � �������� ������� 
               legend(xy,get(yl,'String'));
               set(yl,'Visible','off');
               break; 
           case  6
              set(yl,'VerticalAlignment','baseline', ...         % �������� �������� ��� � ������ 	
                 'Position',[-pt(1) pl(2) pl(3)]); 
              break;             
      end
    end  
    set(yl,'Units','normalized');                           % ��� ����� �� ����� ������������������������ ��� ��������� �������� ���� 
    set(xy, 'Units','normalized');    
end
refresh(f);
% ��������� ��_ ������� ����� 
% �����������_ ��������   print(f, '-r96', '-dpng', FileName) ��_  ������ � ����  FileName.png 
% ��������� ������� � ��������_ ����� ��_ ��������_ ������� ������� �������� Param.w*Param.h � ����� FileName.png 
dpi=get(0,'ScreenPixelsPerInch');                       % ���-��  pixel �� ���� �� ������ ������=96
set(f, 'paperunits', 'points', ...                      % 72 point � ����� �����
           'papersize',  [fix(Param.w*72/dpi)+1 fix(Param.h*72/dpi)+1], ...
           'paperposition', [0 0 fix(Param.w*72/dpi) fix(Param.h*72/dpi)]);
drawnow;
drawnow;
