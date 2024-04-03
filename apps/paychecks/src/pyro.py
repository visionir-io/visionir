import pyroscope

pyro = pyroscope.configure(
    application_name="paychecks",  # replace this with some name for your application
    server_address="http://pyroscope:4040",  # replace this with the address of your Pyroscope server
    sample_rate=100,  # default is 100
    detect_subprocesses=False,  # detect subprocesses started by the main process; default is False
    oncpu=True,  # report cpu time only; default is True
    gil_only=True,  # only include traces for threads that are holding on to the Global Interpreter Lock; default is True
    enable_logging=True,  # does enable logging facility; default is False
    tags={
        "app": "paychecks",
    },
)
