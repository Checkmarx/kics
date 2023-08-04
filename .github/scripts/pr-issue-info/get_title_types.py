# gets all types from pr-title-types.yaml file and inserts them into the regex

import yaml
import os

def yaml_to_regex(yaml_file):
    with open(yaml_file, 'r') as f:
        data = yaml.safe_load(f)
    regex = '|'.join(data)
    print(f"^({regex})\([a-z]+\): [a-z]")


if __name__ == "__main__":
    file_path = os.environ['FILE_PATH']
    yaml_to_regex(file_path)
