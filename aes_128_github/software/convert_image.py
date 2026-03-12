# convert_image.py
from PIL import Image

# --- Configuration ---
INPUT_IMAGE_FILE = "pet.jpg"  # The image you want to convert
OUTPUT_MEM_FILE = "image.mem"    # The output file for Vivado
IMAGE_SIZE = (8, 8)              # The desired 8x8 size

# --- Main Script ---
try:
    # 1. Open the original image
    print(f"Opening image: {INPUT_IMAGE_FILE}...")
    img = Image.open(INPUT_IMAGE_FILE)

    # 2. Convert to grayscale and resize to 8x8
    img_gray = img.convert("L")  # 'L' mode is for 8-bit grayscale
    img_resized = img_gray.resize(IMAGE_SIZE)

    # 3. Get the pixel data
    pixels = list(img_resized.getdata())

    # 4. Write the pixel data to the .mem file in hexadecimal format
    print(f"Writing {len(pixels)} pixels to {OUTPUT_MEM_FILE}...")
    with open(OUTPUT_MEM_FILE, "w") as f:
        for i, pixel_value in enumerate(pixels):
            # Format the 8-bit decimal value (0-255) into a 2-digit hex string
            hex_value = f"{pixel_value:02x}"
            f.write(hex_value)
            
            # Add a space, or a newline every 8 pixels for readability
            if (i + 1) % 8 == 0:
                f.write("\n")
            else:
                f.write(" ")

    print("Conversion successful!")
    print(f"'{OUTPUT_MEM_FILE}' has been created and is ready for your Vivado project.")

except FileNotFoundError:
    print(f"ERROR: The file '{INPUT_IMAGE_FILE}' was not found. Make sure it's in the same directory as the script.")
except Exception as e:
    print(f"An error occurred: {e}")