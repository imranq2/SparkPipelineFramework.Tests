FROM python:3.7-slim

RUN apt-get update && \
    apt-get install -y git && \
    pip install pipenv

COPY ${project_root}/Pipfile* ./

# separate this so the above gets cached
RUN pipenv sync --dev --system

WORKDIR /sourcecode

CMD pre-commit run --all-files
