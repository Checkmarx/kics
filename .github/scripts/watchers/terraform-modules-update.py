import argparse
import os
import sys
import requests
import json

import boto3
from jinja2 import Environment

def get_module_info(mod_obj):
  mod_info = {'inputs': [], 'resources': []}
  for input_value in mod_obj['inputs']:
    mod_info['inputs'].append(input_value['name'])
  for input_value in mod_obj['resources']:
    mod_info['resources'].append(input_value['type'])
  return mod_info

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

arg_parser = argparse.ArgumentParser(description='Check updates on terrarform verified modules')
arg_parser.add_argument('-c', type=str, dest='current', help='Current modules json file')
arg_parser.add_argument('-u', type=str, dest='url', help='Url for terraform registry')

parsed_args = vars(arg_parser.parse_args())

terraform_url = parsed_args['url']
commons_json = parsed_args['current']

offset = 0
next_value = True
provider = 'aws'

modules_list = []
separator = '='*10

print('{separator} Getting Modules {separator}'.format(separator=separator))
while next_value:
  print('- Retrieving offset = {}'.format(offset))
  response = requests.get('{}?limit=100&provider={}&offset={}&verified=true'.format(terraform_url, provider, str(offset)))
  res_json = response.json()
  next_value = 'next_offset' in res_json['meta']
  offset += 100
  for module in res_json['modules']:
    modules_list.append({'id': module['id'], 'name': module['name']})

print('{separator} Finished Getting Modules {separator}'.format(separator=separator))
print('\n{separator} Getting Modules Infos {separator}'.format(separator=separator))
module_info_dict = {}
for module in modules_list:
  print('- Retrieving module = {}'.format(module['id']))
  response = requests.get('{}/{}'.format(terraform_url, module['id']))
  module_info = {'inputs': [], 'resources': []}
  res_json = response.json()

  gather_module_info = get_module_info(res_json['root'])
  module_info['inputs'].append(gather_module_info['inputs'])
  module_info['resources'].append(gather_module_info['resources'])
  for submodule in res_json['submodules']:
    gather_module_info = get_module_info(submodule)
    # module_info['inputs'].append(gather_module_info['inputs'])
    module_info['resources'].append(gather_module_info['resources'])
  module_name = '{}/{}/{}'.format(res_json['namespace'], res_json['name'], res_json['provider'])
  module_info_dict[module_name] = {}
  # flatten list process
  for key in module_info:
    module_info_dict[module_name][key] = [item for sublist in module_info[key] for item in sublist]

print('{separator} Finished Getting Modules Infos {separator}'.format(separator=separator))
print('\n{separator} Creating and JSON {separator}'.format(separator=separator))

new_modules_json = {}
for module_key_name, module_values in module_info_dict.items():
  print('- Generating change Dict "{}"'.format(module_key_name))
  new_modules_json[module_key_name] = {'resources': [], 'inputs': {}}
  for key, value in module_values.items():
    if key == 'inputs':
      for input_value in value:
        new_modules_json[module_key_name][key][input_value] = input_value
    else:
      new_modules_json[module_key_name][key] = value

print('\n{separator} Converting to JSON {separator}'.format(separator=separator))
json_dict = {"common_lib": {"modules": {provider: new_modules_json}}}
current_modules_json = {}
with open(commons_json) as json_file:
  data = json.load(json_file)
  current_modules_json = data['common_lib']['modules']['aws']
changes = {'Added': [], 'Updated': []}

for new_module in new_modules_json:
  if new_module not in current_modules_json:
    changes['Added'].append('Module {} added'.format(new_module))
    current_modules_json[new_module] = new_modules_json[new_module]
    continue
  if current_modules_json[new_module] == new_modules_json[new_module]:
    for new_resource in new_modules_json[new_module]['resources']:
      if new_resource not in current_modules_json[new_module]['resources']:
        current_modules_json[new_module]['resources'].append(new_resource)
        changes['Updated'].append('Resource {} added to Module {}'.format(new_resource, new_module))
    for new_input in new_modules_json[new_module]['inputs']:
      if new_input not in current_modules_json[new_module]['inputs']:
        current_modules_json[new_module]['inputs'][new_input] = new_input
        changes['Updated'].append('Input {} added to Module {}'.format(new_input, new_module))

changes['Updated'].append('Input {} added to Module {}'.format('new_input', 'new_module'))

if len(changes['Updated']) == 0 and len(changes['Added']) == 0:
  print('{separator} There are no changes {separator}'.format(separator=separator))
  sys.exit()

email_body = ''
with open(os.path.join(os.path.dirname(sys.argv[0]), 'modules_email_template.tmpl')) as template:
    template_string = template.read()
    env = Environment(trim_blocks=True, lstrip_blocks=True)
    template_jinja = env.from_string(template_string)
    email_body = template_jinja.render({'data': changes})

print("{separator} Sending email {separator}".format(separator=separator))
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
  'felipe.avelar@checkmarx.com',
  'rogerio.peixoto@checkmarx.com',
  'joao.reigota@checkmarx.com',
  'rafaela.soares@checkmarx.com',
]

error_sending = []
for email in email_distribution_list:
  try:
    print(f"sending email to {email}")
    response = send_email(
      email, 'Terraform modules changes', email_body)
    print(f"email sent {response}")
  except Exception as e:
    print(f"error sending email to {email}")
    print(e)
    error_sending.append(f"error sending email to {email} \n error :: {e}")

if len(error_sending) > 0:
  print("### ERRORS SENDING EMAILS ###")
  send_email('rogerio.peixoto@checkmarx.com',
              'Terraform Module Update', '</br>'.join(error_sending))

json_dict = {"common_lib": {"modules": {provider: current_modules_json}}}
json_object = json.dumps(json_dict, indent=2)
with open(commons_json, 'w') as output:
  print(json_object, file=output)
