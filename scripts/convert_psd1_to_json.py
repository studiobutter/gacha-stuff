import os
import re
import json

def parse_psd1_to_dict(psd1_path):
    with open(psd1_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Remove outer @{ ... }
    match = re.search(r'@\s*\{(.*)\}', content, re.DOTALL)
    if not match:
        raise ValueError(f"Invalid PSD1 format in {psd1_path}")

    body = match.group(1).strip()
    result = {}
    current_key = None
    collecting_array = False
    array_values = []

    for line in body.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue

        if '=' in line and not collecting_array:
            key, value = map(str.strip, line.split('=', 1))
            key = key.strip()

            # Start of array
            if value.startswith('@('):
                collecting_array = True
                current_key = key
                array_values = []
                value = value[2:].strip()
                if value.endswith(')'):
                    # inline array
                    items = value[:-1].split(',')
                    result[key] = [item.strip(" '\"") for item in items if item.strip()]
                    collecting_array = False
                elif value:
                    array_values.append(value.strip(" '\""))
            else:
                # Scalar value
                result[key] = value.strip(" '\";")
        elif collecting_array:
            if line.endswith(');') or line.endswith(')'):
                collecting_array = False
                value = line.rstrip(');').strip(" '\"")
                if value:
                    array_values.append(value)
                result[current_key] = array_values
            else:
                array_values.append(line.strip(" '\""))

    return result


def convert_folder(input_root="i18n", output_root="crowdin"):
    os.makedirs(output_root, exist_ok=True)
    for root, dirs, files in os.walk(input_root):
        for file in files:
            if file.lower().endswith(".psd1"):
                lang = os.path.basename(root)
                path = os.path.join(root, file)
                try:
                    data = parse_psd1_to_dict(path)
                    json_path = os.path.join(output_root, f"{lang}.json")
                    with open(json_path, "w", encoding="utf-8") as out:
                        json.dump(data, out, ensure_ascii=False, indent=2)
                    print(f"✅ Converted {path} → {json_path}")
                except Exception as e:
                    print(f"❌ Failed to convert {path}: {e}")


if __name__ == "__main__":
    convert_folder()
