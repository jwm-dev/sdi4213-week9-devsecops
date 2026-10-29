FROM python:3.13-slim

WORKDIR /app

RUN useradd --create-home --uid 10001 appuser \
    && chown appuser:appuser /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser app ./app

EXPOSE 8501

USER appuser

CMD ["streamlit", "run", "app/main.py", "--server.address=0.0.0.0", "--server.port=8501"]
