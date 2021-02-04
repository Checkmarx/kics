#!/usr/bin/env python3
import glob
import json
import os
import traceback
from pathlib import Path

import yaml

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
      for doc in parsed_docs:
        docs_counter = docs_counter + 1
        sample_filename = f'{docs_counter}.'.join(filename_arr)
        newfile_path = f"{test_dir}{os.sep}{sample_filename}"
        # print('writting:', newfile_path)
        # with open(newfile_path, 'w', encoding='utf-8') as fwp:
        #   yaml.dump(doc, fwp)
        if 'positive' in filename_arr:
          with open(f"{test_dir}{os.sep}positive_expected_result.json", 'r', encoding='utf-8') as fp:
            expected_results = json.load(fp)
            full_yaml = []
            with open(file, 'r', encoding='utf-8') as yfp:
              full_yaml = yfp.readlines()
            positive_map.update({ file:{ "old_line": res["line"], "line_str": full_yaml[res["line"]-1] }
                                  for res in expected_results })
          # with open(newfile_path, 'r', encoding='utf-8') as fp:
          #   for line in fp.readlines():
          #     print(line)
      print('positive lines:', positive_map)

      print(f'aggregated docs {docs_counter}')
    else:
      total_docs_counter = total_docs_counter + 1
    files_counter = files_counter + 1
except Exception as e:
  print(f'found error {e}')
  traceback.print_exc()
print('--')
print(f'parsed and splitted a total of {total_docs_counter} docs in {files_counter}/{len(all_files)} original files')
