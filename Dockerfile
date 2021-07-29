FROM continuumio/miniconda3

WORKDIR /app

ADD . /app

RUN sed -i "s@http://deb.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list && \
    sed -i "s@http://security.debian.org@https://repo.huaweicloud.com@g" /etc/apt/sources.list && \
    apt-get update && \
    # install prequired modules to support install of mlflow and related components
    apt-get install -y default-libmysqlclient-dev build-essential curl \
    # cmake and protobuf-compiler required for onnx install
    cmake protobuf-compiler &&  \
    conda install python=3.6 && \
    # install required python packages
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r dev-requirements.txt --no-cache-dir && \
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r test-requirements.txt --no-cache-dir && \
    # install mlflow in editable form
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -e . && \
    # mkdir required to support install openjdk-11-jre-headless
    mkdir -p /usr/share/man/man1 && apt-get install -y openjdk-11-jre-headless && \
    # install npm for node.js support
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    cd mlflow/server/js && \
    npm install && \
    npm run build
