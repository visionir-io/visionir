FROM python:bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

ENV PYTHONPATH=/data-lake

ENV AWS_S3_ALLOW_UNSAFE_RENAME=true

WORKDIR /data-lake

COPY pyproject.toml ./pyproject.toml

RUN poetry install

COPY ./src ./data-lake

CMD [ "sleep", "infinity" ]
