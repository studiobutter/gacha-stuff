import os
import json

def format_value(value):
    if isinstance(value, list):
        lines = ["    @("]
        for item in value:
            lines.append(f"        '{item}',")
        lines.append("    );")
        return "\n".join(lines)
    else:
        return f"    '{value}';"

def write_psd1(data, out_path):
    lines = ["@{"]
    for key in data:
        formatted = format_value(data[key])
        lines.append(f"    {key} = {formatted}")
    lines.append("}")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"✅ Wrote: {out_path}")

def convert_folder(json_dir="crowdin", output_root="i18n"):
    for file in os.listdir(json_dir):
        if file.endswith(".json"):
            lang = os.path.splitext(file)[0]
            json_path = os.path.join(json_dir, file)
            out_dir = os.path.join(output_root, lang)
            os.makedirs(out_dir, exist_ok=True)
            out_path = os.path.join(out_dir, "Gacha.Resources.psd1")

            try:
                with open(json_path, "r", encoding="utf-8") as f:
                    data = json.load(f)
                write_psd1(data, out_path)
            except Exception as e:
                print(f"❌ Failed to convert {json_path}: {e}")

if __name__ == "__main__":
    convert_folder()
