import pytest

from tests.base.base_api_test import make_post_request, check_key_errors, assertStartPattern
from tests.data.test_data import ApiTestData


@pytest.mark.ByNumber
@pytest.mark.Regression
def test_getBlockByNumber(block_head=None, client=None):
    if block_head is None:
        block_head = getBlockHead(client)
    getBlockResponse = getBlockNumberResponse(block_head, client)
    print(f'getBlockResponse -> {getBlockResponse}', flush=True)
    assert getBlockResponse, "API response is empty"
    assert len(getBlockResponse['result']) > 0, "Key 'result' is 0"
    assert check_key_errors(getBlockResponse) is False, "One or more key has the error value"
    assert len(getBlockResponse['result']) > 10, "API response has less keys than expected"
    assertStartPattern(getBlockResponse['result']['author'])
    assertStartPattern(getBlockResponse['result']['hash'])


@pytest.mark.ByHash
@pytest.mark.Regression
def test_getBlockByHash(block_head=None, client=None):
    if block_head is None:
        block_head = getBlockHead(client)
    assert block_head != '0x0', 'Assertion Error: Unexpected Block Head 0x0'
    block_hash = getBlockHash(block_head, client)
    getBlockReceiptPayload = ApiTestData.GET_BLOCK_BY_HASH.payload
    getBlockReceiptPayload['params'] = [block_hash]
    getBlockResponse = make_post_request(getBlockReceiptPayload, client)
    print(f'getBlockResponse -> {getBlockResponse}', flush=True)
    assert getBlockResponse, "API response is empty"
    assert check_key_errors(getBlockResponse) is False, "One or more key has the error value"
    assert len(getBlockResponse['result']) > 0, "Key 'result' is 0"
    assert getBlockResponse['result']['hash'] == block_hash
    assert getBlockResponse['result']['number'] == block_head
    assertStartPattern(getBlockResponse['result']['author'])
    assertStartPattern(getBlockResponse['result']['parentHash'])


def getBlockHead(client=None):
    blockNumberResponse = make_post_request(ApiTestData.BLOCK_NUMBER.payload, client)
    print(f'Block head response -> {blockNumberResponse}', flush=True)
    head = blockNumberResponse['result']
    print(f'Block head --> {head}', flush=True)
    return head


def getBlockNumberResponse(block_head, client=None):
    getBlockNumberPayload = ApiTestData.GET_BLOCK_NUMBER.payload
    getBlockNumberPayload['params'] = [block_head, True]
    return make_post_request(getBlockNumberPayload, client)


def getBlockHash(blockHead, client=None):
    getBlockResponse = getBlockNumberResponse(blockHead, client)
    return getBlockResponse['result']['hash']
