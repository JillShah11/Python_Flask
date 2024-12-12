# Use an official Python runtime as the base image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents (flask app and requirements) into the container at /app
COPY . /app

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000 for Flask
EXPOSE 5000

# Set the Flask app environment variable
ENV FLASK_APP=flask-app.py

# Run Flask on container startup
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
