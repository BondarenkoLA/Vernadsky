function err=Ionogram15min(file_name_source, file_name_recipient, title_str )
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
%   Ionogram15min('d:\\SFTP_ROOT_FOLDER\\Vernadsky\\Tmp\\00h30m.ion', _
%                 'd:\\SFTP_ROOT_FOLDER\\Vernadsky\\Ionosonde_Data\\2020\\01\\FIG\\n_202001310030.png', _
%                 'Ionosonde IPS-42 Vernadsky Geomagnetic Observatory_31/01/2020 00:30')
%-------------------------------------------------------------------------------------------------------------------------
% Автор Бондаренко Л.А. 2020г , алгоритм Колосков А.В.
%-------------------------------------------------------------------------------------------------------------------------

fid=fopen(file_name_source,'r');
if (fid==-1) err=-1; return; end; 
R=zeros(512,577);
data=zeros(577,32);

for n=1:577,
    data(n,:)=fread(fid,32,'uint16');
end;


for n=1:577,
    for k=1:32,
        for i=1:16
            c=bitshift(data(n,k),-16+i);
            if(bitand(c,1)~=0)  R((k-1)*16+i,n)=1; end;
            
        end;
    end;
end;

f=figure('Visible','off');
imagesc(1:577,1:512,R);   colormap(gray);   ylim([1 512]);  xlim([0 577]);
box on;
title(title_str);
set(gca,'XTick',1:64:577);  
set(gca,'XTickLabel',{'1.0' '1.4' '2.0' '2.8' '4.0' '5.6' '8.0' '11.3' '16.0' 'f,MHz'});
set(gca,'YTick',[65:64:500 512]);
set(gca,'YTickLabel',{'100' '200' '300' '400' '500' '600' '700' 'h,km'});
axis xy;
print(file_name_recipient,'-dpng');
%Data_Fig=imread('00h003m.png');
%imwrite(Data_Fig,'00h004m.png','Transparency',get(f,'Color'));

close(f);
clear fid; clear R; clear data;
err=0;
return ;
end

























