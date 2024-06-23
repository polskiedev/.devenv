# Use the official Ubuntu base image
FROM ubuntu:latest

# Update and install necessary packages
RUN apt-get update && apt-get install -y bash

# Copy your script into the container
COPY install.sh /usr/local/bin/install.sh

# Make the script executable
RUN chmod +x /usr/local/bin/install.sh

# Run the script when the container starts
CMD ["/usr/local/bin/install.sh"]
