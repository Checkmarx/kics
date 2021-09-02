#!/usr/bin/env python3
import argparse
import json
import re
import os
import sys

import boto3
from jinja2 import Environment


def get_json(filename_list, command_dict):
  for filename in filename_list:
    with open(filename) as json_file:
      data = json.load(json_file)
      extract_command = re.search('(\w+)-flags.json', filename, re.IGNORECASE)
      if not extract_command:
        return
      command = extract_command.group(1)
      command_dict[command] = data

def clean_dict(target):
  return {k: v for k, v in target.items() if v}

def prepare_template_data(data, new_json, old_json):
  data['added_commands'] = ', '.join(list(new_json.keys() - old_json.keys()))
  data['removed_commands'] = ', '.join(list(old_json.keys() - new_json.keys()))
  common_commands = list(new_json.keys() & old_json.keys())

  for command in common_commands:
    if command not in data:
      data[command] = {}
    data[command]['added_flags'] = ', '.join(list(new_json[command].keys() - old_json[command].keys()))
    data[command]['removed_flags'] = ', '.join(list(old_json[command].keys() - new_json[command].keys()))
    common_flags = list(new_json[command].keys() & old_json[command].keys())

    for flag in common_flags:
      if flag not in data[command]:
        data[command][flag] = {}
      added_attributes = list(new_json[command][flag].keys() - old_json[command][flag].keys())
      data[command][flag]['removed_attributes'] = ', '.join(list(old_json[command][flag].keys() - new_json[command][flag].keys()))
      formatted_attrs = []
      for added_attr in added_attributes:
        formatted_attrs.append(f'{added_attr} = {new_json[command][flag][added_attr]}')
      data[command][flag]['added_attributes'] = ', '.join(formatted_attrs)
      common_attr = list(new_json[command][flag].keys() & old_json[command][flag].keys())

      for attr in common_attr:
        old_value = old_json[command][flag][attr]
        new_value = new_json[command][flag][attr]
        if old_value != new_value:
          data[command][flag][attr] = f'Changed {attr}: "{str(old_value)}" -> "{str(new_value)}"'
      data[command][flag] = clean_dict(data[command][flag])
    data[command] = clean_dict(data[command])
  data = clean_dict(data)

def send_email(email, subject, body):
    return client.send_email(
        Destination={
            'ToAddresses': [
                email,
            ],
        },
        Message={
            'Body': {
                'Text': {
                    'Charset': 'UTF-8',
                    'Data': body,
                },
            },
            'Subject': {
                'Charset': 'UTF-8',
                'Data': subject,
            },
        },
        Source='kics@checkmarx.com',
    )





arg_parser = argparse.ArgumentParser(description='Create query docs')
arg_parser.add_argument('-n', nargs='+', dest='new', help='New flags.json')
arg_parser.add_argument('-o', nargs='+', dest='old', help='Old flags.json')

parsed_args = vars(arg_parser.parse_args())

new_dict = {}
old_dict = {}
get_json(parsed_args['new'], new_dict)
get_json(parsed_args['old'], old_dict)

print("======= Creating email body")
data = {}
prepare_template_data(data, new_dict, old_dict)
email_body = ''
with open(os.path.join(os.path.dirname(sys.argv[0]), 'email_template.txt')) as template:
  template_string = template.read()
  env = Environment(trim_blocks=True, lstrip_blocks=True)
  template_jinja = env.from_string(template_string)
  email_body = template_jinja.render({'data': data})


print("======= Sending email")
aws_region = os.getenv('AWS_REGION')
aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_session_token = os.getenv('AWS_SESSION_TOKEN')

client = boto3.client(
    'ses',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name=aws_region,
    aws_session_token=aws_session_token
)

email_distribution_list = [
    'rogerio.peixoto@checkmarx.com',
    'felipe.avelar@checkmarx.com',
    'joao.reigota@checkmarx.com',
    # 'rafaela.soares@checkmarx.com',
    'nuno.oliveira@checkmarx.com',
    'daniela.dacruz@checkmarx.com',
    'ori.bendet@checkmarx.com',
    'lior.kaplan@checkmarx.com',
]

error_sending = []
for email in email_distribution_list:
    try:
        print(f"sending email to {email}")
        response = send_email(
            email, 'Flags change on KICS', email_body)
        print(f"email sent {response}")
    except Exception as e:
        print(f"error sending email to {email}")
        print(e)
        error_sending.append(f"error sending email to {email} \n error :: {e}")

if len(error_sending) > 0:
    print("### ERRORS SENDING EMAILS ###")
    send_email('rogerio.peixoto@checkmarx.com',
               'Daily Error Report', '</br>'.join(error_sending))
