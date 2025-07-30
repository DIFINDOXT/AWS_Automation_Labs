FROM python:3.8

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

HEALTHCHECK --interval=30s CMD curl -f http://localhost:5000 || exit 1

CMD ["python", "app.py"]

