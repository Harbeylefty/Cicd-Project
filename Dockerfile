# Use Ubuntu 20.04 as the base image
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts during installation of packages
ENV DEBIAN_FRONTEND=noninteractive 

# Install Python2, Python3, and R, and curl
RUN apt-get update && \
    apt-get install -y python2 python3 r-base curl && \
    apt-get install -y python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pip2 manually and remove the script after installation to clean up the image
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py 

# Copy requirements files for Python2 and Python3
COPY requirements_py2.txt ./
COPY requirements_py3.txt ./

# Install Python2 and Python3 requirements
RUN pip2 install -r requirements_py2.txt && \
    pip3 install -r requirements_py3.txt

# Copy application codes into the container
COPY app.py ./

# Expose the port the application runs on
EXPOSE 5000

# Run python3 by default when the container starts
CMD ["python3", "app.py"]