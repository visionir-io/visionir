FROM python:bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

WORKDIR /data-lake

COPY pyproject.toml ./pyproject.toml

RUN poetry install

COPY ./src ./src

CMD [ "sleep", "infinity" ]
