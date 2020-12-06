function  FigureFormatBig(f,timeInterval)
%==========================================================================
% �������������� ������� ���_ ��������� �������  � ���� ������� �������� 
% ������� ������
%   f  - header ����
%   timeInterval -  ���������� ������ ������ � ����� ���������� ���������. 
%                   ������ datanum . timeInterval(1)<timeInterval(2)
%                   �������� ��� y ����������� � ����� ������� ����
%                   ��������� top
% ��������!!!!
%   �������������� ����������� X ���. 
%  error =0 ������� ���������������� ������
%     -1  �������� ��� Y �� �����������
%==========================================================================


    
Param =struct('h',    1025, ...                      % ���������, �������_���_ ������������� ���������
              'w',    1280, ...
              'XTick',12,   ...                      % ������ ������� �� ��� �
              'dT',   1/96+1/86400,  ...             % �� ���������  � ��� �����=1 
              'FontSizeTitle', [16], ...             % ������ ������ ���������
              'FontWeightTitle', 'normal', ...       % ����� ������ ���������
              'FontSize',      [16], ...             % ������ ������ ������� �� ��� 
              'FontSizeXLabel', [16], ...            % ������ ������� �� ��� x
              'FontSizeYLabel', [16], ...            % ������ ������� �� ��� y
              'Position', [0.055    0.1100    0.85    0.8150], ...% ��������� � ������ ������ �������
              'PositionColorBar', [ 0.92    0.1067    0.0444    0.8178]);   %��������� � ������ ColorBar
                          
             
             
% ����������� �������������� ���������� �������� ���������    
            
if size(timeInterval,2)==1 
        timeInterval(2)=timeInterval(1)+0.1250;          % �� ��������� �������� �������_�� 3����
end 
if timeInterval(2)<=timeInterval(1)
        timeInterval(2)=timeInterval(1)+0.1250;          % �� ��������� �������� �������_�� 3 ����
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
    set(xy,'FontSize' ,Param.FontSize);                     % ��������� ������� ����� ��_ ����    
 
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
    
    dt=(timeInterval(2)-timeInterval(1))/Param.XTick;  % ��� �������� ���������= 1/8
    set(xy,'XTick',(timeInterval(1)+[0:1:Param.XTick]*dt));         % ��������� ������� �� ��� �
    set(xy,'XTickLabel',datestr(get(xy,'XTick'),15));               % �������������� ����� ��� � �������� ������� datestr( ,15) �.�. ��:��

    set(xy,'XGrid','on');                                 
                                                                                                                                                               
% �������� ������� �� Y      
    yl=get(xy,'YLabel');
    set (xy, 'Units','pixels');                             % ��� � ����� ��� ������ ���� 
    set(yl,'Units','pixels');                               % � ����� ������� ���������
    p=get(xy,'Position');
    pt=get(xy,'TightInset');  
    set(xy,'YTickLabel',get(xy,'YTickLabel'));              % ���� ����� ��������� ��������� 
                                                            % ��������'TightIset' ���
                                                            % ������� ��� � �������� ������ �����
    
    pt=get(xy,'TightInset');     
    pl=get(yl, 'Position');
    pe=get(yl,'Extent');
    set(yl,'VerticalAlignment','top', ...         % �������� �������� ��� � ����� ������� ���� 	
                     'Position',[-p(1) pl(2) pl(3)]);
   
    set(yl,'Units','normalized');                           % ��� ����� �� ����� ������������������������ ��� ��������� �������� ���� 
    set (xy, 'Units','normalized');    
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






     