function YorN = check_error_file(filename)
    filename = filename(1:20);
    txt_file_error= '/home/nguyentiennam/test1/A/samples_with_missing_skeletons.txt';
%     txt_file_error ='/Users/nguyennam/Desktop/test1/samples_with_missing_skeletons.txt';
    A=fileread(txt_file_error);
    YorN = strfind(A, char(filename));
    if YorN
        YorN = true;
    else
        YorN =false;
    end
end