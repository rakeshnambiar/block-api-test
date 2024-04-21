import logging

# Remove the default stream handler
root_logger = logging.getLogger()
if root_logger.handlers:
    for handler in root_logger.handlers:
        root_logger.removeHandler(handler)

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def create_file_handler():
    file_handler = logging.FileHandler('execution.log', mode='w')  # Truncate the file
    file_handler.setLevel(logging.INFO)  # Capture INFO-level messages and above
    file_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    return file_handler


logger = logging.getLogger()
logger.setLevel(logging.INFO)
logger.addHandler(create_file_handler())
