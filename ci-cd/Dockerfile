FROM python:3.11-slim

WORKDIR /app

# First copy requirements.txt and install
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Then copy the rest of your app files
COPY app/ .

CMD ["python", "app.py"]

# This is a  second test for AWS CodePipeline
