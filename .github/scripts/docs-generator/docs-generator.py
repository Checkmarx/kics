#!/usr/bin/env python3
from pathlib import Path
from jinja2 import Template
import os
import argparse
import json
import copy

severities = {'High': 'HIGH', 'Medium': 'MEDIUM', 'Low': 'LOW', 'Info': 'INFO'}
colors = {'High': '#C00', 'Medium': '#C60', 'Low': '#CC0', 'Info': '#00C'}
template_dict = {}
platforms = []

arg_parser = argparse.ArgumentParser(description='Create query docs')
arg_parser.add_argument('-p', nargs=1, type=Path,
                        dest='input_path', help='Path to read metadata.json')
arg_parser.add_argument('-o', nargs=1, type=Path, dest='output_path',
                        help='Path to output documentation files')
arg_parser.add_argument('-t', nargs=1, type=Path,
                        dest='templates_path', help='Path to template files')
arg_parser.add_argument('-f', nargs='+', type=str, dest='formats',
                        help='Documentation formats to be created, the extension must exists in the template folder')
parsed_args = vars(arg_parser.parse_args())

parsed_args['formats'] = ['.%s' %
                          f.lstrip('.') for f in parsed_args['formats']]
parsed_args['output_path'][0].mkdir(parents=True, exist_ok=True)

for path in parsed_args['input_path'][0].rglob('metadata.json'):
    if 'assets/queries/template/metadata.json' in str(path):
        continue
    with open(path) as file:
        content = file.read()
        meta_dict = json.loads(content)

        platform = meta_dict['platform']
        severity = meta_dict['severity']
        category = meta_dict['category']

        if platform not in template_dict:
            template_dict[platform] = {}
        if severity not in template_dict[platform]:
            template_dict[platform][severity] = {}
        if category not in template_dict[platform][severity]:
            template_dict[platform][severity][category] = {}

        if 'override' in meta_dict:
            override = meta_dict['override']
            for version, over_meta in override.items():
                override_id = over_meta['id']
                if 'platform' in over_meta:
                    over_platform = over_meta['platform']
                else:
                    over_platform = platform
                if 'severity' in over_meta:
                    over_severity = over_meta['severity']
                else:
                    over_severity = severity
                if 'category' in over_meta:
                    over_category = over_meta['category']
                else:
                    over_category = category

                if over_platform not in template_dict:
                    template_dict[over_platform] = {}
                if over_severity not in template_dict[over_platform]:
                    template_dict[over_platform][over_severity] = {}
                if over_category not in template_dict[over_platform][over_severity]:
                    template_dict[over_category][over_severity][over_category] = {}

                template_dict[platform][severity][category][override_id] = copy.deepcopy(
                    meta_dict)
                for key, value in over_meta.items():
                    template_dict[platform][severity][category][override_id][key] = value

        q_id = meta_dict['id']
        template_dict[platform][severity][category][q_id] = meta_dict

for file_format in parsed_args['formats']:
    general_data = {}
    for platform in template_dict:
        # sort by category
        data = {}
        for severity in severities:
            if severities[severity] in template_dict[platform]:
                data[severity] = {}
                for category in sorted(template_dict[platform][severities[severity]].keys()):
                    metadata_info = template_dict[platform][severities[severity]][category]
                    data[severity] = {**data[severity], **metadata_info}
        # create tables for each platform
        general_data[platform] = data
        with open(os.path.join(parsed_args['templates_path'][0], 'platform_template' + file_format)) as template:
            template_string = template.read()
            template_jinja = Template(template_string)
            result = template_jinja.render({
                'platform': platform,
                'data': data,
                'colors': colors
            })
        with open(os.path.join(parsed_args['output_path'][0], platform.lower() + '-queries' + file_format), 'w') as output:
            print(result, file=output)
        # create general table
    with open(os.path.join(parsed_args['templates_path'][0], 'general_template' + file_format)) as template:
        template_string = template.read()
        template_jinja = Template(template_string)
        result = template_jinja.render({
            'data': general_data,
            'colors': colors
        })
    with open(os.path.join(parsed_args['output_path'][0], 'all-queries' + file_format), 'w') as output:
        print(result, file=output)
