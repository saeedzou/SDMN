# Problem 3 (Docker)
This app uses flask to bring up an HTTP server with only the endpoint /api/v1/status.

It handles GET and POST methods

## To run the dockerized app
    # use docker build in this directory to make the image, 
    # then use the image as:
    >> docker build -t <image_name>:<tag> .
    >> docker run -p 8000:8000 <image>
    # use curl for GET:
    >> curl localhost:8000/api/v1/status
    # use curl for POST:
    >> curl -X POST localhost:8000/api/v1/status -H "Content-Type: application/json" -d '{"status": "not OK"}'

### Example
![This is a alt text.](https://github.com/saeedzou/SDMN/tree/main/Problem%203/src/images/docker_server.jpg "This is a sample image.")