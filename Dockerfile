FROM python:3.11-slim
# Create a non-root user and group with specific UID and GID
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1908 --gid 1000 -m -s /bin/bash appuser
# Install virtualenv
RUN pip3 install --no-cache-dir --upgrade virtualenv
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    software-properties-common \
    git \
    vim \
    curl 
# Set permissions for script
#COPY run_test.sh /home/appuser/run_test.sh
#RUN chmod 777 /home/appuser/run_test.sh
# Switch to custom user
WORKDIR /home/appuser
COPY . /home/appuser/
RUN chmod 777 /home/appuser/start.sh
RUN chown -R appuser:appuser /home/appuser
USER appuser
# Set up virtual environment and install Python dependencies
ENV VIRTUAL_ENV=/home/appuser/venv
RUN virtualenv ${VIRTUAL_ENV}
RUN . ${VIRTUAL_ENV}/bin/activate && pip install -r requirements.txt
RUN pip install -r requirements.txt
# Expose port
EXPOSE 8501
# Define entrypoint
ENTRYPOINT ["./start.sh"]