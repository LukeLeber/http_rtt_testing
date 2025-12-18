#!/bin/bash

> plot-data.txt

# Base URL (no trailing slash)
BASE_URL="https://lukeleber.github.io/http_rtt_testing/fixtures"

# Number of requests per URL
REQUESTS=5

for i in $(seq -w 001 100); do
  URL="${BASE_URL}/k${i}kb.gz"
  TOTAL_TIME=0
  SIZE_TOTAL_BYTES=""

  echo "Testing: $URL"

  for j in $(seq 1 $REQUESTS); do
    # Capture total time, body size, and header size
    read -r TIME SIZE_DOWNLOAD SIZE_HEADER < <(curl -o /dev/null -s -w '%{time_total} %{size_download} %{size_header}\n' "$URL")

    TOTAL_TIME=$(echo "$TOTAL_TIME + $TIME" | bc)

    # Record total response size (headers + body) from the first successful measurement
    if [ -z "$SIZE_TOTAL_BYTES" ]; then
      if [[ "$SIZE_DOWNLOAD" =~ ^[0-9]+$ ]] && [[ "$SIZE_HEADER" =~ ^[0-9]+$ ]]; then
        SIZE_TOTAL_BYTES=$((SIZE_DOWNLOAD + SIZE_HEADER))
      fi
    fi
  done

  AVERAGE_TIME=$(echo "scale=4; $TOTAL_TIME / $REQUESTS" | bc)

  # Fallback if size couldn't be captured
  if [ -z "$SIZE_TOTAL_BYTES" ]; then
    SIZE_TOTAL_BYTES=0
  fi

  echo "Average Total Time: $AVERAGE_TIME seconds"
  echo "Total Response Size (headers + body): $SIZE_TOTAL_BYTES bytes"
  echo "------------------------------------------------------------"
  echo "$SIZE_TOTAL_BYTES $AVERAGE_TIME" >> plot-data.txt
done

gnuplot -e "set terminal png; set xlabel 'Bytes'; set ylabel 'Seconds'; set output 'chart.png'; plot 'plot-data.txt' with lines title 'Transfer time by response size'"
