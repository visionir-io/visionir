FROM python:3.11-bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

ENV POETRY_VIRTUALENVS_IN_PROJECT=true

COPY ./pyproject.toml /visionir-io/pyproject.toml

RUN cd /visionir-io && poetry install

WORKDIR /visionir-io/observer

COPY ./src .
