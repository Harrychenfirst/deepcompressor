apt-get update && apt-get install -y fish git gcc g++ wget curl lsof tree python3-pip python3.12 python3.12-dev zip unzip 

pip install uv --break-system-packages -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
uv venv --python 3.12 ./.venv
source ./.venv/bin/activate
ALL_PROXY="http://public-proxy.qihoo.net:3128" uv pip install -r ./requirements.txt