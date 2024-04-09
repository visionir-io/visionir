from logging import DEBUG, WARNING, StreamHandler, basicConfig, getLogger
from tempfile import NamedTemporaryFile
from datetime import datetime
from sys import stdout
import pyroscope


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
            dir="/data",
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


pyroscope.configure(
    application_name="paychecks",  # replace this with some name for your application
    server_address="http://pyroscope.visionir.io",  # replace this with the address of your Pyroscope server
    sample_rate=100,  # default is 100
    detect_subprocesses=False,  # detect subprocesses started by the main process; default is False
    oncpu=True,  # report cpu time only; default is True
    gil_only=True,  # only include traces for threads that are holding on to the Global Interpreter Lock; default is True
    enable_logging=True,  # does enable logging facility; default is False
    tags={"app": "paychecks"},
)
