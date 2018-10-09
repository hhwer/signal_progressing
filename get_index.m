function [ idx,y ] = get_index( x,opts )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin < 2
    opts = struct;
end
if ~isfield(opts,'para1')
    opts.para1 = 80;
end
if ~isfield(opts,'para2')
    sam = x(1000:3000);
    opts.para2 = (max(sam)+min(sam))/2;
%     opts.para2 = 3/2*mean(x);
end
[y1,idx1] = findpeaks(x,'minpeakdistance',opts.para1,'MinPeakHeight',opts.para2);
[y2,idx2] = findpeaks(-x,'minpeakdistance',opts.para1,'MinPeakHeight',-opts.para2);

media = (median(y1)-median(y2))/2;

[y,idx] = findpeaks(x,'minpeakdistance',opts.para1,'MinPeakHeight',media);
% [y,idx] = findpeaks(x,'minpeakdistance',opts.para1,'MinPeakHeight',opts.para2);
end

