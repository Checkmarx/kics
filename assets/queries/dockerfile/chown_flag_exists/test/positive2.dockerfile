from python:3.7
run pip install Flask==0.11.1
run useradd -ms /bin/bash patrick
copy --chown=patrick:patrick app /app
workdir /app
user patrick
cmd ["python", "app.py"]
