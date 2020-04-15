import json

def handler(event, context):
    print("Received my event: " + json.dumps(event, indent=2))