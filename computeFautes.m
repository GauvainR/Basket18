function [fautes] = computeFautes(data_fdm)

 for i = 1 : length(data_fdm)

    %add a space to the end of the string to allow the detection of 'P '
    data_fdm(i).ftes = strcat(data_fdm(i).ftes,{' '});

    a = strfind(data_fdm(i).ftes,'P ');
    fautes(i).P = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'P1 ');
    fautes(i).P1 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'P2 ');
    fautes(i).P2 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'P3 ');
    fautes(i).P3 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'U1 ');
    fautes(i).U1 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'U2 ');
    fautes(i).U2 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'U3 ');
    fautes(i).U3 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'T1 ');
    fautes(i).T1 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'TC ');
    fautes(i).TC = length(a{1,1});
    a = strfind(data_fdm(i).ftes,' D ');
    fautes(i).D = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'D1 ');
    fautes(i).D1 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'D2 ');
    fautes(i).D2 = length(a{1,1});
    a = strfind(data_fdm(i).ftes,'D3 ');
    fautes(i).D3 = length(a{1,1});
%     a = strfind(data_fdm(i).ftes,'GD ');
%     fautes(i).GD = length(a{1,1});

    fautes(i).lfconc = fautes(i).P1*1 +fautes(i).P2*2 + fautes(i).P3*3 + fautes(i).U1*1 + fautes(i).U2*2 + fautes(i).U3*3 + fautes(i).T1*1 + fautes(i).D1*1 + fautes(i).D2*2 + fautes(i).D3*3;
    fautes(i).nbanti = fautes(i).U1+fautes(i).U2+fautes(i).U3;
    fautes(i).nbtech = fautes(i).T1 + fautes(i).TC;
    fautes(i).nbdisqua = fautes(i).D+fautes(i).D1+fautes(i).D2+fautes(i).D3; % + fautes(i).GD
 end