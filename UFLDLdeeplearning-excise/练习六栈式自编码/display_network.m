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
 
 % opt_normalize:是否需要归一化的参数。真：每个图像块归一化（即：每个图像块元素值除以该图像块中像素值绝对值的最大值）；
 %                                   假：整幅大图像一起归一化（即：每个图像块元素值除以整幅图像中像素值绝对值的最大值）。默认为真。
 % opt_graycolor: 该参数决定是否显示灰度图。
 %                真：显示灰度图；假：不显示灰度图。默认为真。
 % cols:   该参数决定将要显示的整幅大图像每一行中小图像块的个数。默认为A列数的均方根。
 % opt_colmajor:该参数决定将要显示的整个大图像中每个小图像块是按行从左到右依次排列，还是按列从上到下依次排列
 %              真：整个大图像由每个小图像块按列从上到下依次排列组成；
 %              假：整个大图像由每个小图像块按行从左到右依次排列组成。默认为假。
 
 warning off all  %关闭警告

 % 参数的默认值
 if ~exist('opt_normalize', 'var') || isempty(opt_normalize)
    opt_normalize= true;
 end
 
 if ~exist('opt_graycolor', 'var') || isempty(opt_graycolor)
     opt_graycolor= true;
 end

 if ~exist('opt_colmajor', 'var') || isempty(opt_colmajor)
     opt_colmajor = false;
 end
 
 % 整幅大图像或整个数据0均值化  rescale
 A = A - mean(A(:));

 if opt_graycolor, colormap(gray); end  %如果要显示灰度图，就把该图形的色图（即：colormap）设置为gray
 
 % 计算整幅大图像中每一行中小图像块的个数和第一列中小图像块的个数，即列数n和行数m  compute rows, cols
 [L M]=size(A); % M即为小图像块的总数
 sz=sqrt(L);  % 每个小图像块内像素点的行数和列数
 buf=1;         % 用于把每个小图像块隔开，即小图像块之间的缓冲区。每个小图像块的边缘都是一行和一列像素值为-1的像素点。
 if ~exist('cols', 'var') % 如变量cols不存在时
     if floor(sqrt(M))^2 ~= M        % 如果M的均方根不是整数，列数n就先暂时取值为M均方根的向右取整
         n=ceil(sqrt(M));
         while mod(M, n)~=0 && n<1.2*sqrt(M), n=n+1; end % 当M不是n的整数倍且n小于1.2倍的M均方根值时，列数n加1
         m=ceil(M/n);                                    % 行数m取值为小图像块总数M除以大图像中每一行中小图像块的个数n，再向右取整
     else
         n=sqrt(M);                  % 如果M的均方根是整数，那m和n都取值为M的均方根
         m=n;
     end
 else
     n = cols;           % 如果变量cols存在，就直接令列数n等于cols，行数m为M除以n后向右取整
     m = ceil(M/n);
 end
 
 array=-ones(buf+m*(sz+buf),buf+n*(sz+buf));%要保证每个小图像块的四周边缘都是单行和单列像素值为-1的像素点。所以得到这个目标矩阵
 
 if ~opt_graycolor  % 如果分隔区不显示黑色，而显示灰度，那就要是要保证：每个小图像块的四周边缘都是单行和单列像素值为-0.1的像素点
     array = 0.1.* array;
 end
 
 
 if ~opt_colmajor   % 如果opt_colmajor为假，即：整个大图像由每个小图像块按行从左到右依次排列组成
     k=1;            %第k个小图像块
     for i=1:m       % 行数
         for j=1:n   % 列数
             if k>M, 
                 continue; 
             end
             clim=max(abs(A(:,k)));
             if opt_normalize
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/clim; %从这可看是n是列数，m是行数
             else
                 array(buf+(i-1)*(sz+buf)+(1:sz),buf+(j-1)*(sz+buf)+(1:sz))=reshape(A(:,k),sz,sz)/max(abs(A(:)));
             end
             k=k+1;
         end
     end
 else        % 如果opt_colmajor为真，即：整个大图像由每个小图像块按列从上到下依次排列组成
     k=1;
     for j=1:n          %列数
         for i=1:m      %行数
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
 
 if opt_graycolor   % 要显示灰度图，此时每个小图像块的四周边缘都是单行和单列像素值为-1的像素点。
     h=imagesc(array,'EraseMode','none',[-1 1]); %图形的EraseMode属性设置为none：即为在该图像上不做任何擦除，直接在原来图形上绘制
 else              % 不显示灰度图，此时每个小图像块的四周边缘都是单行和单列像素值为-0.1的像素点。
     h=imagesc(array,'EraseMode','none',[-1 1]);
 end
 axis image off  %去掉坐标轴
 
 drawnow;  %刷新屏幕，使图像可一点一点地显示
 
 warning on all  %打开警告