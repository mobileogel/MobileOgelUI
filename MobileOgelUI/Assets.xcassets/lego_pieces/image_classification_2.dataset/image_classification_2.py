import torch
from pathlib import Path
from PIL import Image, ImageFilter
import argparse
import pandas
import random
import math
from determine_colour import ColourModule


import os
block_detected = {}
def rename_file(file_path, block_dim, colour):
    directory, filename = os.path.split(file_path)

    name, extension = os.path.splitext(filename)

    colour_for_naming = colour.replace(" ", "_")
    new_filename = f"{block_dim}_{colour_for_naming}{extension}"
    if new_filename in block_detected:
        block_detected.update({new_filename: block_detected[new_filename] + 1})
    else: 
        block_detected.update({new_filename: 1})
    numbered_filename = f"{block_dim}_{colour_for_naming}{block_detected[new_filename]}{extension}"
    current_filepath = os.path.join(directory, filename)
    new_filepath = os.path.join(directory, numbered_filename)

    
    os.rename(current_filepath, new_filepath)

def _build_probability_gradient(img, results, gradient_interval: int = 0.10):

    left_boundary = results["xmin"]
    right_boundary = results["xmax"]

    up_boundary = results["ymin"]
    down_boundary = results["ymax"]

    height_interval = int((results["ymax"] - results["ymin"] ) * (gradient_interval/2))
    width_interval = int((results["xmax"]  - results["xmin"] ) * (gradient_interval/2))

    pixel_list = []
    for i in range( int(1/gradient_interval) ):

        # Define the coordinates of the left rectangle (left, upper, right, lower)
        left_rectangle = (left_boundary, up_boundary, left_boundary + width_interval, down_boundary)

        # Crop the image to the specified rectangle
        left_pixels = img.crop(left_rectangle)

        # Get the RGB values of all pixels in the rectangle
        pixel_values = list(left_pixels.getdata())
        pixel_values = pixel_values * (i + 1)
        pixel_list.extend(pixel_values)

        
        #right rectangle
        right_rectangle = (right_boundary - width_interval, up_boundary, right_boundary, down_boundary)
       
        right_pixels = img.crop(right_rectangle)

        pixel_values = list(right_pixels.getdata())
        pixel_values = pixel_values * (i + 1)
        pixel_list.extend(pixel_values)

        
        #upper rectangle
        upper_rectangle = (left_boundary + width_interval, up_boundary, right_boundary - width_interval, up_boundary + height_interval)

        
        upper_pixels = img.crop(upper_rectangle)


        pixel_values = list(upper_pixels.getdata())
        pixel_values = pixel_values * (i + 1)
        pixel_list.extend(pixel_values)

        #lower rectangle
        lower_rectangle = (left_boundary + width_interval, down_boundary - height_interval, right_boundary - width_interval, down_boundary)

        
        lower_pixels = img.crop(lower_rectangle)


        pixel_values = list(lower_pixels.getdata())
        pixel_values = pixel_values * (i + 1)
        pixel_list.extend(pixel_values)

        left_boundary = left_boundary + width_interval
        right_boundary = right_boundary - width_interval

        up_boundary = up_boundary + height_interval
        down_boundary = down_boundary - height_interval


    
    # print(pixel_list)
    return pixel_list

        

def determine_colour_random_sample(img, results, sample_rate: int = 0.05):

    cm = ColourModule()

    print(f'results in colour sampler: {results}' )
    num_pixels_to_sample = cm._determine_ideal_sample_size(int((results["xmax"] - results["xmin"]) * (results["ymax"] - results["ymin"])))
    print("box size " + str(int((results["xmax"] - results["xmin"]) * (results["ymax"] - results["ymin"]))))
    print("Sampling {} pixels".format(num_pixels_to_sample))

    blurred_image = img.filter(ImageFilter.GaussianBlur(radius=5))

    all_colours_with_probability_gradient = _build_probability_gradient(blurred_image, results)
    print("gradient size: " + str(len(all_colours_with_probability_gradient)))
    closest_colour_list = []
    for i in range(num_pixels_to_sample):
        # rand_x = random.randint(math.ceil(results["xmin"] ) - 1, math.floor(results["xmax"] ) - 1)
        # rand_y = random.randint(math.ceil(results["ymin"] ) - 1, math.floor(results["ymax"] ) - 1)

        # rgba = blurred_image.getpixel((rand_x, rand_y))

        random_index = random.randint(0, len(all_colours_with_probability_gradient)-1)

        rgba = all_colours_with_probability_gradient[random_index]
        colour = cm.find_closest_color(rgba)
        closest_colour_list.append(colour)
        #print(f"RGBA values at pixel ({rand_x}, {rand_y}): {rgba}, closest colour: {colour} ")

        #print(closest_colour_list)

    return cm.find_mode(closest_colour_list)




def load_yolov5_model(weights):
    # Load YOLOv5 model
   # model = torch.hub.load('ultralytics/yolov5:v5.0', 'custom', path=weights)
    model = torch.hub.load('yolov5', 'custom', weights, source='local') 
    #model = torch.hub.load('ultralytics/yolov5:master', 'yolov5s', weights, force_reload=True)

    #model = torch.hub.load('.', 'custom', path='yolov5s.pt', source='local')
    return model

def infer_images(model, image_folder):
    image_folder_path = Path(image_folder)
    print(image_folder_path)

    # Iterate through images in the folder
    for image_path in image_folder_path.glob('*.jpg'):  
        img = Image.open(image_path)

    for image_path in image_folder_path.glob('*.jpg'):  # Adjust the pattern based on your image format
        
        img = Image.open(image_path)

        results = model(img)

        # print("JUST results " + str(results))
        # print("xyxy " + str(results.xyxy))
        # print("results.pandas.xyxy" + str(results.pandas().xyxy))
        # print("results.pandas.xyxy[0]" + str(results.pandas().xyxy[0]))
        # 

        print(results.xyxy[0])
        if len(results.xyxy[0]) > 0:
            for i in range(len(results.xyxy[0])):
                print("results.xyxy[0][i]" + str(results.xyxy[0][i]))
                class_index = int(results.xyxy[0][i][-1])
                class_name = model.names[class_index]

                print(f'class name: {class_name}')
                print(f'results.pandas().xyxy[0]: {results.pandas().xyxy[0]}')
                # Print the result
                closest_colour = determine_colour_random_sample(img, results.pandas().xyxy[0].iloc[i])
                print(f"Image: {image_path.name}, Predicted Class: {class_name}, Closest Colour: {closest_colour}")
                print("----------------------\n\n")
               # print(results.pandas().xyxy[0])
                #print(results.pandas().xyxy[0]["class"])
                print("\n\n----------------------\n")
                if len(results.xyxy[0]) == 1:
                    rename_file(image_path, class_name, closest_colour[0])
        else:
            print(f"Image: {image_path.name}, No detections")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='YOLOv5 Inference on Images')
    parser.add_argument('--weights', type=str, required=True, help='Path to YOLOv5 weights file')
    parser.add_argument('--image_folder', type=str, required=True, help='Path to folder containing images')
    
    args = parser.parse_args()

    # Load YOLOv5 model with specified weights
    yolov5_model = load_yolov5_model(args.weights)

    # Run inference on images in the specified folder
    infer_images(yolov5_model, args.image_folder)



#python3 image_classification_2.py --weights best.pt --image_folder /Users/guymorgenshtern/Desktop/CarletonUniversity/fyp/mobileogel-ML/lego_set_jpeg/images
