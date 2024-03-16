FROM python:bullseye

RUN  curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

WORKDIR /paychecks/app

COPY app/project ./project

RUN poetry install -C project/

COPY app/src ./src

WORKDIR /paychecks/app/project

CMD [ "poetry", "run", "streamlit", "run", "../src/main.py" ]
