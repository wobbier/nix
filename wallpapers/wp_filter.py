#!/usr/bin/env python3

import os
import shutil
from PIL import Image

TARGET_WIDTH = 5120
TARGET_HEIGHT = 1440

# Maximum acceptable upscale factor
# 1.0 = perfect match
# 1.5 = acceptable
# 2.0 = starting to look bad
MAX_UPSCALE = 1.5

IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".bmp", ".webp", ".tiff")
REJECTED_FOLDER = "_rejected"


def get_upscale_factor(width, height):
    scale_x = TARGET_WIDTH / width
    scale_y = TARGET_HEIGHT / height
    return max(scale_x, scale_y)


def evaluate_image(path):
    try:
        with Image.open(path) as img:
            width, height = img.size
    except Exception as e:
        return ("error", str(e))

    upscale = get_upscale_factor(width, height)

    megapixels = (width * height) / 1_000_000

    if upscale > MAX_UPSCALE:
        return ("reject", {
            "width": width,
            "height": height,
            "upscale": upscale,
            "mp": megapixels
        })

    return ("accept", {
        "width": width,
        "height": height,
        "upscale": upscale,
        "mp": megapixels
    })


def main():
    rejected_dir = os.path.join(os.getcwd(), REJECTED_FOLDER)
    os.makedirs(rejected_dir, exist_ok=True)

    total = accepted = rejected = 0

    for root, dirs, files in os.walk("."):
        if REJECTED_FOLDER in root:
            continue

        for file in files:
            if not file.lower().endswith(IMAGE_EXTENSIONS):
                continue

            path = os.path.join(root, file)
            total += 1

            result, info = evaluate_image(path)

            if result == "reject":
                rejected += 1
                print(f"REJECT: {file} ({info['width']}x{info['height']}) upscale={info['upscale']:.2f}")

                dest = os.path.join(rejected_dir, file)
                counter = 1
                base, ext = os.path.splitext(dest)

                while os.path.exists(dest):
                    dest = f"{base}_{counter}{ext}"
                    counter += 1

                shutil.move(path, dest)

            elif result == "accept":
                accepted += 1
                print(f"KEEP:   {file} ({info['width']}x{info['height']}) upscale={info['upscale']:.2f}")

    print("\nSUMMARY")
    print("Total:", total)
    print("Accepted:", accepted)
    print("Rejected:", rejected)


if __name__ == "__main__":
    main()
