# ベースイメージ
FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel

# タイムゾーンの設定
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# 作業ディレクトリ
WORKDIR /app

# 必要ライブラリのコピー
COPY requirements.txt .

# git + tzdata + OpenCV のインストール
RUN apt-get update \
 && apt-get install -y git \
 && apt-get install -y --no-install-recommends tzdata libopencv-dev \
 && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && rm -rf /var/lib/apt/lists/*

# uv のインストール
RUN python3 -m pip install --upgrade pip uv

# uv で Python 3.10 の仮想環境を作成
RUN uv python install 3.10 && \
    uv venv /opt/venv --python 3.10

ENV PATH=/opt/venv/bin:$PATH

# Pythonライブラリのインストール
RUN uv pip install --python /opt/venv/bin/python -r requirements.txt