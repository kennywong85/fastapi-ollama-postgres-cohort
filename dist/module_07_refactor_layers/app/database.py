import psycopg
from contextlib import contextmanager

DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/llm_question_log"


@contextmanager
def get_conn():
    with psycopg.connect(DATABASE_URL) as conn:
        yield conn
