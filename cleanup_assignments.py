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

def identify_both_endpoints(data,labels):
	
	return data.apply(lambda x: multi_label(x[0],x[1],labels), axis='columns').tolist()

def multi_label(x,y,labels):
	
    if x > 0:
        if x in labels.loc[labels['base'] == labels.loc[labels['label'] == x]['base'].values[0]]['label'].tolist() and y in labels.loc[labels['base'] == labels.loc[labels['label'] == x]['base'].values[0]]['label'].tolist():
            return x
        else:
            return 0
    else:
        return 0

def load_assignment_data(assignment):

	data = pd.read_table(assignment,sep=" ",header=None,skiprows=1)

	return data

def load_labels(label_file):
	
    return pd.read_json(label_file,orient='records')

def main():

	with open('config.json','r') as config_f:
		config = json.load(config_f)

	# identify all assignments files
	assignments = glob.glob('track*_assignments.txt')
    	labels = load_labels(config['label'])
    	labels['base'] = [ '.'.join(f.split('.')[1:]) if 'h.' in f else f for f in labels['name'] ]

	# loop through all assignments files
	for i in assignments:
		
		node_name = i.split('_')[0]

		tmp = load_assignment_data(i)

		out_assignments = identify_both_endpoints(tmp)

		write_txt([ str(f) for f in out_assignments],node_name+"_assignments_both_endpoints.txt")

if __name__ == '__main__':
	main()
