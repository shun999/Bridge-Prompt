# ベースイメージ
FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel

# タイムゾーンの設定
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# 作業ディレクトリ
WORKDIR /app

# 必要ライブラリのコピー
COPY requirements.txt .

# git + tzdata + OpenCVのインストール
RUN apt-get update \
 && apt-get install -y git \
 && apt-get install -y --no-install-recommends tzdata libopencv-dev \
 && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && rm -rf /var/lib/apt/lists/*

# Pythonライブラリのインストール
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt