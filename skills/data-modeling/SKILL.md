---
name: data-modeling
description: Designs schemas, model relationships, and migration strategies. Ensures data integrity and performance through normalization, indexing, and constraints. WHEN to use it - designing new models/tables, planning database migrations, optimizing query performance, reviewing data relationships, or scaling database design.
license: MIT
metadata:
  category: coding
  handoff-from:
    - arch
  handoff-to:
    - dev
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @data-modeling — Database Design & Data Modeling

**Philosophy:** Schema design is architecture. Get it right early, or pay the migration cost later.

## When to invoke
- Designing new models/tables
- Planning database migrations
- Optimizing query performance
- Reviewing data relationships
- Scaling database design

## Responsibilities
- Design normalized schemas
- Define relationships and constraints
- Plan indexes for performance
- Ensure data integrity
- Consider migration strategies

---

## Core Principles

### 1. Normalization

**Eliminate redundancy, ensure data integrity.**

**First Normal Form (1NF):** Each column holds atomic values (no arrays, no comma-separated lists). Each row is unique.

```
# ❌ Not 1NF — array stored in a column
articles: id | title | tags
         1  | "Foo" | "python,django,web"

# ✅ 1NF — separate table
articles: id | title
tags:     id | name | article_id
```

**Second Normal Form (2NF):** Must be in 1NF. All non-key columns depend on the entire primary key (no partial dependencies).

**Third Normal Form (3NF):** Must be in 2NF. No transitive dependencies — non-key columns must not depend on other non-key columns.

```
# ❌ Not 3NF — author_email depends on author_id, not article_id
articles: id | title | author_id | author_name | author_email

# ✅ 3NF — separate authors table
authors:  id | name | email
articles: id | title | author_id  →  FK to authors
```

### 2. Denormalization (When Needed)

**Trade redundancy for read performance.**

Sometimes it's correct to store derived or duplicated data. Do this deliberately, not by accident.

**When to denormalize:**
- Read-heavy workloads (> 10:1 read/write ratio)
- Expensive JOINs on very large tables that must be fast
- Aggregated counters (view count, like count) that are expensive to compute on the fly
- Caching computed values that rarely change

**When NOT to denormalize:**
- Write-heavy workloads
- Data that changes frequently
- Consistency is critical (financial data, inventory)

**The cost:** You must keep denormalized copies in sync. Every write that changes source data must also update the cached copy.

---

## Relationships

**One-to-Many (most common)**
```
Author (1) ─── has many ──→ Articles (many)
articles.author_id is a FK to authors.id
```

**Many-to-Many**
```
Articles (many) ←──── has many ────→ Tags (many)
Requires a join table: article_tags (article_id, tag_id)
```

**Many-to-Many with extra fields** — when the relationship itself has data, make the join table a first-class model:
```
article_authors: article_id | author_id | role | display_order
```

**One-to-One** — use when extending a model you can't or shouldn't modify:
```
users:        id | email | username
user_profiles: id | user_id (unique FK) | bio | avatar_url
```

---

## Choosing the Right Data Type

| Data | Correct type | Common mistake |
|------|-------------|----------------|
| Money / price | DECIMAL(10,2) | FLOAT (precision errors) |
| Counts, IDs | INTEGER | VARCHAR |
| Boolean flags | BOOLEAN | CHAR(1) 'Y'/'N' |
| Timestamps | DATETIME with timezone | Naive DATETIME |
| Short text | VARCHAR(n) | TEXT (harder to index) |
| Arbitrary structured data | JSON | Multiple nullable columns |

**On JSON columns:** Useful for truly flexible, schema-less data. Trade-offs: can't index nested fields efficiently, no schema validation at the database level, harder to query complex structures. Use for supplementary metadata, not core queryable fields.

---

## Indexes

### When to add indexes

- Columns frequently used in WHERE clauses
- Columns used in ORDER BY
- Foreign key columns (most ORMs add these automatically — verify)
- Columns used in JOIN conditions
- Unique constraints (slug, email)

### When NOT to add indexes

- Small tables (< ~1,000 rows) — overhead not worth it
- Columns rarely queried
- Low-cardinality columns with skewed distribution (e.g., a status column where 95% of rows are "active")
- Very write-heavy tables — indexes slow down INSERT/UPDATE

### Composite indexes

Order matters: `(category, status)` helps queries filtering on `category` or `(category AND status)`, but NOT queries filtering only on `status`.

General rule: put the most selective column first, then columns used together in queries.

**Always verify with EXPLAIN:** Run `EXPLAIN ANALYZE` (PostgreSQL/MySQL) or `EXPLAIN QUERY PLAN` (SQLite) after adding an index to confirm it's being used.

---

## Constraints

Use the database to enforce data integrity — don't rely on application code alone.

**Unique constraints** — prevent duplicate values: `unique=True` on email, slug, etc.

**Foreign key constraints** — enforce referential integrity. Always define the cascade behavior explicitly:
- `CASCADE` — delete child records when parent is deleted
- `SET NULL` — null out the FK when parent is deleted (requires nullable column)
- `PROTECT / RESTRICT` — prevent parent deletion if children exist

**Check constraints** — enforce business rules at the DB level:
```sql
-- Price must be non-negative
CHECK (price >= 0)

-- Discount must be less than price
CHECK (discount_price IS NULL OR discount_price < price)
```

---

## Migration Strategy

### Backward-compatible migrations

Deploy migrations and code changes as separate steps so you can roll back without data loss.

**Pattern for adding a required field:**
```
Step 1: Add column as nullable — deploy this migration
Step 2: Deploy code that writes to the new column
Step 3: Backfill existing rows (data migration)
Step 4: Add NOT NULL constraint — deploy this migration
Step 5 (later): Remove the old column if replacing one
```

**Never:**
- Drop a column that existing code still reads
- Rename a column in a single deploy (two-step: add new, migrate data, remove old)
- Change a column type in a way that truncates or corrupts existing data

### Data migrations

When a migration must transform existing data, write it as a separate migration step with an explicit rollback path. Test on a copy of production data before running.

---

## Common Patterns

**Timestamps** — add `created_at` and `updated_at` to every table. Set `created_at` once on insert, update `updated_at` on every write. Use an abstract base model/mixin for this.

**Soft deletes** — instead of physically deleting rows, set a `deleted_at` timestamp. Lets you query deleted records and simplifies auditing. Trade-off: queries must filter out deleted rows everywhere. Use a custom manager/scope to enforce this automatically.

**Slugs** — human-readable URL identifiers. Generate from title on create if blank, make unique. Index for lookup performance.

**Audit fields** — `created_by`, `updated_by` FKs to the user who last modified the record. Useful for admin interfaces and audit trails.

---

## Checklist

### Before creating models
- [ ] Normalized to 3NF (unless denormalization is explicitly justified)
- [ ] Relationships defined correctly (FK, M2M, OneToOne)
- [ ] Appropriate data types chosen
- [ ] Indexes planned for expected query patterns
- [ ] Constraints defined (unique, check, FK cascade behavior)
- [ ] Migration strategy considered (especially for adding required fields)

### After creating models
- [ ] Migrations tested on staging before production
- [ ] Indexes verified with EXPLAIN
- [ ] Query performance measured on realistic data volume
- [ ] Backward compatibility confirmed for in-flight deploys

---

## Common Mistakes

**Using FLOAT for money** — floating point precision errors will cause rounding problems. Use DECIMAL.

**Storing arrays in columns** — `tags = "python,django,web"` violates 1NF and makes querying, filtering, and indexing impossible. Use a join table.

**No explicit cascade behavior** — leaving `on_delete` unspecified forces you to guess what happens when a parent record is deleted.

**No indexes on foreign keys** — most ORMs add these automatically, but verify. Unindexed FKs cause full table scans on JOIN queries.

**Missing NOT NULL constraints** — nullable columns that should never be null lead to defensive null checks everywhere in application code.

**Single-deploy column renames** — renaming a column in one deploy causes downtime. Always use the two-step add-migrate-remove pattern.

---

## Further Reading

- [Database Normalization](https://en.wikipedia.org/wiki/Database_normalization)
- [Use The Index, Luke](https://use-the-index-luke.com/) — definitive guide to database indexing
- [The Art of PostgreSQL](https://theartofpostgresql.com/)
