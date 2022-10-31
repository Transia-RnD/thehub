
import sys
import time
from typing import Dict, Any, List  # noqa: F401
from utils import read_json, write_json, read_txt
import json
import base64
import subprocess

from xrpl.core.binarycodec.main import decode

# result = read_json('validation/list.json')
# # print(result['validators'])
# validator_list: List[Dict[str, Any]] = result['validators']

# add_validator(new_validator)
# new_list = remove_validator(public_key)

# print(validator_list)
# print(new_list)

# 1. Create Validator validator-keys.json
# 2. Save Publisher-Keys in google secrets
# 3. Add
# 3. Create Publisher validator-keys.json
# 4. Save Publisher-Keys in google secrets


class ValidationPublisher(object):

    vl: Dict[str, Any] = {
        'public_key' : None,
        'manifest': None,
        'blob' : None,
        'signature' : None,
        'version' : 0
    }

    blob_json: Dict[str, Any] = {
        "sequence": 0,
        "expiration": 0,
        "validators": []
    }

    expiration: int = 86400 * 30 # expires in 30 days
    name: str = ''  # node1 | node2 | signer
    mode: str = 'publisher'  # publisher | validator

    def __init__(cls, mode: str, name: str) -> None:
        try:
            cls.mode = mode
            cls.name = name
            cls.vl = read_json('out/vl.json')

            if not cls.vl:
                print('RESETING - NO VL')
                cls.reset()
                return
            
            if 'blob' not in cls.vl:
                print('RESETING - NO BLOB')
                cls.reset()
                return

            cls.blob_json = cls.decode_blob(cls.vl['blob'])
            
            if not read_json(f'/app/publisher/keystore/{cls.mode}.json'):
                print('NO KEYS')
                cls.create_keys()
                cls.reset()
                
        except Exception as e:
            print(e)

    def reset(cls):
        cls.vl: Dict[str, Any] = {
            'public_key' : None,
            'manifest': None,
            'blob' : None,
            'signature' : None,
            'version' : 0
        }

        cls.blob_json: Dict[str, Any] = {
            "sequence": 0,
            "expiration": 0,
            "validators": []
        }

    def create_keys(cls) -> str:
        # args = ['rm /root/.ripple/validator-keys.json']
        # subprocess.call(args)
        args1 = ['/app/validator', 'create_keys']
        subprocess.call(args1)
        args2 = ['cp', '/root/.ripple/validator-keys.json', f'/app/publisher/keystore/{cls.mode}.json']
        subprocess.call(args2)
        return read_json(f'/app/publisher/keystore/{cls.mode}.json')

    def create_token(cls) -> str:
        out = open(f'keystore/{cls.mode}/token.txt', 'w')
        # args1 = ['mkdir -p /root/.ripple/validator-keys.json']
        # subprocess.call(args1)
        # args2 = ['cp', f'/app/publisher/keystore/{cls.mode}.json', '/root/.ripple/validator-keys.json']
        # subprocess.call(args2)
        args3 = ['/app/validator', 'create_token']
        subprocess.call(args3, stdout=out)
        return read_txt(f'keystore/{cls.mode}/token.txt')
        
    def get_manifest(cls) -> str:
        cls.create_token()
        out = open(f'out/{cls.mode}/manifest.txt', 'w')
        args = ['/app/validator', 'show_manifest', 'base64']
        subprocess.call(args, stdout=out)
        return read_txt(f'out/{cls.mode}/manifest.txt')

    def get_signature(cls) -> str:
        out = open('out/signature.txt', 'w')
        args = ['/app/validator', 'sign', cls.encode_blob().hex()]
        subprocess.call(args, stdout=out)
        return read_txt('out/signature.txt')

    def create_validator(cls):
        cls.create_token()
        cls.get_manifest()

    def update(cls) -> None:
        print('UPDATING PUBLISHER LIST')
        manifest = [l.strip() for l in cls.get_manifest()]
        cls.vl['manifest'] = manifest[1]
        encoded = base64.b64decode(cls.vl['manifest']).hex()
        decoded: Dict[str, Any] = decode(encoded)
        cls.vl['public_key'] = decoded['PublicKey'].upper()

        cls.vl['blob'] = cls.encode_blob().decode('utf-8')
        signature = [l.strip() for l in cls.get_signature()]
        cls.vl['signature'] = signature[0]
        cls.vl['version'] = 1
        write_json(cls.vl, 'out/vl.json')

    def add_validator(cls, manifest: str):
        if not cls.vl:
            raise ValueError('INVALID VL')
        if not cls.blob_json:
            raise ValueError('INVALID BLOB JSON')
        
        print('ADDING MANIFEST TO VL')
        encoded = base64.b64decode(manifest).hex()
        decoded: Dict[str, Any] = decode(encoded)
        public_key: str = decoded['PublicKey'].upper()
        new_validator: Dict[str, Any] = {
            'validation_public_key': public_key,
            'manifest': manifest
        }
        vlist: List[Dict[str, Any]] = cls.blob_json['validators']
        vlist.append(new_validator)
        cls.blob_json['sequence'] += 1
        cls.blob_json['expiration'] = (int(time.time()) + cls.expiration) - 946684800
        # cls.blob_json['expiration'] = 721785600
        cls.blob_json['validators'] = vlist
        # print(cls.blob_json)
        cls.update()

    def remove_validator(cls, public_key: str):
        if not cls.vl:
            raise ValueError('INVALID VL')
        if not cls.blob_json:
            raise ValueError('INVALID BLOB JSON')
        
        vlist: List[Dict[str, Any]] = cls.blob_json['validators']
        cls.blob_json['sequence'] += 1
        cls.blob_json['expiration'] = (int(time.time()) + cls.expiration) - 946684800
        cls.blob_json['validators'] = [l for l in vlist if l['validation_public_key'] != public_key]
        cls.update()

    def encode_blob(cls) -> bytes:
        return base64.b64encode(json.dumps(cls.blob_json).encode("utf-8"))

    def decode_blob(cls, blob: str):
        return json.loads(base64.b64decode(blob))

