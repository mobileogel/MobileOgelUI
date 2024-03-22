from PIL import Image, ImageOps
from pathlib import Path
import os

def adjust_non_white_pixels(image_path, output_path):

    if os.path.exists(output_path):
        print(f"The output file '{output_path}' already exists. Skipping desaturation.")
        return
    
    # Open the image
    original_image = Image.open(image_path)

    new_image = ImageOps.grayscale(original_image)

    # Save the desaturated image
    new_image.save(output_path)


def go():
    # Specify the input and output paths
    image_folder_path = Path("/Users/guymorgenshtern/Desktop/CarletonUniversity/fyp/mobileogel-ML/lego_set_jpeg/newnew")

    # Call the function to adjust non-white pixels
    for image_path in image_folder_path.glob('*.png'):  
        path_split = str(image_path).split("/")
        print("Path Split:", path_split)
        
        file_name = path_split[-1]
        print("File Name:", file_name)

        just_dimensions = file_name.split("_")[0]
        print("Just Dimensions:", just_dimensions)

        output_path = just_dimensions + "_placeholder.jpg"
        print("Output Path:", output_path)

        adjust_non_white_pixels(image_path=image_path, output_path=output_path)

go()