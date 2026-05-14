# ---------- builder ----------
FROM python:3.14-slim AS builder

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never

RUN pip install --no-cache-dir uv==0.4.27

WORKDIR /app
COPY pyproject.toml ./
# COPY uv.lock ./

RUN uv venv /opt/venv && \
    VIRTUAL_ENV=/opt/venv uv pip install --no-cache .

# ---------- runtime ----------
FROM python:3.14-slim

ENV PATH=/opt/venv/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=builder /opt/venv /opt/venv

WORKDIR /app
COPY src/ ./src/

RUN useradd --create-home --uid 1000 appuser && chown -R appuser /app
USER appuser

ARG COMMAND="src.train"

ENTRYPOINT ["python", "-m"]
CMD [${COMMAND}]