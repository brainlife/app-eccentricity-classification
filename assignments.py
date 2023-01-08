#!/usr/bin/env python3

import os
import json
import numpy as np
from scipy.io import loadmat

def write_txt(data,out_name):

	with open(out_name,'wt') as out_file:
		out_file.write('\n'.join(data))


def extract_names(classification):

	names = classification["names"].tolist().tolist()

	return names

def extract_indices(classification):

	indices = classification["index"].tolist().tolist()

	# if np.max(indices) >= 10:
	# 	indices = [ "00"+str(f) if f < 10 else "0"+str(f) for f in indices ]

	return indices


def extract_data(classification,out_assignments,out_names):

	names = extract_names(classification)
	indices = extract_indices(classification)

	write_txt(names,out_names)
	write_txt([ str(f) for f in indices],out_assignments)


def main():
	
	# load config.json structure
	with open('config.json','r') as config_f:
		config = json.load(config_f)

	# parse inputs
	out_assignments = 'assignments.txt'
	out_names = 'names.txt'

	# load data
	classification = loadmat(config['classification'],squeeze_me=True)['classification']

	# extract indices and names and put into seperate text files
	extract_data(classification,out_assignments,out_names)

if __name__ == '__main__':
	main()