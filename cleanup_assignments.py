#!/usr/bin/env python3

import os
import json
import numpy as np
from scipy.io import loadmat
import glob
import pandas as pd

def write_txt(data,out_name):

	with open(out_name,'wt') as out_file:
		out_file.write('\n'.join(data))

def identify_both_endpoints(data):
	
	return data.apply(lamda x: x[0] if x[0] == x[1] else 0, axis='columns').tolist())

def load_assignment_data(assignment):

	data = pd.read_table(assignment,sep=" ",header=None,skiprows=1)

	return data

def main():

	# identify all assignments files
	assignments = glob.glob('track*_assignments.txt')

	# loop through all assignments files
	for i in assignments:
		
		node_name = i.split('_')[0]

		tmp = load_assignment_data(i)

		out_assignments = identify_both_endpoints(tmp)

		write_txt([ str(f) for f in out_assignments],node_name+"_assignments_both_endpoints.txt")

if __name__ == '__main__':
	main()
