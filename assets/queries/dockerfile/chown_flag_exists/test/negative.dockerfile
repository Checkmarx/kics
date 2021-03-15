FROM python:3.7
RUN pip install Flask==0.11.1
RUN useradd -ms /bin/bash patrick
COPY app /app
WORKDIR /app
USER patrick
CMD ["python", "app.py"]
