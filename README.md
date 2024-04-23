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
- To run all the verification test use the command `python -m pytest -m Regression tests/verification/verification_test.py -sv`
- To run a specific test you can use the command `python -m pytest -m ByHash tests/verification/verification_test.py -sv`

## How to run the Performance tests
- To run all the test use the command `locust --locustfile tests/performance/performance_test.py --headless --host=http://localhost:8545 --stop-timeout 30 --html report.html --print-stats --csv performancetest.csv --csv-full-history -L DEBUG --logfile performancetest.log`
- To run a specific performance test, use the command `locust --locustfile tests/performance/performance_test.py --headless --host=http://localhost:8545 --spawn-rate 1 --stop-timeout 30 --tags get_block_by_number --html report.html --print-stats --csv getBlockNumber.csv --csv-full-history -L DEBUG --logfile performancetest.log`

## How to run Healthcheck locally
- Use the command `python -m utils.healthcheck`

## limitations / Known issues
- Checkpoints are not excluded for performance tests
- Performance tests did not fail the test based on the response time data or error threshold
- Didn't break test separately for each verification points rather all are grouped for a specific api method
- Covered the basic or important verification and not all the test scenarios