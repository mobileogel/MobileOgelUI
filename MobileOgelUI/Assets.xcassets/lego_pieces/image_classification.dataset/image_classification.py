import os
import subprocess

# Path to the YOLOv5 repository
yolov5_path = '/path/to/your/yolov5'  # Change this to the actual path

# Path to the folder containing images
image_folder_path = '/path/to/your/image/folder'  # Change this to the actual path

# Path to your custom weights file
weights_path = '/path/to/your/weights.pt'  # Change this to the actual path

# Create a results folder
results_folder = 'results'
os.makedirs(results_folder, exist_ok=True)

# Run YOLOv5 detect.py for each image in the folder
for image_file in os.listdir(image_folder_path):
    if image_file.endswith(('.jpg', '.jpeg', '.png')):
        image_path = os.path.join(image_folder_path, image_file)

        # Run detect.py command
        command = f"python {os.path.join(yolov5_path, 'detect.py')} --weights {weights_path} --img-size 640 --conf 0.5 --source {image_path} --save-txt --save-conf --exist-ok"
        subprocess.run(command, shell=True)

        # Read the classification results from the generated txt file
        results_txt_path = os.path.join(yolov5_path, 'runs/detect/exp', image_file.replace('.', '_') + '.txt')
        
        if os.path.exists(results_txt_path):
            with open(results_txt_path, 'r') as file:
                lines = file.readlines()
                if lines:
                    # Extract the class and confidence from the first line
                    class_conf = lines[0].strip().split()
                    if len(class_conf) == 7:  # Ensure the expected format
                        class_name, confidence = class_conf[0], float(class_conf[1])
                        print(f"Image: {image_file}, Class: {class_name}, Confidence: {confidence}")
                        
                        # Write the results to a new text file in the results folder
                        output_txt_path = os.path.join(results_folder, image_file.replace('.', '_') + '_output.txt')
                        with open(output_txt_path, 'w') as output_file:
                            output_file.write(f"Class: {class_name}, Confidence: {confidence}")
                    else:
                        print(f"Image: {image_file}, No valid results in the txt file")
                else:
                    print(f"Image: {image_file}, No results in the txt file")
        else:
            print(f"Image: {image_file}, Txt file not found")

        # Optionally, you can move or process the results_txt_path file as needed
