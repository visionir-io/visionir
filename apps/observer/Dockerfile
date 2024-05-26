FROM python:3.11-bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

ARG PYPI_TOKEN

ENV POETRY_VIRTUALENVS_IN_PROJECT=true

COPY ./pyproject.toml /visionir-io/pyproject.toml

COPY ./README.md /visionir-io/README.md

RUN cd /visionir-io && poetry install

RUN poetry config pypi-token.pypi $PYPI_TOKEN

WORKDIR /visionir-io/observer

COPY ./src .
