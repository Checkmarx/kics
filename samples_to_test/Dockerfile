# Use an official Python runtime as a parent image
FROM group-docker-61.nexuscloud.aws.rabo.cloud/python:3.12-slim AS builder


ENV POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_CACHE_DIR=/opt/.cache

# Pin to Nexus as it is not picked up by build agent
RUN pip install \
    --no-cache-dir \
    --index-url https://nexus3.rabobank.nl/repository/pypi-proxy/simple \
    --trusted-host nexus3.rabobank.nl \
    poetry=2.1

WORKDIR /app

COPY pyproject.toml poetry.lock ./

# This picks up the pyproject.toml primary source thus Nexus.
RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --no-root --without dev

FROM group-docker-61.nexuscloud.aws.rabo.cloud/python:3.12-slim AS runtime

# Checkmarx scanner: High Risk - create non-root user.
RUN adduser --system --group --no-create-home appuser

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv
ENV PATH="/app/.venv/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY rabobank_unitycatalog /app/rabobank_unitycatalog

# NOG TE DOEN: This is very slow...
RUN chown -R appuser:appuser /app

USER appuser

CMD ["fastapi", "run", "rabobank_unitycatalog/api/main.py"]
