FROM python:3.9-slim

WORKDIR /app

COPY Source-code/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY Source-code/. .

EXPOSE 5000

CMD ["python", "app.py"]

