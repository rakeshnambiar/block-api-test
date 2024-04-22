import time
from requests import RequestException
from conftest import logger
from tests.base.base_api_test import make_post_request
from tests.data.test_data import ApiTestData


def check_health(payload, max_retries=150000, retry_interval=5):
    retries = 0
    while retries < max_retries:
        try:
            response_data = make_post_request(ApiTestData.ETH_SYNC.payload)
            if response_data:
                print('Response : ', response_data, flush=True)
                if response_data['result'] is False:
                    return True
            else:
                print(f'Unexpected response during sync check {response_data} for the method : {payload["method"]}', flush=True)
        except RequestException as e:
            logger.error("Unexpected Error:", e)
        retries += 1
        time.sleep(retry_interval)
        print(f'Retrying the health check - {retries}', flush=True)
    return False


if __name__ == "__main__":
    print('Checking API health check and sync status', flush=True)
    is_healthy = check_health(ApiTestData.ETH_SYNC.payload)
    if is_healthy:
        print("API is healthy", flush=True)
    else:
        raise RequestException("API is not healthy or unreachable")
