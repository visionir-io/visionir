from time import sleep
from observability import observer as obs


@obs.tag_wrapping({"testing": "logger"})
def main():
    obs.logger.info("Application started")
    sleep(1)
    for i in range(10):
        obs.logger.info(f"Processing {i}")
        sleep(10 // 7)


if __name__ == "__main__":
    main()
