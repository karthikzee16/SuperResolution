% choose sample set 

%sampleFiles = {'./sample1/', './sample2/', './sample3/', './sample4/', './sample5/', './sample6/', './sample7/', './sample8/', './sample9/'};

for i=1:1:9
  z=strcat('./sample', num2str(i));
  z=strcat(z, '/');
  data{i}=z;
end
scaleto 	 = [ 4 12  8  8  8  4  4  4  4];
iminsample  =  [ 4 4  30  40 20 16 15 4 30];
s 			 = [9:9];
% iterating over dataset in s
for n = s

  files = dir([data{n} '*.png']);
  imageFilenames = {files(1:iminsample(n)).name};
  imageFilenames = cellfun(@(x) [data{n} x], imageFilenames, 'UniformOutput', false);
  % scaling is handled here
  do(imageFilenames);
  % super resolution process begins 
  startSR(imageFilenames, scaleto(n));

end  
