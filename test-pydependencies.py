import subprocess
import os
import sys

container_name = 'ubuntuthm'
result = False


def create_logger(debug: bool=True):
    logger = logging.getLogger(__name__)
    if debug:
        logger.setLevel(logging.DEBUG)
    else:
        logger.setLevel(logging.INFO)
    
    # Stream handler
    stream_formatter = logging.Formatter('[%(asctime)s] %(levelname)s - %(module)s.%(funcName)s: %(message)s')
    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(stream_formatter)

    if debug:
        stream_handler.setLevel(logging.DEBUG)
    else:
        stream_handler.setLevel(logging.INFO)

    logger.addHandler(stream_handler)

    return logger

def run_docker_cmd(cmd: str):
    docker_cmd = f'docker exec {container_name} {cmd}'
    run_cmd(docker_cmd)

def run_cmd(cmd: str):
    logger.info(f'\nRunning CMD: {cmd}')
    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, 
        universal_newlines=True, shell=True) as p:
        out, err = p.communicate()
    return out, err

def main():
    dep_list =[]

    with open('requirements.txt', 'r') as f:
        dep_list = f.readlines()
    
    for dep in dep_list:
        out, err = run_docker_cmd(f'pip freeze | grep -i {dep}')
        logger.info(f'output: {out}')
        logger.info(f'error: {err}')


if __name__ == "__main__":
    logger = create_logger()
    main()
    sys.exit(result)