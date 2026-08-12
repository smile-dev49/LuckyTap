from PIL import Image
from pathlib import Path
import json
import shutil

src = Path(r"C:\Users\Marvelous\.cursor\projects\d-Working-Mobile-App-Development\assets")
assets = Path(r"D:\Working\Mobile App Development\LuckyTap\LuckyTap\Assets.xcassets")
refs = Path(r"D:\Working\Mobile App Development\LuckyTap\DesignReferences\Home")
refs.mkdir(parents=True, exist_ok=True)

# Newest provided hero assets
mapping = {
    "lucky_tap_logo": "lucky_tap_logo-ef5b6587-6223-46c7-add7-7ac387124640.png",
    "home_slot_555": "home_slot_555-98c428b0-4c67-47ef-a93d-e3e5292ad71a.png",
    "home_mascot": "home_mascot-c3b67e33-6f4a-4f72-99d2-f631ed87b21e.png",
}


def find_source(partial: str) -> Path:
    matches = [p for p in src.glob("*.png") if partial in p.name]
    if not matches:
        raise FileNotFoundError(partial)
    matches.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return matches[0]


def write_imageset(name: str, image_path: Path):
    img = Image.open(image_path).convert("RGBA")
    print(f"{name}: {img.size} <- {image_path.name}")

    img.save(refs / f"{name}.png", "PNG")

    d = assets / f"{name}.imageset"
    if d.exists():
        shutil.rmtree(d)
    d.mkdir(parents=True)

    w, h = img.size
    variants = []
    for scale, suffix in [(1, ""), (2, "@2x"), (3, "@3x")]:
        if scale == 3:
            out = img
        elif scale == 2:
            out = img.resize((max(1, w * 2 // 3), max(1, h * 2 // 3)), Image.Resampling.LANCZOS)
        else:
            out = img.resize((max(1, w // 3), max(1, h // 3)), Image.Resampling.LANCZOS)
        fname = f"{name}{suffix}.png"
        out.save(d / fname, "PNG")
        variants.append((fname, f"{scale}x"))

    contents = {
        "images": [
            {"filename": variants[0][0], "idiom": "universal", "scale": "1x"},
            {"filename": variants[1][0], "idiom": "universal", "scale": "2x"},
            {"filename": variants[2][0], "idiom": "universal", "scale": "3x"},
        ],
        "info": {"author": "xcode", "version": 1},
    }
    (d / "Contents.json").write_text(json.dumps(contents, indent=2), encoding="utf-8")


for name, partial in mapping.items():
    write_imageset(name, find_source(partial))

print("DONE")
