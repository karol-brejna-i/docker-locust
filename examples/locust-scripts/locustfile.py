import os

from locust import TaskSet, task, HttpLocust

QUIET_MODE = True if os.getenv("QUIET_MODE", "true").lower() in ['1', 'true', 'yes'] else False
TASK_DELAY = int(os.getenv("TASK_DELAY", "1000"))

DATA_SOURCE_PATH = "data.csv"


def log(message):
    if not QUIET_MODE:
        print(message)


class TestBehaviour(TaskSet):
    @task
    def task1(self):
        log("running task1")
        self.client.get("/")


class TestUser(HttpLocust):
    task_set = TestBehaviour
    min_wait = TASK_DELAY
    max_wait = TASK_DELAY