# name: str = 'node1'
# manifest: str = 'JAAAAAFxIe3Dc8zHZ35d6HNlvvApnwX1SQYmv9g3tZdg1A9rN3Nb63MhAuOZVn32C/mF1DaAC3m/9Gnw7hERMGSi90P/95ur3CPedkYwRAIgM38+f4Ob0fs2ZChQx1D7N9lONHr4en2K/+J/wI+DcSACIERsI0U09KIR+9noXBmHeoxUPWQlhdAZ0KZ140bff0gUcBJA35BxaZnx/1GB254FCXYKEtI9OCLCrE0h4a0Dc+3wQHJT5TZ73JHM51fKCdGPKfT07wKC8wxZpz2C5QC56Z/4AQ=='
# vp = ValidationPublisher()
# vp.add_validator(manifest)
# print(vp.blob_json)
# print(vp.encode_blob())
# vp.update()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 main.py <name> <action> <manifest | pk>")
        sys.exit()

    name = sys.argv[1]
    action = sys.argv[2]
    manifest_or_pk = sys.argv[3]

    try:
        vp = ValidationPublisher('publisher', name)

        if action == 'add':
            vp.add_validator(manifest_or_pk)

        if action == 'remove':
            vp.remove_validator(manifest_or_pk) 
    except Exception as e:
        print(e)

# if __name__ == "__main__":
#     if len(sys.argv) < 2:
#         print("Usage: python3 main.py <action> <node-name> ")
#         sys.exit()

#     node_name = sys.argv[1]
#     action = sys.argv[2]
#     manifest = sys.argv[3]

#     if action == 'publisher':
#         vp = ValidationPublisher(node_name)
#         vp.update()

#     if action == 'validator':
#         vp = ValidationPublisher(node_name)
#         vp.create_validator()