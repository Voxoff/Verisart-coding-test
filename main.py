import hashlib
import json

class Timestamp:
    def __init__(self, op, prefix, postfix):
        self.operator = op
        self.prefix = prefix
        self.postfix = postfix

"""
This function should walk through the timestamps and verify message against merkleRoot
Hints: use hashlib.sha256 and hash.hexdigest. message is big-endian while merkleRoot is little-endian.
""" 
def VerifyHash(timestamps, message, merkle_root):
    return False

if __name__ == "__main__":
    msg = "b4759e820cb549c53c755e5905c744f73605f8f6437ae7884252a5f204c8c6e6"
    merkle_root = "f832e7458a6140ef22c6bc1743f09610281f66a1b202e7b4d278b83de55ef58c"    
    with open("./bag/timestamp.json", "rt") as fp:
        dat = json.load(fp)
        timestamps = []

        if VerifyHash(timestamps, msg, merkle_root):
            print("CORRECT!")
        else:
            print("INCORRECT!")