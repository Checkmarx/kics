#!/usr/bin/env python3
import glob
import os
import subprocess
from subprocess import CalledProcessError

LINTER_PATH = os.getenv('LINTER_PATH')
SKIP_LIST = os.getenv('SKIP_LIST_PATH')
FILES_GLOB = os.getenv('FILES_GLOB')
EXTRA_ARGS = os.getenv('EXTRA_ARGS')
NO_PROGRESS = os.getenv('NO_PROGRESS', False)

##############################
#  show summary and exit     #
#  code 1 if errors > 0      #
##############################
def summary(files, error_files):
  print('\n\n>>------------------------------------------------')
  print(f'found {len(error_files)} issues in {len(files)} file checked')
  print('>>------------------------------------------------')
  if len(error_files) > 0:
    exit(1)
  else:
    exit(0)

print('starting validator')

##############################
#  get files and skip list   #
##############################
all_files = glob.glob(FILES_GLOB)
ignore_list = []

with open(SKIP_LIST, 'r') as reader:
  ignore_list = [line.rstrip() for line in reader]

files = [file for file in all_files if file not in ignore_list]
error_files = []

print(f'found {len(files)} files to check')

##############################
#         run linter         #
##############################
for file in files:
  result = ''
  try:
    cmds = [LINTER_PATH, file]
    if EXTRA_ARGS:
      if len(EXTRA_ARGS.split(' ')):
        cmds = cmds + EXTRA_ARGS.split(' ')
      else:
        cmds.append(EXTRA_ARGS)
    if not NO_PROGRESS:
      print(f'Validating {file}')
    result = subprocess.check_output(cmds, shell=False).decode('utf-8').rstrip()
  except CalledProcessError as e:
    error_files.append(e)
  if result:
    for line in result.split('\n'):
      if line:
        print(f"{line}")

################################
#          list errors         #
################################
if len(error_files) > 0:
  print("\n--- errors ---")
  for error in error_files:
    print(error)
    error_result = error.output.decode('utf-8').rstrip()
    for line in error_result.split('\n'):
      print(line)
  summary(files, error_files)
else:
  summary(files, error_files)
