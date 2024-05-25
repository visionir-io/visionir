from logging import DEBUG, INFO, WARNING, StreamHandler, basicConfig, getLogger
from os import getenv, path
from sys import stdout

from pyroscope_io import configure, tag_wrapper

APP_NAME = getenv("APP_NAME")
LOG_DIR = getenv("LOG_DIR")
LOG_FILE = path.join(LOG_DIR, f"{APP_NAME}.log")
PYROSCOPE_SERVER = getenv("PYROSCOPE_SERVER")


class Observer:
    def __init__(self):
        getLogger().setLevel(INFO)
        configure(
            application_name=APP_NAME,
            server_address=PYROSCOPE_SERVER,
            sample_rate=100,
            detect_subprocesses=True,
            gil_only=True,
            report_pid=True,
            enable_logging=True,
            report_thread_id=True,
            report_thread_name=True,
            oncpu=False,
        )
        basicConfig(
            filename=LOG_FILE,
            filemode="a",
            level=DEBUG,
            format="%(levelname)s:%(asctime)s:%(filename)s:%(module)s:%(funcName)s:%(lineno)d:%(message)s",
            datefmt="%d-%m-%YT%H:%M:%S",
        )
        # important when debugging live apps (streamlit, flask, etc)
        getLogger("watchdog.observers.inotify_buffer").setLevel(WARNING)
        logger = getLogger("observer")
        logger.addHandler(StreamHandler(stdout))
        logger.info(f"Logger initialized, writing data to {LOG_FILE}")

        self.logger = logger

    @classmethod
    def tag_wrapping(cls, labels: dict[str, str]):
        def decorator(func):
            def wrapper(*args, **kwargs):
                with tag_wrapper(labels):
                    return func(*args, **kwargs)

            return wrapper

        return decorator


observer = Observer()
