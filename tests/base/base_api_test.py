import os
import requests
from conftest import logger


base_url = os.environ.get('host', 'http://localhost:8545')


def verify_response(response):
    assert response.status_code == 200, f"Request failed with status code: {response.status_code}"


def make_post_request(payload, client=None, endpoint=None):
    if endpoint is None:
        url = f"{base_url}/"
    else:
        url = f"{base_url}/{endpoint}"
    logger.info(f'Making a POST request on the {url} with the data {payload}')

    try:
        if client:
            response = client.post(url, json=payload)
        else:
            response = requests.post(url, json=payload)
        response.raise_for_status()
        verify_response(response)
        logger.info(f'Response of POST request on the {url} with the data {payload}')

        response_json = response.json()
        logger.info(response_json)
        return response_json
    except requests.RequestException as e:
        logger.error(f"Error making POST request: {e}")
        return None


def check_key_errors(data):
    if isinstance(data, dict):
        for key, value in data.items():
            if key == "error":
                print(f"Key name error found: {key}", flush=True)
                return True
            if value == "error":
                print(f"Error value found for key: {key}", flush=True)
                return True
            if check_key_errors(value):
                return True
    elif isinstance(data, list):
        for item in data:
            if check_key_errors(item):
                return True
    return False


def assertStartPattern(key):
    assert key.startswith("0x"), f"key: {key} in the response not starts with 0x"
