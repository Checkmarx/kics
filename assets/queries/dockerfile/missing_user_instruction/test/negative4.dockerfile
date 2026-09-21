from python:2.7
run pip install Flask==0.11.1
run useradd -ms /bin/bash patrick
copy --chown=patrick:patrick app /app
workdir /app
user patrick
cmd ["python", "app.py"]

from scratch
run pip install Flask==0.11.1
run useradd -ms /bin/bash patrick
copy --chown=patrick:patrick app /app
workdir /app
cmd ["python", "app.py"]
