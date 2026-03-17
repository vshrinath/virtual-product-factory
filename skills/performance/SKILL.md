---
name: performance
description: Identifies and fixes backend performance bottlenecks in databases, queries, and APIs. Measures first, optimizes for N+1 queries, missing indexes, and caching strategies. WHEN to use it - when performance issues are reported, before launching high-traffic features, during code review for inefficiencies, or quarterly for audits.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
    - guard
  handoff-to:
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @performance — Backend Performance Optimization

**Role**: Identify and fix performance bottlenecks in backend systems, databases, and APIs

**When to use**: When optimizing slow queries, API response times, server resource usage, or database performance

**Secondary skills**: `@frontend-perf` (client-side performance), `@dev` (implementation), `@qa` (performance testing)

**Philosophy:** Measure first, optimize second. Premature optimization is the root of all evil, but ignoring performance until production breaks is worse.

## When to invoke
- Performance issues reported (slow pages, timeouts)
- Before launching high-traffic features
- During code review when obvious inefficiencies exist
- Quarterly performance audits
- When adding features that touch hot paths

## Responsibilities
- Profile and identify backend bottlenecks
- Optimize database queries (N+1, missing indexes)
- Implement caching strategies (Redis, database query caching)
- Optimize API response times
- Validate optimizations with measurements

**Note**: For frontend/client-side performance (bundle size, Core Web Vitals, image optimization), see `@frontend-perf`.

---

## Core Principles

### 1. Measure Before Optimizing

**Never optimize without data.**

Profile first. Identify which specific operation is slow before changing anything.

**Tools by layer:**
- Backend: language profiler (cProfile, py-spy, rack-mini-profiler, pprof), ORM query logging
- Database: `EXPLAIN ANALYZE`, slow query log
- Network: browser DevTools Network tab, waterfall analysis
- API: APM tools (New Relic, DataDog, Sentry Performance)

**Note**: For frontend profiling (Lighthouse, bundle analysis, Core Web Vitals), see `@frontend-perf`.

### 2. Optimize the Bottleneck

**80% of time is spent in 20% of code. Find that 20%.**

Typical bottlenecks in order of frequency:
1. Database queries (N+1, missing indexes, full table scans)
2. External API calls (no timeout, no caching, sequential where parallel would work)
3. Large file processing (images, PDFs, videos)
4. Algorithmic complexity (O(n²) when O(n) exists)
5. Memory leaks or inefficient data structures

**Note**: For frontend bottlenecks (bundle size, JavaScript performance, rendering), see `@frontend-perf`.

### 3. Set Performance Budgets

**Define acceptable limits before building.**

Example budgets:
- API response time (p95): < 500ms
- Database query time (p95): < 100ms
- Background job processing time: < 30s
- Memory usage per request: < 100MB

**Note**: For frontend performance budgets (LCP, TTI, bundle size), see `@frontend-perf`.

---

## API Performance

### Response Time Optimization

**Parallel vs Sequential Requests**
```
# Pseudocode — applies to any language
# ❌ Bad - sequential (total time = sum of all requests)
user = fetch_user(id)
posts = fetch_posts(user.id)
comments = fetch_comments(user.id)

# ✅ Good - parallel (total time = slowest request)
user, posts, comments = await_all([
    fetch_user(id),
    fetch_posts(id),
    fetch_comments(id)
])
```

### Pagination

Always paginate large result sets. Never return unbounded lists.

```
# Pseudocode
# Cursor-based pagination (preferred for real-time data)
articles = Article.filter(id__gt=cursor).limit(20)

# Offset-based pagination (simpler, but slower for large offsets)
articles = Article.offset(page * page_size).limit(page_size)
```

### Background Jobs

Move slow operations out of the request/response cycle:
- Email sending
- Image processing
- Report generation
- External API calls that can be async
- Bulk data imports

---

## Database Performance

### N+1 Query Problem

**Problem:** Executing one query per item in a loop instead of one query for all items.

```
# Pseudocode — applies to any ORM
articles = load_all_articles()
for article in articles:
    print(article.author.name)  # Hits DB every iteration — N+1
```

**Fix:** Use eager loading (JOIN or separate batch query) to load related records upfront.

```
# Pseudocode
articles = load_articles_with_authors()  # 1 query (JOIN)
for article in articles:
    print(article.author.name)  # No additional query
```

**Rule of thumb:**
- For `has-one` / `belongs-to` relations → JOIN (SQL `LEFT JOIN`)
- For `has-many` / `many-to-many` → separate batched query

### Missing Indexes

**Problem:** Full table scans on columns used in WHERE, ORDER BY, or JOIN conditions.

