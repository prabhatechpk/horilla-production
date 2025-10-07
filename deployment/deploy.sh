#!/bin/bash
set -e

echo "Deploying Horilla HRMS..."

# Check if virtual environment exists
if [ ! -d "horillavenv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv horillavenv
fi

# Activate virtual environment
source horillavenv/bin/activate

# Install/update dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file not found!"
    echo "Please create .env file from .env.example"
    exit 1
fi

# Run migrations
echo "Running migrations..."
python3 manage.py makemigrations
python3 manage.py migrate

# Compile messages
echo "Compiling translations..."
python3 manage.py compilemessages

# Collect static files
echo "Collecting static files..."
python3 manage.py collectstatic --noinput

echo "Deployment complete!"
echo "Restart gunicorn service: sudo systemctl restart gunicorn"
