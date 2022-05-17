#!/bin/bash

filetypes="t7"
while getopts d:f:p: flag
do
    case "${flag}" in
        d) destination_dir=${OPTARG};;
        f) filetypes=${OPTARG};;
    esac
done
echo "File types: $filetypes";
echo "Destination dir: ${destination_dir}";

source_dir=${@:$OPTIND:1}
echo "Source dir: ${source_dir}";

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

if [ ! -z "$destination_dir" ]; then
  mkdir -pv "${destination_dir}"
else
  destination_dir="${source_dir}"
fi

if [ -z "$filetypes" ]; then
  FILES=($(find "${source_dir}" -type f ))
else
  FILES=($(find "${source_dir}" -type f -regex ".*\.${filetypes}" ))
fi

# echo "Files: \"${FILES[@]}.\""

COUNTER=1
for FILE in ${FILES[@]}; do
  echo "Processing \"${FILE}\"."

  python convert_torch.py -m ${FILE} -o "${destination_dir}"

  let COUNTER++
done

let COUNTER--
echo "Processed ${COUNTER} files."

IFS=$SAVEIFS