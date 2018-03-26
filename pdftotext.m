function [pdfstr] = pdftotext(filename)

% javaaddpath('C:\Users\Gauvain\Documents\MATLAB\basket\PDFBox-0.7.3\lib\PDFBox-0.7.3.jar');

%%
pdfdoc = org.apache.pdfbox.pdmodel.PDDocument;
reader = org.apache.pdfbox.util.PDFTextStripper;
pdfdoc.close;
%%
pdfdoc = pdfdoc.load(filename);
pdfdoc.isEncrypted;


%% text, with planty of padding
pdfstr = reader.getText(pdfdoc);

pdfdoc.close;

end