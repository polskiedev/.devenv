# Stage 1: Build the initial image
FROM ubuntu:latest as builder

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    bash \
    git

# Copy your script into the container
COPY install.sh /home/ubuntu