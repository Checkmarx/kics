#!/usr/bin/env python3
from pathlib import Path
from jinja2 import Template
import os, argparse, json

severities = {'High': 'HIGH', 'Medium': 'MEDIUM', 'Low': 'LOW', 'Info': 'INFO'}
colors = {'High': '#C00', 'Medium': '#C60', 'Low': '#CC0', 'Info': '#00C'}
template_dict = {}
platforms = []

arg_parser = argparse.ArgumentParser(description='Create query docs')
arg_parser.add_argument('-p', nargs=1, type=Path, dest='input_path', help='Path to read metadata.json')
arg_parser.add_argument('-o', nargs=1, type=Path, dest='output_path', help='Path to output documentation files')
arg_parser.add_argument('-t', nargs=1, type=Path, dest='templates_path', help='Path to template files')
arg_parser.add_argument('-f', nargs='+', type=str, dest='formats', help='Documentation formats to be created, the extension must exists in the template folder')
parsed_args = vars(arg_parser.parse_args())

parsed_args['formats'] = ['.%s' % f.lstrip('.') for f in parsed_args['formats']]
parsed_args['output_path'][0].mkdir(parents=True, exist_ok=True)

for path in parsed_args['input_path'][0].rglob('metadata.json'):
  if 'assets/queries/template/metadata.json' in str(path):
    continue
  with open(path) as file:
    content = file.read()
    metadata_dict = json.loads(content)
    platform = metadata_dict['platform']
    severity = metadata_dict['severity']
    category = metadata_dict['category']

    if platform not in template_dict:
      template_dict[platform] = {}
    if severity not in template_dict[platform]:
      template_dict[platform][severity] = {}
    if category not in template_dict[platform][severity]:
      template_dict[platform][severity][category] = {}

    if isinstance(metadata_dict['descriptionUrl'], str):
      metadata_dict['descriptionUrl'] = [metadata_dict['descriptionUrl']]
    template_dict[platform][severity][category][metadata_dict['id']] = metadata_dict

for platform in template_dict:
  for file_format in parsed_args['formats']:
    with open(os.path.join(parsed_args['templates_path'][0], 'template' + file_format)) as template:
      # sort by category
      data = {}
      for severity in severities:
        if severities[severity] in template_dict[platform]:
          data[severity] = {}
          for category in sorted(template_dict[platform][severities[severity]].keys()):
            metadata_info = template_dict[platform][severities[severity]][category]
            data[severity] = {**data[severity], **metadata_info}
      template_string = template.read()
      template_jinja = Template(template_string)
      result = template_jinja.render({
        'platform': platform,
        'data': data,
        'colors': colors
      })
    with open(os.path.join(parsed_args['output_path'][0], platform.lower() + '-queries' + file_format), 'w') as output:
      print(result, file=output)
