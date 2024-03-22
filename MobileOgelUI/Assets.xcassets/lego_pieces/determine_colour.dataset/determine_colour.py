import math
import csv
from collections import Counter

class ColourModule:

    # consider reading in RGB values but converting them to HEX to perform all matching operations
    # HEX is linear and there for a linear range for what is considered a certain lego colour can be defined
    # this also means that we can define a linear margin of error in which we accept a pixel to be a certain colour rather than individual RGB values
    rgb_dict = {}

    def __init__(self):

        with open("lego_colours.csv", 'r', newline='') as file:
            reader = csv.reader(file)
            
            # Skip the header row
            next(reader)
            next(reader)

            for row in reader:
                if len(row) >= 5:
                    name = row[1]
                    try:
                        rgb_values = tuple(map(int, row[-3:]))
                        self.rgb_dict[rgb_values] = name
                    except ValueError:
                        # Handle non-integer values
                        print(f"Skipping row with non-integer RGB values: {row}")


    # treats color1 and color2 as iterables
    # a, b represent R of color1 and colour2 respectively and then G, then B
    # finds squared difference and sums across R, G, and B values
    # euclidean distance is then given by the sqrt of the sum
    def euclidean_distance(self, color1, color2):
        return math.sqrt(sum((a - b) ** 2 for a, b in zip(color1, color2)))

    def find_closest_color(self,input_color):
        #initialize to highest possible float
        min_distance = float('inf')
        closest_color = None

        #find smallest euclidean distance
        for color in self.rgb_dict.keys():
            distance = self.euclidean_distance(input_color, color)
            if distance < min_distance:
                min_distance = distance
                closest_color = color

        
        return self.rgb_dict.get(closest_color)




    def print_colour_rgb_pair(self):
        for rgb, name in self.rgb_dict.items():
            print(f"RGB: {rgb} => Name: {name}")


    def find_mode(self, colours):
        counter = Counter(colours)
        max_count = max(counter.values())

        mode_list = []
        for item, count in counter.items():
            print(item, count)
            if count == max_count:
                mode_list.append(item)
        
        return mode_list
    
    def _determine_ideal_sample_size(self, population, margin_of_error: float = 0.01):
        # implementation of slovins formula to determine the ideal sample size when nothing is known about the sample at hand
        # in this case we know nothing of the pixels, the distribution of colours, or the colour of the piece yet
        # the margin of error is defaulted to 5% but a more informed choice should be made that's dependent on how shadows could potentially affect
        # as well as how values in RGB can differ until the colour is substantially different

        return int(population/(1 + (population * (margin_of_error ** 2)))) + 1
    

    




