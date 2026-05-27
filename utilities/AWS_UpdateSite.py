# AWS Sync Script
# Version 0.1
# By Amy Wells

import json
import time
import re

config = ""
targets = []

with open("config.json") as f:
    config = json.load(f)

for x in config:
    if config[x] == "":continue
    targets.append(config[x])

print(targets)

if (len(targets) > 0):
    print("Sync to S3 on the above directories? (Yes/No)")
    userInput = True 
    while userInput == True:
        confirm = input("")
        if (re.search("^y",confirm, re.IGNORECASE)):
            userInput = False
            print("Yes")
        elif (re.search("^n",confirm, re.IGNORECASE)):
            userInput = False
            print("Cancelling Operation")
            raise SystemExit
        else:
            print(f"{confirm} <-- Wrong input, please try again.")

    print("Syncing to S3")

    for i in range(len(targets)):
        print(targets[i][0])
        print(targets[i][1])
        aws s3 sync f"targets[i][0]" f"targets[i][1]" --delete 

time.sleep(5)