FROM python:3.11.9-slim-bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

ENV PYTHONPATH=/data-platform

ENV AWS_S3_ALLOW_UNSAFE_RENAME=true

WORKDIR /data-platform

COPY pyproject.toml ./pyproject.toml

RUN poetry install

COPY ./src ./data-platform

CMD [ "sleep", "infinity" ]
