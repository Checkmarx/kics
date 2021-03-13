#!/usr/bin/env python3
import argparse
import glob
import json
import os

parser = argparse.ArgumentParser(
    description='Filter changed sample files')
parser.add_argument('globs', metavar='FILES',
                    type=str, nargs='+', help='List of glob with all samples, should be quoted')

args = parser.parse_args()

if not args.globs:
  exit(1)

samples_glob = args.globs
all_files = []
all_files = [all_files.extend(glob.glob(file_entry))
             for file_entry in samples_glob]
changes_filepath = f"{os.path.join(os.getenv('HOME'),'files.json')}"

with open(changes_filepath, 'r') as fp:
    changes_list = json.load(fp)

sample_changes = [file for file in all_files if file in changes_list]
print(' '.join(sample_changes))
