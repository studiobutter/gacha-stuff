import json
import os

def json_to_psd1(json_path, output_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    lines = ["@{"]
    for key, value in data.items():
        # Escape any embedded quotes inside the string
        escaped_value = value.replace('"', '`"')
        lines.append(f'    "{key}" = "{escaped_value}"')
    lines.append("}")

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"Converted: {json_path} -> {output_path}")

# Example usage:
json_to_psd1("l10n/en.json", "i18n/en/Gacha.Resources.psd1")
