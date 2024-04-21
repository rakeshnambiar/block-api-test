import time

from locust import HttpUser, task, between, tag
from tests.verification.verification_test import getBlockHead, test_getBlockByNumber, test_getBlockByHash


class PerformanceTests(HttpUser):
    wait_time = between(1, 3)
    initialized = False
    shared_value = None
    head = None

    def on_start(self):
        if not self.initialized:
            self.head = getBlockHead()
            print(f'Block head using by the test --> {self.head}')

    @tag('get_block_by_number')
    @task(1)
    def benchmarkGetBlockByNumber(self):
        test_getBlockByNumber(self.head, self.client)

    @tag('get_block_by_hash')
    @task(1)
    def benchmarkGetBlockByHash(self):
        test_getBlockByHash(self.head, self.client)
