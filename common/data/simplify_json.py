import json

# Load the original JSON file
input_file_path = 'contents.json'  # Replace with the path to your original file
output_file_path = 'simplified_contents.json'  # Replace with desired output path

# Function to simplify the JSON structure
def simplify_json(input_path, output_path):
    with open(input_path, 'r') as f:
        data = json.load(f)

    simplified_data = []
    for volume_entry in data:
        volume = volume_entry.get("volume", {})
        simplified_volume = {
            "title": volume.get("title"),
            "date": volume.get("date"),
            "id": volume.get("id"),
        }

        # Add works if not empty
        works = [work.get("work", {}) for work in volume.get("works", [])]
        if works:
            simplified_volume["works"] = works

        # Add contents if not empty
        contents = [content.get("item", {}) for content in volume.get("contents", [])]
        if contents:
            simplified_volume["contents"] = contents

        simplified_data.append(simplified_volume)

    with open(output_path, 'w') as f:
        json.dump(simplified_data, f, indent=4)
    print(f"Simplified JSON saved to {output_path}")

# Run the function
simplify_json(input_file_path, output_file_path)
