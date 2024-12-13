#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 -rng <rng_file> -dir <input_directory> -o <output_file>"
  exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -rng)
      RNG_FILE="$2"
      shift 2
      ;;
    -dir)
      INPUT_DIR="$2"
      shift 2
      ;;
    -o)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate arguments
if [[ -z "$RNG_FILE" || -z "$INPUT_DIR" || -z "$OUTPUT_FILE" ]]; then
  echo "Error: Missing required arguments."
  usage
fi

if [[ ! -f "$RNG_FILE" ]]; then
  echo "Error: RNG file $RNG_FILE does not exist."
  exit 1
fi

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Error: Directory $INPUT_DIR does not exist."
  exit 1
fi

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Process each XML file in the input directory
for XML_FILE in "$INPUT_DIR"/*.xml; do
  if [[ -f "$XML_FILE" ]]; then
    echo "Processing $XML_FILE..." >> "$OUTPUT_FILE"

    # Run xmllint with --xinclude and validate using jing with process substitution
    jing "$RNG_FILE" <(xmllint --xinclude "$XML_FILE" 2>> "$OUTPUT_FILE") 2>> "$OUTPUT_FILE"

    echo "Done processing $XML_FILE" >> "$OUTPUT_FILE"
    echo "--------------------------" >> "$OUTPUT_FILE"
  fi
done

echo "Validation complete. Errors logged to $OUTPUT_FILE."
