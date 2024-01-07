#!/bin/bash

# Set the maximum allowed length for a domain name (adjust as needed)
MAX_LENGTH=63

# Specify the output file name and path
OUTPUT_FILE="query_results.txt"

# Clear the existing output file or create a new one
> "$OUTPUT_FILE"

# Read each line from the domain_list.txt file
while IFS= read -r domain; do
    # Check the length of the domain name
    length=$(echo "$domain" | awk '{print length}')
    
    # If the length is within the allowed limit, perform the dig query
    if [ "$length" -le "$MAX_LENGTH" ]; then
        echo "Querying $domain"
        dig "$domain" >> "$OUTPUT_FILE"
    else
        echo "Skipping $domain (too long)"
    fi
done < text_2b_converted.txt
