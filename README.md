# SDI 4213 Week 9 - Help Desk DevSecOps

Streamlit Help Desk application with PostgreSQL, Adminer, and automated security checks.

## Run locally

Use Python 3.13 and Docker Desktop with Linux containers.

```powershell
Copy-Item .env.example .env
# Set a local development password in .env before starting the stack.
python -m venv .venv
.\.venv\Scripts\python -m pip install -r requirements.txt
.\.venv\Scripts\python -m pytest -v
docker compose up -d --build
docker compose ps
```

Open the application at http://localhost:8501 and Adminer at http://localhost:8080.
The database uses the named `helpdesk_data` volume. PostgreSQL 18 stores its
versioned data beneath `/var/lib/postgresql`, so Compose mounts that directory.
Use `docker compose down` to stop the stack while retaining its data.

## Week 9 security controls

- `.env` stays local: both Git and Docker ignore it. `.env.example` contains only placeholders.
- Dependabot checks root pip and GitHub Actions dependencies weekly.
- The Dockerfile creates `appuser` (UID 10001), grants access to `/app`, and switches to that user before starting Streamlit on port 8501.
- The existing CI runs pytest. `Security Checks` rejects tracked `.env`, builds the image, and requires a non-zero runtime UID on pull requests and pushes to `main`.

```powershell
git check-ignore -v .env
git ls-files .env
docker build -t helpdesk:week9-after .
docker run --rm --entrypoint id helpdesk:week9-after -u
```

The UID must be `10001`; `git ls-files .env` must print nothing.

## Docker Scout evidence

Docker Scout requires a Docker account sign-in. The baseline was built from the
starter Dockerfile before changing its runtime user and retained locally as
`helpdesk:week9-before`.

```powershell
docker scout cves helpdesk:week9-before
docker scout recommendations helpdesk:week9-before
```

Scout inventories installed packages in an SBOM and matches them against known
vulnerabilities. Non-root execution reduces privileges; it does not remove package
CVEs. See the submission evidence PDF for the actual findings and reflections.

## Course workflow

Issue: https://github.com/jwm-dev/sdi4213-week9-devsecops/issues/1

Implementation branch: `security/week9-devsecops`.
The submission package contains the evidence PDF, source snapshot, and review notes.
The original exercise and starter references are retained under `docs/` and
`student-resources/`.
