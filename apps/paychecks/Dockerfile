FROM python:bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

WORKDIR /paychecks

COPY pyproject.toml ./pyproject.toml

RUN poetry install

COPY ./src /paychecks

CMD [ "poetry", "run", "streamlit", "run", "main.py" ]
