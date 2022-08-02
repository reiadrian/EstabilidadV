clear
clc
load('kk.mat')
load('Kglob.mat')
n = size(kk,1);
for i = 1:n
   A = kk(:,i)-KGlob(:,i); 
end
f = sum(sum(KGlob))- sum(sum(kk))
% load('kkcon.mat')
% load('Kgcon.mat')
% n = size(kk,1);
% for i = 1:n
%    A = kk(:,i)-KGcon(:,i); 
% end
% 
% f = sum(sum(KGcon))- sum(sum(kk))