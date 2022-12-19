FROM imranq2/helix.spark:3.3.0.19-slim
# https://github.com/icanbwell/helix.spark
USER root

ENV PYTHONPATH=/spftest
ENV CLASSPATH=/spftest/jars:$CLASSPATH

# remove the older version of entrypoints with apt-get because that is how it was installed
RUN apt-get remove python3-entrypoints -y

COPY Pipfile* /spftest/
WORKDIR /spftest

RUN df -h # for space monitoring
RUN pipenv sync --dev --system && pipenv run pip install pyspark==3.3.0

# COPY ./jars/* /opt/bitnami/spark/jars/
# COPY ./conf/* /opt/bitnami/spark/conf/
# run this to install any needed jars by Spark
COPY ./test.py ./
RUN /opt/spark/bin/spark-submit --master local[*] test.py

COPY . /spftest

# override entrypoint to remove extra logging
RUN mv /opt/minimal_entrypoint.sh /opt/entrypoint.sh

# run pre-commit once so it installs all the hooks and subsequent runs are fast

RUN mkdir -p /fhir && chmod 777 /fhir
RUN mkdir -p /.local/share/virtualenvs && chmod 777 /.local/share/virtualenvs
# USER 1001
