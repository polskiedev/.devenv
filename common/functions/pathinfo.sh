pathinfo() {
    echo "pathinfo()"
#   local file_path="$1"

#   # Extract the directory path
#   local dir_path
#   dir_path=$(dirname "$file_path")

#   # Extract the filename with extension
#   local filename_with_ext
#   filename_with_ext=$(basename "$file_path")

#   # Extract the filename without extension
#   local filename
#   filename="${filename_with_ext%.*}"

#   # Extract the file extension
#   local extension
#   extension="${filename_with_ext##*.}"

#   # Extract the last directory name
#   local last_dir_name
#   last_dir_name=$(basename "$dir_path")

#   # Output the results
#   echo "Path: $dir_path"
#   echo "Filename: $filename"
#   echo "Extension: $extension"
#   echo "Last Directory Name: $last_dir_name"
}

# pathinfo() {
#     local filepath="$1"
#     declare -A info

#     info["dirname"]="$(dirname "$filepath")"
#     info["basename"]="$(basename "$filepath")"
#     info["extension"]="${filepath##*.}"
#     info["filename"]="$(basename "$filepath" .${filepath##*.})"
    
#     # Return associative array
#     echo "$(declare -p pathinfo_data)"
# }

# show_pathinfo() {
#     eval "$(pathinfo "$1")"
#     local -n path_info="$pathinfo_data"

#     for key in "${!path_info[@]}"; then
#       echo "$key: ${path_info[$key]}"
#     done
# }