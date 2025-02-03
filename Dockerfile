#ARG BASE_IMAGE=nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04
ARG BASE_IMAGE=python:3.11-slim

# hadolint ignore=DL3006
FROM ${BASE_IMAGE}

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# This line to prevent: ImportError: libGL.so.1: cannot open shared object file: No such file or directory
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

WORKDIR /workspace

ENV HF_HOME=/workspace/.cache
ENV TRANSFORMERS_CACHE=/workspace/.cache
ENV HF_HUB_CACHE=/workspace/.cache

COPY ./requirements.txt /workspace/requirements.txt
RUN pip install --no-cache-dir -r /workspace/requirements.txt

COPY ./marker /workspace/marker
COPY ./marker_server.py /workspace/marker_server.py


EXPOSE 8000
CMD ["python3", "/workspace/marker_server.py"]