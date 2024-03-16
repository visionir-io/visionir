FROM python:bullseye

WORKDIR /paychecks

RUN  curl -sSL https://install.python-poetry.org | python3 -

COPY pyproject.toml poetry.lock ./

ENV PATH="${PATH}:/root/.local/bin"

RUN poetry install

CMD [ "poetry", "run", "streamlit", "run", "src/main.py" ]
