# Consultancy Channeling System

A role-based hospital channeling and laboratory management system.

## Teams

- Team 1: Patient
- Team 2: Doctor
- Team 3: Admin
- Team 4: Laboratory

## Tech Stack

- Backend: Python
- Frontend: Streamlit
- Database: MySQL

## Setup (Python virtualenv)

### Windows (PowerShell)

```powershell
.\scripts\setup_venv.ps1
.\.venv\Scripts\Activate.ps1
```

### macOS / Linux

```bash
chmod +x scripts/setup_venv.sh
./scripts/setup_venv.sh
source .venv/bin/activate
```

### Environment variables

- Copy `.env.example` to `.env` and fill in your MySQL credentials.
- Used by `backend/db/connection.py`: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`.
