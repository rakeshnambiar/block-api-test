import time

from locust import HttpUser, task, between, tag, LoadTestShape
from tests.verification.verification_test import getBlockHead, test_getBlockByNumber, test_getBlockByHash


class PerformanceTests(HttpUser):
    wait_time = between(1, 3)
    initialized = False
    shared_value = None
    head = None

    def on_start(self):
        if not self.initialized:
            self.head = getBlockHead(self.client)
            print(f'Block head using by the test --> {self.head}')
            if self.head == '0x0':
                print(f'Retrying as the Head did not fetched first time', flush=True)
                time.sleep(1)
                self.head = getBlockHead(self.client)
            assert self.head != '0x0', 'Assertion Error: Unexpected Block Head 0x0'

    @tag('get_block_by_number')
    @task(1)
    def benchmarkGetBlockByNumber(self):
        test_getBlockByNumber(self.head, self.client)

    @tag('get_block_by_hash')
    @task(2)
    def benchmarkGetBlockByHash(self):
        test_getBlockByHash(self.head, self.client)


class StagesShape(LoadTestShape):
    stages = [
        ##  duration is in seconds

        {"duration": 15, "users": 25, "spawn_rate": 5},
        {"duration": 30, "users": 50, "spawn_rate": 10},
        {"duration": 45, "users": 100, "spawn_rate": 20},
        {"duration": 60, "users": 200, "spawn_rate": 25},
        {"duration": 75, "users": 500, "spawn_rate": 50},

        ## Ramp-down part
        {"duration": 180, "users": 200, "spawn_rate": 25},
        {"duration": 210, "users": 50, "spawn_rate": 25},
        {"duration": 240, "users": 10, "spawn_rate": 5}

        ## requests count strctly between 1K to 10K
        # {"duration": 60, "users": 25, "spawn_rate": 5},
        # {"duration": 90, "users": 50, "spawn_rate": 10},
        # {"duration": 120, "users": 100, "spawn_rate": 20},
        # {"duration": 150, "users": 200, "spawn_rate": 25},
    ]

    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stages:
            if run_time < stage["duration"]:
                tick_data = (stage["users"], stage["spawn_rate"])
                return tick_data

        return None
