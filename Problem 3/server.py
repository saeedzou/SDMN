"""
    This app uses flask to bring up an HTTP server with 
    only the endpoint /api/v1/status 
    It handlse GET and POST methods
    To run the dockerized app, use docker build in this directory
    to make the image, then use the image as:
    >> docker build -t <image_name>:<tag> .
    >> docker run -p 8000:8000 <image>
    use curl for GET:
    >> curl localhost:8000/api/v1/status
    use curl for POST:
    >> curl -X POST localhost:8000/api/v1/status -H "Content-Type: application/json" -d '{"status": "not OK"}'

"""
from urllib import response
from flask import Flask, request
import json 

app = Flask(__name__)

res = {'status': 'OK'} 
#   The endpoint
@app.route('/api/v1/status', methods=['GET', 'POST'])
def status():
    if request.method == 'POST':
        request_data = request.get_json()
        res['status'] = request_data['status']
        return json.dumps(res), 201
    else:        
        return json.dumps(res)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)