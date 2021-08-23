# Libraries required
import numpy as np
import matplotlib.pyplot as plt 
from skimage.morphology import skeletonize
import cv2
import json
from sklearn.svm import SVC
from skimage.morphology import skeletonize
import cv2
from sklearn.svm import SVC
import joblib

# Pre-processing data
def run():
    # Left data process
    file_name = './2nd_process_left_data.csv'                   # Select the second processed left data

    left_vectors = np.zeros((414,80))                           # Declare a variable for saving all of the second processed left data

    r = open(file_name, mode= 'r')                              # Open the data file
    l_lines = r.readlines()                                     # Read and overwrite file data onto new variable
    l_lines[0]

    for data in range(0,414):

            numbers = l_lines[data].split(',')                  # Save all row data separating by comma(,)

            flir_vector = []                                    # Declare new variable for saving row data
            for i in range(0,80):
                flir_vector.append(float(numbers[i]))           # Join together and save the data in row
            
            left_vectors[data,:] = np.transpose(flir_vector)    # Save all data in the final variable


    # Read the label data of lefts
    import json

    with open('2nd_process_left_label.json', 'r') as infile:
            newlist_left = json.load(infile)
            
    print(newlist_left)

    left_label = np.zeros((len(newlist_left),1))                # Syncronize dimension before appending pre-processed left label

    num = 0

    for val in newlist_left:
        left_label[num] = newlist_left[num]
        num = num + 1

    left_sign = np.zeros((len(newlist_left),1))                 # New column to distinguish that data is left

    num = 0

    for val in newlist_left:
        left_sign[num] = 0
        num = num + 1

    # Right data process
    file_name = './2nd_process_right_data.csv'                  # Select the second processed right data

    right_vectors = np.zeros((423,80))                          # Declare new variable for saving row data 

    r = open(file_name, mode= 'r')                              # Open the data file
    r_lines = r.readlines()                                     # Read and overwrite file data onto new variable
    r_lines[0]

    for data in range(0,423):

            numbers = r_lines[data].split(',')                  # Save all row data separating by comma(,)

            flir_vector = []                                    # Declare new variable for saving row data
            for i in range(0,80):
                flir_vector.append(float(numbers[i]))           # Join together and save the data in row
            
            right_vectors[data,:] = np.transpose(flir_vector)   # Save all data in the final variable


    # Read the label data of Rights
    import json

    with open('2nd_process_right_label.json', 'r') as infile:
            newlist_right = json.load(infile)
            
    print(newlist_right)

    right_label = np.zeros((len(newlist_right),1))              # Syncronize dimension before appending pre-processed Right label

    num = 0

    for val in newlist_right:
        right_label[num] = newlist_right[num]
        num = num + 1

    right_sign = np.zeros((len(newlist_right),1))               # New column to distinguish that data is right

    num = 0

    for val in newlist_right:
        right_sign[num] = 1
        num = num + 1


    # Combine all data
    import warnings                                             # A library to ignore any alert

    warnings.filterwarnings(action='ignore') 

    # Combine target, label and classified data on the left and right (414x82)
    input_left_datas1 = np.hstack((left_vectors, left_label))
    input_left_datas2 = np.hstack((input_left_datas1, left_sign))

    input_right_datas1 = np.hstack((right_vectors, right_label))
    input_right_datas2 = np.hstack((input_right_datas1, right_sign))

    # Append all left and right data vertically
    input_total_datas = np.vstack((input_right_datas2, input_left_datas2))

    np.random.shuffle(input_total_datas)

    import pandas as pd

    df = pd.DataFrame(input_total_datas[0:100,])
    df.to_csv("test_total_input.csv", mode ='w', header=None, index =None)
