# kics-scan ignore-block
FROM debian
RUN wget http://google.com
RUN curl http://bing.com

FROM python:3.7
RUN pip install Flask==0.11.1
RUN useradd -ms /bin/bash patrick
COPY --chown=patrick:patrick app /app
WORKDIR /app
USER patrick
CMD ["python", "app.py"]