**When to add indexes:**
- Columns frequently used in WHERE clauses
- Columns used in ORDER BY
- Foreign key columns (most ORMs add these automatically)
- Columns used in JOIN conditions
- Unique constraints (slug, email)

**When NOT to add indexes:**
- Small tables (< ~1,000 rows) — index overhead not worth it
- Columns rarely queried
- Low-cardinality columns with skewed distribution (e.g., a boolean that's 99% true)
- Write-heavy tables where INSERT/UPDATE speed matters more than read speed

**Verify with EXPLAIN:** Always run `EXPLAIN ANALYZE` (PostgreSQL/MySQL) or `EXPLAIN QUERY PLAN` (SQLite) to confirm the index is being used.

### Query Optimization Patterns

```
# Load only the fields you need (pseudocode)
articles = Article.select('id', 'title', 'published_date')  # Not SELECT *

# Use count at the database level, not in application code
count = Article.count()  # Not len(Article.all())

# Use existence check, not count
exists = Article.exists(slug=slug)  # Not Article.count(slug=slug) > 0

# Aggregate at the database level
total_views = Article.sum('views')  # Not sum(a.views for a in articles)
```

### Connection Pooling

Keep database connections alive across requests rather than opening a new connection per request. Configure your framework's `CONN_MAX_AGE` / `pool_size` / equivalent setting. Most production apps should have this enabled.

---

## Caching Strategy

### When to Cache

**Cache when:**
- Data changes infrequently (< once per hour)
- Computation or query is expensive (> 100ms)
- Data is accessed frequently (> 10 requests/minute per key)
- External API calls — always cache with a TTL

**Don't cache when:**
- Data changes frequently or is user-specific per-request
- Computation is cheap (< 10ms)
- Cache invalidation logic would be more complex than the problem it solves
- Data must be fresh (financial data, inventory)

### Cache Layers

```
┌─────────────────┐
│  Browser Cache  │  Static assets (CSS, JS, images) — long TTL, versioned URLs
└────────┬────────┘  (See @frontend-perf for client-side caching)
         │
┌────────▼────────┐
│   CDN Cache     │  Static assets + public API responses — medium TTL
└────────┬────────┘
         │
┌────────▼────────┐
│  App Cache      │  Database query results, computed values — short TTL
│  (Redis/Memcached/in-memory)                             │
└────────┬────────┘
         │
┌────────▼────────┐
│    Database     │  Source of truth
└─────────────────┘
```

### Cache Invalidation Rules

- Always set a TTL — never cache without expiry
- Use user-specific cache keys for user-specific data: `user:{id}:profile`, not `user:profile`
- Invalidate on write: when data changes, delete or update the relevant cache keys
- Prefer shorter TTLs + stale-while-revalidate over long TTLs that serve stale data

---

## Performance Checklist

### Backend
- [ ] No N+1 queries (use eager loading)
- [ ] Indexes on filtered/sorted/joined columns
- [ ] Database connection pooling enabled
- [ ] Expensive queries cached with appropriate TTL
- [ ] API responses use HTTP cache headers where appropriate
- [ ] Large result sets paginated
- [ ] Slow operations moved to background jobs
- [ ] External API calls have timeouts and retries
- [ ] Parallel requests used where possible

### Monitoring
- [ ] Performance budgets defined and tracked
- [ ] Slow query alerts configured (threshold depends on your p95 target)
- [ ] Error rate alerts configured
- [ ] APM or observability tool in place
- [ ] Database query performance monitored

**Note**: For frontend performance checklist (bundle size, Core Web Vitals, images), see `@frontend-perf`.

---

## Framework-Specific Notes

### Django (Python)

```python
# Eager loading
articles = Article.objects.select_related('author')       # FK/OneToOne (JOIN)
articles = Article.objects.prefetch_related('tags')       # M2M/reverse FK (separate query)

# Load only needed fields
articles = Article.objects.only('id', 'title', 'published_date')
articles = Article.objects.defer('content')  # Skip large field

# Aggregate at DB level
from django.db.models import Sum, Count
total = Article.objects.aggregate(Sum('views'))['views__sum']
count = Article.objects.count()
exists = Article.objects.filter(slug=slug).exists()

# Caching
from django.core.cache import cache
result = cache.get('trending')
if result is None:
    result = compute_trending()
    cache.set('trending', result, 3600)  # 1 hour TTL

# Connection pooling
DATABASES = {'default': {'CONN_MAX_AGE': 600, 'CONN_HEALTH_CHECKS': True}}
```

---

## Further Reading

- [Django Database Optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/)
- [Use The Index, Luke](https://use-the-index-luke.com/) — database index deep dive
- [High Performance Browser Networking](https://hpbn.co/)
