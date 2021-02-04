#!/usr/bin/env python3
import glob
import os
import subprocess
from subprocess import CalledProcessError

LINTER_PATH = os.getenv('LINTER_PATH')
SKIP_LIST = os.getenv('SKIP_LIST_PATH')
FILES_GLOB = os.getenv('FILES_GLOB')

##############################
#  get files and skip list   #
##############################
all_files = glob.glob(FILES_GLOB)
ignore_list = []

with open(SKIP_LIST, 'r') as reader:
  ignore_list = [line.rstrip() for line in reader]

files = [file for file in all_files if file not in ignore_list]
error_files = []

##############################
#         run linter         #
##############################
for file in files:
  try:
    result = subprocess.check_output([LINTER_PATH, file]).decode('utf-8').rstrip()
  except CalledProcessError as e:
    error_files.append(e)
  for line in result.split('\n'):
    print(f"{line}")

################################
# show errors and exit code 1  #
################################
if len(error_files) > 0:
  print("\n--- errors ---")
  for error in error_files:
    print(error)
    error_result = error.output.decode('utf-8').rstrip()
    for line in error_result.split('\n'):
      print(line)
  exit(1)
