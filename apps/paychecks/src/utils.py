from logging import getLogger, basicConfig, DEBUG, StreamHandler
from sys import stdout

basicConfig(
    filename="data/logs.log",
    level=DEBUG,
    format="%(levelname)s:%(asctime)s:%(name)s:%(message)s",
    datefmt="%d-%m-%YT%H:%M:%S",
)
stream_handler = StreamHandler(stdout)
logger = getLogger(__name__)
logger.setLevel(DEBUG)
logger.addHandler(stream_handler)
