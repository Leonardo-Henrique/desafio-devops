FROM alpine:3.7

RUN apk --no-cache add py-pip libpq python-dev curl

RUN pip install flask python-consul

ADD / /app

WORKDIR /app

HEALTHCHECK CMD curl --fail http://localhost:5000/health || exit 1

CMD python app.py & python admin.py