# Test suite details and other info
## Tools user
- The functional tests are writen using Pytest framework
- Load / performance tests are written using Locust https://locust.io/

## Local set up
- Set the environment variable like `eport host=http://localhost:8545` (optional) and you can use any endpoint through commandline and the test will works fine as far the endpoint is valid
- Install Python 3:10
- Install pip if it's not installed already
- Run `pip install -r requirements.txt` to install the dependencies

## What are all included
- Functional or verification tests written in Pytest
- Performance tests using Locust
- Healthcheck / sync check script

## How to run the verification tests
- To run all the verification test use the command `python -m pytest -m Regression tests/verification/verification_test.py -sv --html=html-report/index.html`
- To run a specific test you can use the command `python -m pytest -m ByHash tests/verification/verification_test.py -sv --html=html-report/index.html`

## How to run the Performance tests
- To run all the test use the command `locust --locustfile tests/performance/performance_test.py --headless --host=http://localhost:8545 --stop-timeout 30 --html report.html --print-stats --csv performancetest.csv --csv-full-history -L DEBUG --logfile performancetest.log`
- To run a specific performance test, use the command `locust --locustfile tests/performance/performance_test.py --headless --host=http://localhost:8545 --spawn-rate 1 --stop-timeout 30 --tags get_block_by_number --html report.html --print-stats --csv getBlockNumber.csv --csv-full-history -L DEBUG --logfile performancetest.log`

## How to run Healthcheck locally
- Use the command `python -m utils.healthcheck`

## Reports or Results
- You will see the out of the verification report in `html-report/index.html`
- Log will be available on execution.log for Verification tests
- Performance test result is available in the `report.html` on GitHub it will be `report_batch1.html`, `report_batch2.html`
- Performance tests logs are available like `performancetest_batch1.log`, `performancetest_batch2.log
- Other stats and reports are available on the root folder

## limitations / Known issues
- Checkpoints are not excluded for performance tests
- Performance tests did not fail the test based on the response time data or error threshold
- Didn't break test separately for each verification points rather all are grouped for a specific api method
- Covered the basic or important verification and not all the test scenarios

## Room for improvements
- To avoid installing dependencies each time, build a docker image and use it / cache. Rebuild the docker images when the Dockerfile or requirements.txt changes
- Condition performance testing based on some flags. It is easy in GitLab CI but it didn't work for me with IF condition
- The sedge node sync time is dynamic. Sometime it will finish soon and sometimes it can take more than an hour which is a pain in the CI/CD environment. 
  Once know the technical background seek for some caching or something to cut down this time. I tried with snapshot sync and fast sync options but that didn't help.
- Publish the reports on GitHub pages and have a custom index.html which links to Verification and Performance reports
- It's the first time I am using GitHub workflow and I am much more comfortable with GitLab CI config. There maybe some room to avoid the duplicate steps and improvement
- Also for locust as I am using it first time
- I noticed a docker based installation on the website. However, I didn't get much time to try it. Perhaps the instruction says more about linux based installation.

## Clarifications
- The Task2 mentioned `on public JSON-RPC API` but when I referred the documentation it's all talking about the local installation and node set up.
  I would assume there is no public APIs available and it is all the local setup


## Issues noticed
- Random node syncing
- Sometimes the syncing says its finished. But while getting the block head using `eth_blockNumber` returns:
  `{'jsonrpc': '2.0', 'result': '0x0', 'id': 0}`
- Threshold based performance verification is not supported by locust I think https://github.com/locustio/locust/issues/2668

# Performance Test Results:

## Scenarios

### Minium requests 1000 made over a period of time
## Attached the report for some scenarios

#### Minium requests 1000 at a single point of time 
#### Maximum request 10,000 made over a period of time
Method/endpoint -> `eth_getBlockByNumber`
[report.html](report.html)
![Screenshot 2024-04-23 at 21.28.48.png](..%2F..%2F..%2F..%2Fvar%2Ffolders%2F7x%2F_1_sz4jx0jj04lnkc95njf640000gn%2FT%2FTemporaryItems%2FNSIRD_screencaptureui_zgc6CM%2FScreenshot%202024-04-23%20at%2021.28.48.png)

Method/endpoint -> `eth_getBlockByHash`
[report.html](report.html)
![Screenshot 2024-04-23 at 21.37.23.png](..%2F..%2F..%2F..%2Fvar%2Ffolders%2F7x%2F_1_sz4jx0jj04lnkc95njf640000gn%2FT%2FTemporaryItems%2FNSIRD_screencaptureui_SxYwGQ%2FScreenshot%202024-04-23%20at%2021.37.23.png)
#### Minimum RPS 1000 and maximum RPS 10000 over a period of time
[report.html](report.html)
![Screenshot 2024-04-23 at 21.59.28.png](..%2F..%2F..%2F..%2Fvar%2Ffolders%2F7x%2F_1_sz4jx0jj04lnkc95njf640000gn%2FT%2FTemporaryItems%2FNSIRD_screencaptureui_ELjFW8%2FScreenshot%202024-04-23%20at%2021.59.28.png)
#### Maximum request 10,000 made at a single point of time 
#### Staged load simulation approach between 1K and 10K requests
#### Ram-up and Ramp-down approach
#### Multiple end points as the server is the same 
#### Larger users over a long period of time


## Observations if any
- When I tried like 5000 users per seconds, I got error `POST /: ConnectionResetError(54, 'Connection reset by peer')`
  However the overall requests made is more than 10K. 
  [report.html](report.html) 
- One thing I noticed, the spike in No of Users and Request are in line. However, the response time spiked before and after the higher load. 

![Screenshot 2024-04-23 at 15.12.25.png](..%2F..%2FDownloads%2FScreenshot%202024-04-23%20at%2015.12.25.png)
![Screenshot 2024-04-23 at 15.34.32.png](..%2F..%2FDownloads%2FScreenshot%202024-04-23%20at%2015.34.32.png)
- Out of `eth_getBlockByNumber` and `eth_getBlockByHash`, the `eth_getBlockByHash` is much faster. I didn't compare the response fields individually though.

