from enum import Enum


class ApiTestData(Enum):
    BLOCK_NUMBER = "blockNumberPayload"
    GET_BLOCK_NUMBER = "getBlockNumberPayload"
    ETH_SYNC = "ethSyncing"
    GET_BLOCK_BY_HASH = "getBlockByHsh"

    @property
    def payload(self):
        payloads = {
            "blockNumberPayload": {
                "jsonrpc": "2.0",
                "id": 0,
                "method": "eth_blockNumber",
                "params": []
            },
            "getBlockNumberPayload": {
                "jsonrpc": "2.0",
                "id": 0,
                "method": "eth_getBlockByNumber",
                "params": []
            },
            "ethSyncing": {
                "jsonrpc": "2.0",
                "id": 0,
                "method": "eth_syncing",
                "params": []
            },
            "getBlockByHsh": {
              "jsonrpc": "2.0",
              "id": 0,
              "method": "eth_getBlockByHash",
              "params": []
            }
        }
        return payloads[self.value]
