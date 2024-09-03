# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Copy nginx config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 8000

# Run the command to start Nginx and Gunicorn
CMD service nginx start && gunicorn DemoX.wsgi:application --bind 0.0.0.0:8000
