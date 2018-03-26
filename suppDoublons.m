function [output] = suppDoublons(input)

% supprime les doublon spossibles dans computeEcartCinq dans liste
% joueursEnJeu

input=cellfun(@num2str,input,'un',0);
input = unique(input);
output=cellfun(@str2num,input,'un',0);

end