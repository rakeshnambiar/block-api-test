## Local set up
- Set the environment variable like `eport host=http://localhost:8545`
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

## Issues noticed
- Random node syncing
- Sometimes the syncing says its finished. But while getting the block head using `eth_blockNumber` returns:
  `{'jsonrpc': '2.0', 'result': '0x0', 'id': 0}`