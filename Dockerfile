#######################################
# Dockerfile for redash.data.phila.gov
#######################################

#FROM redash/redash:latest

#RUN pip install git+https://github.com/CityOfPhiladelphia/eastern-state.git

FROM ubuntu:xenial

EXPOSE 5000

RUN useradd --create-home redash

# Ubuntu packages
RUN apt-get update && apt-get install -y curl && curl https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y python-pip python-dev build-essential pwgen libffi-dev sudo git-core wget \
  nodejs \
  # Postgres client
  libpq-dev \
  # Additional packages required for data sources:
  libssl-dev libmysqlclient-dev freetds-dev libsasl2-dev && \
  pip install git+https://github.com/CityOfPhiladelphia/eastern-state.git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip install -U setuptools==23.1.0

WORKDIR /app

# We first copy only the requirements file, to avoid rebuilding on every file
# change.
COPY requirements.txt requirements_dev.txt requirements_all_ds.txt ./
RUN pip install -r requirements.txt -r requirements_dev.txt -r requirements_all_ds.txt

COPY . ./
RUN npm install && npm run build && rm -rf node_modules
RUN chown -R redash /app
USER redash

COPY scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
