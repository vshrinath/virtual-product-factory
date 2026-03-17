---
name: cicd
description: GitHub Actions CI/CD setup and configuration. Automates testing, building, and deployment with staging gates and approval workflows. WHEN to use it - setting up GitHub Actions workflows, configuring automated testing and deployment, managing secrets in CI/CD, or implementing deployment gates and approvals.
license: MIT
metadata:
  category: ops
  handoff-from:
    - deployment
    - arch
  handoff-to:
    - cloud
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @cicd — CI/CD Pipelines (GitHub Actions)

**Philosophy:** Automate testing, building, and deployment. Humans review code, machines deploy it.

## When to use this guide
- Setting up GitHub Actions workflows
- Configuring automated testing and deployment
- Managing secrets in CI/CD
- Implementing deployment gates and approvals
- Automating release processes

---

## Core Principles

### 1. Test Before Deploy
Every deployment must pass:
- Unit tests + Integration tests
- Linting and code quality checks
- Security scans (dependencies, secrets)

### 2. Staging Before Production
- Merge to `main` → auto-deploy to staging
- Tag release → auto-deploy to production (with approval)
- Never deploy directly to production without staging validation

### 3. Rollback Plan
Every deployment must have a rollback strategy:
- Previous Docker image tagged and available
- Database migrations are backward-compatible
- Feature flags for risky changes

### 4. Secrets Management
- Never commit secrets to repo
- Use GitHub Secrets for sensitive values
- Rotate secrets quarterly
- Audit secret access logs

---

## Workflow Structure

```
.github/
└── workflows/
    ├── test.yml           # Run tests on every PR
    ├── deploy-staging.yml # Deploy to staging on merge to main
    └── deploy-prod.yml    # Deploy to production on tag
```

---

## Test Workflow (test.yml)

**Trigger:** Every push, every PR

Key steps:
- Set up language runtime (match production version exactly)
- Install dependencies from lock file
- Run linting and type checking
- Run tests with coverage reporting
- Security check (dependencies: pip-audit, npm audit)
- Security check (secrets: TruffleHog, GitLeaks)

### Key Points
- **Services:** Databases and Redis run as containers
- **Caching:** Cache pip/npm to speed up subsequent runs
- **Coverage:** Track test coverage over time
- **Fail fast:** If tests fail, don't proceed to deployment

---

## Deploy to Staging (deploy-staging.yml)

**Trigger:** Merge to `main` branch

Key steps:
- Build Docker image, tag with git SHA
- Push to container registry (ECR, GCR, etc.)
- Update service to use new image
- Run database migrations
- Verify with health check
- Notify team (Slack)

### Key Points
- **Automatic:** Deploys on every merge to main
- **Migrations:** Run before new code is deployed
- **Health check:** Verify deployment succeeded

---

## Deploy to Production (deploy-prod.yml)

**Trigger:** Git tag (e.g., `v1.0.0`)

Key steps:
- Build and tag Docker image with version number
- Tag image as `latest`
- Update service to new image (with approval gate)
- Run database migrations
- Verify health check
- Create GitHub Release with changelog
- Notify team

### Key Points
- **Manual trigger:** Only deploys when you create a tag
- **Environment protection:** Requires approval in GitHub settings
- **Versioned images:** Tags image with version number for easy rollback

---

## Deployment Workflow

```
1. Developer creates PR
   ↓
2. Tests run automatically (test.yml)
   ↓
3. Code review + approval
   ↓
4. Merge to main
   ↓
5. Auto-deploy to staging (deploy-staging.yml)
   ↓
6. Manual testing on staging
   ↓
7. Create git tag (v1.2.3)
   ↓
8. Approval required (GitHub environment protection)
   ↓
9. Deploy to production (deploy-prod.yml)
   ↓
10. Verify production health check
```

---

## Rollback Procedure

### Option 1: Revert to Previous Image
```bash
# Update service to previous task definition revision
aws ecs update-service \
  --cluster myapp-production-cluster \
  --service myapp-production-service \
  --task-definition myapp-production-task:42  # Previous revision
```

### Option 2: Deploy Previous Tag
```bash
# Delete bad tag, re-tag previous commit
git tag -d v1.2.3
git push origin :refs/tags/v1.2.3
git tag v1.2.3 <previous-commit-sha>
git push origin v1.2.3
```

---

## Monitoring Deployments

**During deployment (0-5 minutes):**
- Health check endpoint responds
- No 5xx errors in logs
- Container starts successfully

**After deployment (5-30 minutes):**
- Error rate < 1%
- Response time p95 < 500ms

**Rollback triggers:**
- Error rate > 5% for 5 minutes
- Health check fails
- Critical feature broken

---

## Best Practices

### Do:
- ✅ Run tests on every PR
- ✅ Deploy to staging automatically
- ✅ Require approval for production
- ✅ Tag production releases
- ✅ Monitor deployments for 30 minutes
- ✅ Have a rollback plan

### Don't:
- ❌ Deploy directly to production without staging
- ❌ Skip tests to "deploy faster"
- ❌ Commit secrets to repo
- ❌ Deploy on Friday afternoon

---

## Further Reading

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
