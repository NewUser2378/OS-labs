#!/bin/bash

 
while true; do
  result=$(echo "2 * 2" | bc)  # как в условии делаем перемножение двух чисел
  echo "Result: $result"
done