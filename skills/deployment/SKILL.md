---
name: deployment
description: Universal deployment principles — multi-stage builds, dependency locking, environment parity, rollback plans, and container security. WHEN to use it - setting up Docker builds, establishing dependency management, configuring environment variables, optimizing build performance, or ensuring production-ready container security.
license: MIT
metadata:
  category: ops
  handoff-from:
    - dev
    - arch
  handoff-to:
    - cicd
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @deployment — Deployment Practices

**Philosophy:** Build artifacts should be deterministic, reproducible, and fail fast when misconfigured.

## When to use this guide
- Setting up Docker builds for any language/framework
- Establishing dependency management practices
- Configuring environment variables and secrets
- Optimizing build performance and image size
- Ensuring production-ready container security

## Core Principles

### 1. Multi-Stage Docker Builds

**Why:** Separate build-time dependencies from runtime. Reduces image size 50-80%, improves security, faster deployments.

**Pattern:**
```dockerfile
# Stage 1: Builder — includes compilers, build tools
FROM base-image AS builder
RUN install build dependencies
COPY dependency-lock-file .
RUN compile/install dependencies

# Stage 2: Runtime — only runtime libraries
FROM base-image AS runtime
RUN install runtime dependencies only
COPY --from=builder /compiled-artifacts /app
COPY application-code /app
```

### 2. Dependency Locking

**Why:** Prevent "works on my machine" issues. Transitive dependencies can update between builds.

**Pattern:**
1. **Source file** (human-maintained): Lists direct dependencies with loose version constraints
2. **Lock file** (machine-generated): Pins exact versions of all dependencies
3. **Never edit lock files manually**
4. **Commit lock files to version control**

### 3. Environment Variable Validation

**Why:** Fail fast at startup if critical configuration is missing.

**Pattern:**
```python
REQUIRED_VARS = ['DATABASE_URL', 'SECRET_KEY', 'API_KEY']

for var in REQUIRED_VARS:
    if not os.environ.get(var):
        raise ValueError(f"{var} environment variable is not set")
```

**Rules:**
- Required variables: Crash if missing (no defaults)
- Optional variables: Provide sensible defaults with comments
- Never hardcode secrets
- Document all variables in `.env.example`

### 4. Non-Root Container User

**Why:** Security best practice. Limits damage if container is compromised.

**Pattern:**
```dockerfile
RUN useradd -ms /bin/bash appuser
COPY --chown=appuser:appuser . /app
USER appuser
```

### 5. Health Checks

**Why:** Container orchestrators need to know if your app is healthy.

**Pattern:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1
```

### 6. Settings Hierarchy

**Why:** Clear separation between environments.

**Pattern:**
```
settings/
├── base.py          # Shared settings, env var parsing
├── development.py   # Local dev overrides
├── staging.py       # Staging overrides
└── production.py    # Production overrides
```

---

## Checklist: Production-Ready Dockerfile

- [ ] Multi-stage build (builder + runtime)
- [ ] Dependencies installed from lock file
- [ ] .dockerignore excludes unnecessary files
- [ ] Non-root user created and used
- [ ] Health check defined
- [ ] Environment variables validated at startup
- [ ] No secrets hardcoded in image
- [ ] Build dependencies excluded from runtime stage
- [ ] Image size optimized (< 500MB for most apps)
- [ ] Reproducible builds (same inputs = same output)

---

## Common Mistakes

### ❌ Installing build tools in runtime stage
```dockerfile
FROM python:3.11
RUN apt-get install gcc build-essential  # Don't do this
```

### ✅ Use multi-stage build
```dockerfile
FROM python:3.11 AS builder
RUN apt-get install gcc build-essential

FROM python:3.11 AS runtime
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
```

### ❌ Silent fallback for missing config
```python
API_KEY = os.environ.get('API_KEY', 'default-key-12345')
```

### ✅ Fail fast
```python
API_KEY = os.environ.get('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY environment variable is required")
```

---

## Further Reading

- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [12-Factor App: Config](https://12factor.net/config)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
