import os
import re
import json

def parse_psd1_to_dict(psd1_path):
    with open(psd1_path, "r", encoding="utf-8") as f:
        content = f.read()

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

            if value.startswith('@('):
                collecting_array = True
                current_key = key
                array_values = []
                value = value[2:].strip()
                if value.endswith(')'):
                    items = value[:-1].split(',')
                    result[key] = [item.strip(" '\"") for item in items if item.strip()]
                    collecting_array = False
                elif value:
                    array_values.append(value.strip(" '\""))
            else:
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


def convert_single_file(input_file="i18n/en/Gacha.Resources.psd1", output_file="l10n/en.json"):
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    try:
        data = parse_psd1_to_dict(input_file)
        with open(output_file, "w", encoding="utf-8") as out:
            json.dump(data, out, ensure_ascii=False, indent=2)
        print(f"✅ Converted {input_file} → {output_file}")
    except Exception as e:
        print(f"❌ Failed to convert {input_file}: {e}")


if __name__ == "__main__":
    convert_single_file()
# 