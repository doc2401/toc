#!/bin/bash

for parent in */; do
  parent=${parent%/}

  for child in "$parent"/*/; do
    [ -d "$child" ] || continue
    child_name=${child%/}
    child_name=${child_name##*/}
    target="00.$parent.$child_name"
    mkdir "$target"
    mv "$child" "$target/"
  done

  rmdir "$parent"
done
