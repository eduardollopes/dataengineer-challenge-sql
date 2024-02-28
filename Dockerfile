FROM python:3.9-alpine

RUN apk --no-cache add sqlite

COPY sql/create_tables.sql /create_tables.sql
COPY sql/create_triggers.sql /create_triggers.sql
COPY sql/create_trigger_events.sql /create_trigger_events.sql
COPY sql/business_responses.sql /business_responses.sql
COPY src/ingestion.py /ingestion.py
COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /requirements.txt

RUN sqlite3 /mydatabase.db < /create_tables.sql
RUN sqlite3 /mydatabase.db < /create_triggers.sql
RUN sqlite3 /mydatabase.db < /create_trigger_events.sql
RUN sqlite3 /mydatabase.db < /business_responses.sql

RUN python /ingestion.py

CMD ["sqlite3", "/mydatabase.db"]
