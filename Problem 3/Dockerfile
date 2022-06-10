# using the parent image
FROM python:3.10-slim-bullseye
# Not to buffer logs 
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip3 install -r requirements.txt
COPY . /code/
CMD [ "python3", "server.py"]