FROM python:3.8-slim

WORKDIR /

COPY demo.py .

CMD ["python", "demo.py"]
