import os
import sys

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == "__main__":
    #run the reactor
    aPort = os.getenv("PORT")
    if not aPort:
        print("PORT is not defined")
        sys.exit(1)
    app.run(host='0.0.0.0',port=aPort)