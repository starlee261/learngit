 function [h, array] = display_network(A, opt_normalize, opt_graycolor, cols, opt_colmajor)
% This function visualizes filters in matrix A. Each column of A is a
% filter. We will reshape each column into a square image and visualizes
% on each cell of the visualization panel. 
% All other parameters are optional, usually you do not need to worry
% about it.
% opt_normalize:whether we need to normalize the filter so that all of
% them can have similar contrast. Default value is true.
% opt_graycolor: whether we use gray as the heat map. Default is true.
%cols: how many columns are there in the display. Default value is the
% squareroot of the number of columns in A.
% opt_colmajor: you can switch convention to row major for A. In that
% case, each row of A is a filter. Default value is false.
 
 % opt_normalize:�Ƿ���Ҫ��һ���Ĳ������棺ÿ��ͼ����һ��������ÿ��ͼ���Ԫ��ֵ���Ը�ͼ���������ֵ����ֵ�����ֵ����
 %                                   �٣�������ͼ��һ���һ��������ÿ��ͼ���Ԫ��ֵ��������ͼ��������ֵ����ֵ�����ֵ����Ĭ��Ϊ�档
 % opt_graycolor: �ò��������Ƿ���ʾ�Ҷ�ͼ��
 %                �棺��ʾ�Ҷ�ͼ���٣�����ʾ�Ҷ�ͼ��Ĭ��Ϊ�档
 % cols:   �ò���������Ҫ��ʾ��������ͼ��ÿһ����Сͼ���ĸ�����Ĭ��ΪA�����ľ�������
 % opt_colmajor:�ò���������Ҫ��ʾ��������ͼ����ÿ��Сͼ����ǰ��д������������У����ǰ��д��ϵ�����������
 %              �棺������ͼ����ÿ��Сͼ��鰴�д��ϵ�������������ɣ�
 %              �٣�������ͼ����ÿ��Сͼ��鰴�д���������������ɡ�Ĭ��Ϊ�١�
 
 warning off all  %�رվ���

 % ������Ĭ��ֵ
 if ~exist('opt_normalize', 'var') || isempty(opt_normalize)
    opt_normalize= true;
 end
 
 if ~exist('opt_graycolor', 'var') || isempty(opt_graycolor)
     opt_graycolor= true;
 end

 if ~exist('opt_colmajor', 'var') || isempty(opt_colmajor)
     opt_colmajor = false;
 end
 
 % ������ͼ�����������0��ֵ��  rescale
 A = A - mean(A(:));

 if opt_graycolor, colormap(gray); end  %���Ҫ��ʾ�Ҷ�ͼ���ͰѸ�ͼ�ε�ɫͼ������colormap������Ϊgray
 
 % ����������ͼ����ÿһ����Сͼ���ĸ����͵�һ����Сͼ���ĸ�����������n������m  compute rows, cols
 [L M]=size(A); % M��ΪСͼ��������
 sz=sqrt(L);  % ÿ��Сͼ��������ص������������
 buf=1;         % ���ڰ�ÿ��Сͼ����������Сͼ���֮��Ļ�������ÿ��Сͼ���ı�Ե����һ�к�һ������ֵΪ-1�����ص㡣
 if ~exist('cols', 'var') % �����cols������ʱ
     if floor(sqrt(M))^2 ~= M        % ���M�ľ�������������������n������ʱȡֵΪM������������ȡ��
         n=ceil(sqrt(M));
         while mod(M, n)~=0 && n<1.2*sqrt(M), n=n+1; end % ��M����n����������nС��1.2����M������ֵʱ������n��1
         m=ceil(M/n);                                    % ����mȡֵΪСͼ�������M���Դ�ͼ����ÿһ����Сͼ���ĸ���n��������ȡ��
     else
         n=sqrt(M);                  % ���M�ľ���������������m��n��ȡֵΪM�ľ�����
         m=n;
     end
 else
     n = cols;           % �������cols���ڣ���ֱ��������n����cols������mΪM����n������ȡ��
     m = ceil(M/n);
 end
 
 array=-ones(buf+m*(sz+buf),buf+n*(sz+buf));%Ҫ��֤ÿ��Сͼ�������ܱ�Ե���ǵ��к͵�������ֵΪ-1�����ص㡣���Եõ����Ŀ�����
 
 if ~opt_graycolor  % ����ָ�������ʾ��ɫ������ʾ�Ҷȣ��Ǿ�Ҫ��Ҫ��֤��ÿ��Сͼ�������ܱ�Ե���ǵ��к͵�������ֵΪ-0.1�����ص�
     array = 0.1.* array;
 end
 
 
 if ~opt_colmajor   % ���opt_colmajorΪ�٣�����������ͼ����ÿ��Сͼ��鰴�д����������������
     k=1;            %��k��Сͼ���
     for i=1:m       % ����
         for j=1:n   % ����
             if k>M, 
                 continue; 
             end
             clim=max(abs(A(:,k)));
             if opt_normalize
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/clim; %����ɿ���n��������m������
             else
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/max(abs(A(:)));
             end
             k=k+1;
         end
     end
 else        % ���opt_colmajorΪ�棬����������ͼ����ÿ��Сͼ��鰴�д��ϵ��������������
     k=1;
     for j=1:n          %����
         for i=1:m      %����
             if k>M, 
                 continue; 
             end
             clim=max(abs(A(:,k)));
             if opt_normalize
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/clim;
             else
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz);
             end
             k=k+1;
         end
     end
 end
 
 if opt_graycolor   % Ҫ��ʾ�Ҷ�ͼ����ʱÿ��Сͼ�������ܱ�Ե���ǵ��к͵�������ֵΪ-1�����ص㡣
     h=imagesc(array,'EraseMode','none',[-1 1]); %ͼ�ε�EraseMode��������Ϊnone����Ϊ�ڸ�ͼ���ϲ����κβ�����ֱ����ԭ��ͼ���ϻ���
 else              % ����ʾ�Ҷ�ͼ����ʱÿ��Сͼ�������ܱ�Ե���ǵ��к͵�������ֵΪ-0.1�����ص㡣
     h=imagesc(array,'EraseMode','none',[-1 1]);
 end
 axis image off  %ȥ��������
 
 drawnow;  %ˢ����Ļ��ʹͼ���һ��һ�����ʾ
 
 warning on all  %�򿪾���