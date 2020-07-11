import os

from locust import TaskSet, task, HttpUser, between

QUIET_MODE = True if os.getenv("QUIET_MODE", "true").lower() in ['1', 'true', 'yes'] else False
TASK_DELAY_FROM = int(os.getenv("TASK_DELAY", "5"))
TASK_DELAY_TO = int(os.getenv("TASK_DELAY", "30"))


DATA_SOURCE_PATH = "data.csv"


def log(message):
    if not QUIET_MODE:
        print(message)


class TestBehaviour(TaskSet):
    @task
    def task1(self):
        log("running task1")
        self.client.get("/")


class TestUser(HttpUser):
    tasks = [TestBehaviour]
    # wait between 5 and 30 seconds
    wait_time = between(TASK_DELAY_FROM, TASK_DELAY_TO)
