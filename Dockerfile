#######################################
# Dockerfile for redash.data.phila.gov
#######################################

FROM redash/base:latest

# MAINTAINER oddt@phila.gov

RUN apt-get -y update

RUN apt-get install -y python

RUN apt-get install -y python-pip

RUN pip install git+https://github.com/CityOfPhiladelphia/eastern-state

# COPY 

# RUN npm install && npm run build && rm -rf node_modules
# RUN chown -R redash /app
# USER redash

ENTRYPOINT
