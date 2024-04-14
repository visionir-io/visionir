from datetime import datetime
from logging import DEBUG, WARNING, StreamHandler, basicConfig, getLogger
from sys import stdout
from tempfile import NamedTemporaryFile
import pyroscope_io
from os import getenv


class Singleton:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(Singleton, cls).__new__(cls, *args, **kwargs)
        return cls._instance


class Logger(Singleton):
    def init_logger(self, module_name: str):
        with NamedTemporaryFile(
            delete=False,
            dir=getenv("LOG_DIR", "/tmp"),
            prefix=f"{module_name}_{datetime.now().strftime('%Y%m%dT%H%M%S')}_",
        ) as f:
            basicConfig(
                filename=f.name,
                filemode="a",
                level=DEBUG,
                format="%(levelname)s:%(asctime)s:%(name)s:%(message)s",
                datefmt="%d-%m-%YT%H:%M:%S",
            )
            stream_handler = StreamHandler(stdout)
            logger = getLogger(module_name)
            getLogger("watchdog.observers.inotify_buffer").setLevel(WARNING)
            logger.setLevel(DEBUG)
            logger.addHandler(stream_handler)
            logger.debug(f"Logger initialized, writing data to {f.name}")
        return logger


pyroscope_io.configure(
    application_name="paychecks",
    server_address="https://pyroscope.visionir.io",
    sample_rate=100,
    detect_subprocesses=True,
    gil_only=True,
    report_pid=True,
    report_thread_id=True,
    report_thread_name=True,
    tags={"app": "paychecks"},
)
