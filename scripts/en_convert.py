import json
import os
import re

def to_psd1_value(val):
    if isinstance(val, str):
        escaped = val.replace('"', '`"')
        return f'"{escaped}"'
    elif isinstance(val, list):
        list_items = ", ".join(to_psd1_value(item) for item in val)
        return f"@({list_items})"
    elif isinstance(val, bool):
        return "$true" if val else "$false"
    elif val is None:
        return "$null"
    else:
        return str(val)

def is_safe_key(key):
    return re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*$", key)

def json_to_psd1(json_path, output_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    lines = ["@{"]
    for key, value in data.items():
        ps_key = key if is_safe_key(key) else f'"{key}"'
        ps_value = to_psd1_value(value)
        lines.append(f"    {ps_key} = {ps_value}")
    lines.append("}")

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"Converted: {json_path} -> {output_path}")

# Only convert English
json_to_psd1("l10n/en.json", "i18n/en/Gacha.Resources.psd1")
