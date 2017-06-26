#######################################
# Dockerfile for redash.data.phila.gov
#######################################

FROM redash/redash:latest

RUN pip install git+https://github.com/CityOfPhiladelphia/eastern-state.git

# RUN npm install && npm run build && rm -rf node_modules
# RUN chown -R redash /app
# USER redash

COPY scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
