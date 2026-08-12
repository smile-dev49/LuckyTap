from PIL import Image
from pathlib import Path
import json
import shutil

src = Path(r"C:\Users\Marvelous\.cursor\projects\d-Working-Mobile-App-Development\assets")
assets = Path(r"D:\Working\Mobile App Development\LuckyTap\LuckyTap\Assets.xcassets")
refs = Path(r"D:\Working\Mobile App Development\LuckyTap\DesignReferences\Home")
refs.mkdir(parents=True, exist_ok=True)

mapping = {
    "lucky_tap_logo": "lucky_tap_logo-560556d6-f42b-452b-b4fe-ea0341e5d3be.png",
    "home_mascot": "home_mascot-52b10300-ca02-456e-9fd2-7ca175e79e70.png",
    "icon_spin_wheel": "icon_spin_wheel-277ce6e6-638b-4f92-a84a-8aa532c3a0a5.png",
    "coin_icon": "coin_icon-f760313d-f842-4d2c-80ad-e221de6a908a.png",
    "home_slot_555": "home_slot_555-6ba12cb0-33bc-4388-97f1-7a505122fbee.png",
    "home_background": "home_background-84f675bf-71a9-410b-8254-7b95474afe29.png",
    "icon_missions": "icon_missions-8620ff0f-af23-4fd0-9234-ef5f048222ee.png",
    "icon_daily_reward": "icon_daily_reward-d1df3f98-483f-459c-a69e-cb23a8d2561e.png",
    "icon_lucky_bonus": "icon_lucky_bonus-1f37b742-b618-414c-bfe1-8cea3552b8c7.png",
}


def find_source(partial: str) -> Path:
    matches = list(src.glob(f"*{partial}"))
    if not matches:
        # try exact suffix match across all
        matches = [p for p in src.glob("*.png") if partial in p.name]
    if not matches:
        raise FileNotFoundError(partial)
    # prefer the longest/most specific
    matches.sort(key=lambda p: len(p.name), reverse=True)
    return matches[0]


def write_imageset(name: str, image_path: Path, is_background: bool = False):
    img = Image.open(image_path).convert("RGBA")
    print(f"{name}: {img.size} from {image_path.name}")

    # Save clean copy to DesignReferences/Home
    dest_ref = refs / f"{name}.png"
    img.save(dest_ref, "PNG")

    d = assets / f"{name}.imageset"
    if d.exists():
        shutil.rmtree(d)
    d.mkdir(parents=True)

    # For Xcode, provide 1x/2x/3x. Use original as @3x quality source.
    w, h = img.size
    variants = []
    for scale, suffix in [(1, ""), (2, "@2x"), (3, "@3x")]:
        # Keep original for @3x-ish; scale down for others based on max dimension
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
    path = find_source(partial)
    write_imageset(name, path, is_background=(name == "home_background"))

print("DONE")
