FROM python:3.14-slim
COPY main.py ./main.py
CMD ["python3", "-u", "main.py"]

