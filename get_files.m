function filenames = get_files(folder_path)
listings = dir(folder_path);
unwanted = strcmp({listings.name}, '.');
unwanted = unwanted | strcmp({listings.name}, '..');
listings = listings(~unwanted);
base_filenames = {listings.name};
filenames = fullfile(folder_path, base_filenames);
