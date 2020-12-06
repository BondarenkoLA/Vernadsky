function count=Ionogram15minAllDay(path_source, path_recipient, d, title_str )
%-----------------------------------------------------------------------------------------------------------------------
% Read data ionosonde and plot ionogramm in 15min all day
% Построение 15 минутных иогнограмм за сутки
%-----------------------------------------------------------------------------------------------------------------------
% Входные данные
%   path_source путь для файла данных,
%   path_recipient- путь для файлов png,
%   title- общая часть названия графика. Достроена датой и временем.
% Выходные данные
%   count- количество построенных- записанных графиков. При успешном завершении должно быть =60
%Пример вызова 
%   Ionogram15minAllDay('d:\\SFTP_ROOT_FOLDER\\Vernadsky\\Tmp\\', ...
%                 'd:\\SFTP_ROOT_FOLDER\\Vernadsky\\Ionosonde_Data\\', ...
%                  datenum(2020,1,31), ...
%                 'Ionosonde IPS-42 Vernadsky Geomagnetic Observatory')
%  !!!Внимание по соглашениею в БД записано, что имя файлов данных имеют вид 
%  00h00m.ion имена выходных файлов n_yyyyMMddHHmm.png
%-----------------------------------------------------------------------------------------------------------------------
% Автор Бондаренко Л.А. 2020г , алгоритм Колосков А.В.
%-----------------------------------------------------------------------------------------------------------------------
count=0;
[year month day]=datevec(d);d=datenum(year, month, day,0,0,0);
for n=1:96,     % 96 15-ти минутных файлов в сутках

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
