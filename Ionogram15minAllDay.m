function count=Ionogram15minAllDay(path_source, path_recipient, d, title_str )
%-----------------------------------------------------------------------------------------------------------------------
% Read data ionosonde and plot ionogramm in 15min all day
% ���������� 15 �������� ���������� �� �����
%-----------------------------------------------------------------------------------------------------------------------
% ������� ������
%   path_source ���� ��� ����� ������,
%   path_recipient- ���� ��� ������ png,
%   title- ����� ����� �������� �������. ��������� ����� � ��������.
% �������� ������
%   count- ���������� �����������- ���������� ��������. ��� �������� ���������� ������ ���� =60
%������ ������ 
%   Ionogram15minAllDay('d:\\SFTP_ROOT_FOLDER\\Vernadsky\\Tmp\\', ...
%                 'd:\\SFTP_ROOT_FOLDER\\Vernadsky\\Ionosonde_Data\\', ...
%                  datenum(2020,1,31), ...
%                 'Ionosonde IPS-42 Vernadsky Geomagnetic Observatory')
%  !!!�������� �� ����������� � �� ��������, ��� ��� ������ ������ ����� ��� 
%  00h00m.ion ����� �������� ������ n_yyyyMMddHHmm.png
%-----------------------------------------------------------------------------------------------------------------------
% ����� ���������� �.�. 2020� , �������� �������� �.�.
%-----------------------------------------------------------------------------------------------------------------------
count=0;
[year month day]=datevec(d);d=datenum(year, month, day,0,0,0);
for n=1:96,     % 96 15-�� �������� ������ � ������

    file_name_source=strcat(path_source,sprintf('%2sh%2sm.ion',datestr(d,'hh'),datestr(d,'MM')));
    file_name_recipient=strcat(path_recipient,sprintf('%04d\\\\%02d\\\\FIG\\\\n_%s.png', ...
        year,month,datestr(d,'yyyymmddhhMM')));
    title =strcat(title_str,datestr(d,' dd/mm/yyyy hh:MM'));

    if Ionogram15min(file_name_source, ...
                     file_name_recipient, ...
                     title)==0 
       count=count+1;
        
    end;
    d=d+minutes(15);
end;
