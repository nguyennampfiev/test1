function YorN = check_error_file(filename)
    txt_file_error=('Users/nguyennam/Desktop/NTU/NTURGB-D/samples_with_missing_skeletons.txt');
    A=fileread(txt_file_error);
    YorN=strfind(A, filename);
end