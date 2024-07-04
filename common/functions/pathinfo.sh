pathinfo() {
  local file_path="$1"

  # Extract the directory path
  local dir_path
  dir_path=$(dirname "$file_path")

  # Extract the filename with extension
  local filename_with_ext
  filename_with_ext=$(basename "$file_path")

  # Extract the filename without extension
  local filename
  filename="${filename_with_ext%.*}"

  # Extract the file extension
  local extension
  extension="${filename_with_ext##*.}"

  # Extract the last directory name
  local last_dir_name
  last_dir_name=$(basename "$dir_path")

  # Output the results
  echo "Path: $dir_path"
  echo "Filename: $filename"
  echo "Extension: $extension"
  echo "Last Directory Name: $last_dir_name"
}