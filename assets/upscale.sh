#!/bin/sh
for file in 2x/*.png; do
    filename=$(basename "$file")
    if [ ! -f "1x/${filename}" ]; then
        echo "Removing deleted file ${file} from 2x"
        rm "2x/${filename}"
    fi
done

for file in 1x/*.png; do
    filename=$(basename "$file")
    output_file="2x/${filename}"
    if [ ! -f "$output_file" ] || [ "$file" -nt "$output_file" ]; then
        echo "Updating changed file ${file} in 2x/"
        magick "$file" -filter point -resize 200% "$output_file"
    fi
done
