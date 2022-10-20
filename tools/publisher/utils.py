

from typing import Dict, Any  # noqa: F401
import json


def read_txt(path: str) -> Dict[str, object]:
    """
    Reads txt from file path
    :return: Dict[str, object]
    """
    with open(path) as json_file:
        return json_file.readlines()

def read_json(path: str) -> Dict[str, object]:
    """
    Reads json from file path
    :return: Dict[str, object]
    """
    with open(path) as json_file:
        return json.load(json_file)


def write_json(data: Dict[str, object], path: str):
    """
    Writes json to file path
    :return:
    """
    with open(path, 'w') as json_file:
        json.dump(data, json_file)