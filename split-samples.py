#!/usr/bin/env python3
import glob
import json
import os
import pprint
import re
import traceback
from pathlib import Path

import yaml

pp = pprint.PrettyPrinter(indent=2)
types = ('yaml', 'yml')
all_files = []
for ext in types:
  all_files.extend(glob.glob(f"./assets/queries/cloudFormation/**/test/*.{ext}"))
files_counter = 0
total_docs_counter = 0

try:
  for file in all_files:
    parsed_docs = []
    with open(file, 'r', encoding='utf-8') as fh:
      print(f'checking file: {file}')
      parsed_docs = list(yaml.load_all(fh, Loader=yaml.BaseLoader))
    docs_counter = 0
    if len(parsed_docs) > 1:
      print(f'splitting {file}')
      test_dir = os.path.dirname(file)
      filename_arr = os.path.basename(file).split('.')
      positive_map = {}
      new_expected_results = []
      for doc in parsed_docs:
        docs_counter = docs_counter + 1
        sample_filename = f'{docs_counter}.'.join(filename_arr)
        newfile_path = f"{test_dir}{os.sep}{sample_filename}"
        print('writting:', newfile_path)
        with open(newfile_path, 'w', encoding='utf-8') as fwp:
          yaml.dump(doc, fwp)
        ###############################################
        # rewrite expected_result.json with new lines #
        ###############################################
        # not working
        ###############
        # if 'positive' in filename_arr:
        #   with open(f"{test_dir}{os.sep}positive_expected_result.json", 'r', encoding='utf-8') as fp:
        #     expected_results = json.load(fp)
        #     full_yaml = []
        #     with open(f'{file}', 'r', encoding='utf-8') as yfp:
        #       full_yaml = yfp.readlines()
        #     def stringify_boolean(input):
        #       return re.sub(r'(.*\w:\s+)(true|false)', r"\1'\2'",input)
        #     positive_map.update({ res["line"]:{"line":stringify_boolean(full_yaml[res["line"]-1].rstrip()),"done":False} for res in expected_results })
        #   print('updated positive - size:', len(positive_map))
        #   pp.pprint(positive_map)
        #   with open(newfile_path, 'r', encoding='utf-8') as fp:
        #     for idx,line in enumerate(fp.readlines()):
        #       for key,value in positive_map.items():
        #         print(idx+1, line.strip(), value['line'].strip())
        #         if value and line.strip() == value['line'].strip():
        #           print('FOUND!')
        #           positive_map[key]["done"] = True
        #   print('total positive:')
        #   pp.pprint(positive_map)
        #   assert all([value['done'] for value in positive_map.values()])

      print(f'aggregated docs {docs_counter}')
    else:
      total_docs_counter = total_docs_counter + 1
    files_counter = files_counter + 1
except Exception as e:
  print(f'found error {e}')
  traceback.print_exc()
print('--')
print(f'parsed and splitted a total of {total_docs_counter} docs in {files_counter}/{len(all_files)} original files')
