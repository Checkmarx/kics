FROM python:2.7
RUN pip install Flask==0.11.1
RUN useradd -ms /bin/bash patrick
COPY --chown=patrick:patrick app /app
WORKDIR /app
CMD ["python", "app.py"]
