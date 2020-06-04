FROM python:3.7
WORKDIR app/
COPY app.py test.py requirements.txt ./
RUN pip install -r requirements.txt
CMD ["python3", "app.py"]