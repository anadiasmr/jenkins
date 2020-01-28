#!/bin/bash
find "$1" -type f -iname "*" | while read line; do 
  filename=$(basename "$line")
  ln -sf "$line" "$2/$filename" && chmod +x "$2/$filename"
done 