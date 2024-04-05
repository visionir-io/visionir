FROM python:bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

COPY ./pyproject.toml /pyproject.toml

RUN poetry install

COPY ./src /paychecks

ENV PYTHONPATH=/paychecks

WORKDIR /paychecks

CMD [ "poetry", "run", "streamlit", "run", "main.py" ]
