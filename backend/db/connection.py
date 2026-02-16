"""
Database connection helpers (MySQL 8+).

Reads connection settings from environment variables:
- DB_HOST (default: localhost)
- DB_PORT (default: 3306)
- DB_USER (default: root)
- DB_PASSWORD (default: "")
- DB_NAME (default: "")

This module intentionally avoids hard-coding credentials.
"""

from __future__ import annotations

from contextlib import contextmanager
from dataclasses import dataclass
import os
from typing import Any, Dict, Generator, Optional


@dataclass(frozen=True)
class DBConfig:
    host: str
    port: int
    user: str
    password: str
    database: str

    @staticmethod
    def from_env() -> "DBConfig":
        return DBConfig(
            host=os.getenv("DB_HOST", "localhost"),
            port=int(os.getenv("DB_PORT", "3306")),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", ""),
            database=os.getenv("DB_NAME", ""),
        )


def _connect_with_mysql_connector(cfg: DBConfig):
    import mysql.connector  # type: ignore

    return mysql.connector.connect(
        host=cfg.host,
        port=cfg.port,
        user=cfg.user,
        password=cfg.password,
        database=cfg.database or None,
        autocommit=False,
    )


def _connect_with_pymysql(cfg: DBConfig):
    import pymysql  # type: ignore

    return pymysql.connect(
        host=cfg.host,
        port=cfg.port,
        user=cfg.user,
        password=cfg.password,
        database=cfg.database or None,
        autocommit=False,
        cursorclass=pymysql.cursors.DictCursor,
    )


def get_connection(config: Optional[DBConfig] = None):
    """
    Create and return a new DB connection.

    Tries `mysql-connector-python` first (`mysql.connector`), then falls back to `PyMySQL`.
    """

    cfg = config or DBConfig.from_env()

    last_err: Optional[Exception] = None

    try:
        return _connect_with_mysql_connector(cfg)
    except Exception as e:  # pragma: no cover
        last_err = e

    try:
        return _connect_with_pymysql(cfg)
    except Exception as e:  # pragma: no cover
        last_err = e

    raise RuntimeError(
        "No MySQL driver available. Install one of: mysql-connector-python or PyMySQL."
    ) from last_err


@contextmanager
def db_cursor(
    *,
    config: Optional[DBConfig] = None,
    commit: bool = False,
    cursor_kwargs: Optional[Dict[str, Any]] = None,
) -> Generator[Any, None, None]:
    """
    Context manager that yields a cursor and ensures resources are closed.

    - If `commit=True`, commits on success and rolls back on error.
    - If `commit=False`, never commits automatically (but still rolls back on error).
    """

    conn = get_connection(config=config)
    cur = None
    try:
        cur = conn.cursor(**(cursor_kwargs or {}))
        yield cur
        if commit:
            conn.commit()
    except Exception:
        try:
            conn.rollback()
        finally:
            raise
    finally:
        if cur is not None:
            try:
                cur.close()
            except Exception:
                pass
        try:
            conn.close()
        except Exception:
            pass


