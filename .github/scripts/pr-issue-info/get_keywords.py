# gets platforms and cloud providers keywords from keywords.yaml file and inserts into a map in shell script

import yaml


def load_keywords(file):
    with open(file, 'r') as stream:
        try:
            data = yaml.safe_load(stream)
            # format to bash associative array
            formatted = ' '.join([f'["{k}"]="{v}"' for k, v in data.items()])
            print(f"declare -A keywords=({formatted})")
        except yaml.YAMLError as exc:
            print(exc)


if __name__ == "__main__":
    load_keywords('.github/keywords.yaml')
