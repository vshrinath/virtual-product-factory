---
name: refactoring
description: Safe structural cleanup without behavior change. Identifies code smells, removes duplication, and improves clarity. WHEN to use it - when code smells are detected, before adding features to messy code, after feature work to clean up, during code review when patterns emerge, or quarterly for code health audits.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
    - guard
  handoff-to:
    - testing
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @refactoring — Safe Code Refactoring

**Philosophy:** Make the change easy, then make the easy change. Refactoring is not rewriting.

## When to invoke
- Code smells detected (duplication, complexity, unclear naming)
- Before adding new features to messy code
- After feature is working (clean up implementation)
- During code review when patterns emerge
- Quarterly code health audits

## Responsibilities
- Identify code smells and technical debt
- Refactor safely with tests as safety net
- Improve code clarity without changing behavior
- Know when to refactor vs rewrite
- Document refactoring decisions

---

## Core Principles

### 1. Tests First

**Never refactor without tests.**

```python
# Workflow:
# 1. Write tests for current behavior (if missing)
# 2. Verify tests pass
# 3. Refactor code
# 4. Verify tests still pass
# 5. Commit

# ❌ Refactor without tests
def calculate_total(items):
    # Refactor this complex function
    # Hope it still works!

# ✅ Add tests first
def test_calculate_total():
    items = [{'price': 10}, {'price': 20}]
    assert calculate_total(items) == 30

# Now refactor safely
```

### 2. Small Steps

**Refactor in tiny, verifiable increments.**

```python
# ❌ Big bang refactor (risky)
# Rewrite entire module in one go
# 500 lines changed, tests might pass by accident

# ❌ Full file rewrite (introduces regressions)
# Output the entire file with changes mixed in
# Untouched functions subtly altered by accident

# ✅ Incremental refactor (safe)
# Step 1: Extract one function, test
# Step 2: Rename variables, test
# Step 3: Simplify logic, test
# Each step is independently verifiable
# Each step touches only the code being changed
```

### 3. Behavior Preservation

**Refactoring changes structure, not behavior.**

```python
# ❌ Refactoring + feature addition (mixed)
def process_order(order):
    # Refactored structure
    # + Added discount logic
    # + Fixed bug
    # Which change broke tests?

# ✅ Separate refactoring from features
# Commit 1: Refactor (tests pass, behavior unchanged)
# Commit 2: Add discount feature (new tests)
# Commit 3: Fix bug (regression test)
```

---

## Code Smells

### Duplicated Code

**Same code appears in multiple places.**

```python
# ❌ Duplication
def create_user(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.save()
    send_welcome_email(user)
    return user

def create_admin(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.is_admin = True
    user.save()
    send_welcome_email(user)
    return user

# ✅ Extract common logic
def create_user(name, email, is_admin=False):
    user = User(
        name=name,
        email=email,
        created_at=timezone.now(),
        is_admin=is_admin
    )
    user.save()
    send_welcome_email(user)
    return user
```

### Long Function

**Function does too many things.**

```python
# ❌ Long function (50+ lines)
def process_order(order_data):
    # Validate data (10 lines)
    # Calculate totals (15 lines)
    # Apply discounts (10 lines)
    # Create order (5 lines)
    # Send notifications (10 lines)
    # Update inventory (10 lines)

# ✅ Extract smaller functions
def process_order(order_data):
    validate_order_data(order_data)
    total = calculate_order_total(order_data)
    total = apply_discounts(total, order_data)
    order = create_order(order_data, total)
    send_order_notifications(order)
    update_inventory(order)
    return order
```

### Large Class

**Class has too many responsibilities.**

```python
# ❌ God class (does everything)
class Article:
    def save(self):
        # Save to database

    def send_email_notification(self):
        # Send email

    def index_in_search(self):
        # Update search index

    def generate_pdf(self):
        # Create PDF

    def post_to_social_media(self):
        # Post to Twitter/Facebook

# ✅ Single Responsibility Principle
class Article:
    def save(self):
        # Save to database

class ArticleNotifier:
    def send_email(self, article):
        # Send email

class ArticleSearchIndexer:
    def index(self, article):
        # Update search index

class ArticlePDFGenerator:
    def generate(self, article):
        # Create PDF

class ArticleSocialPoster:
    def post(self, article):
        # Post to social media
```

### Long Parameter List

**Function takes too many parameters.**

```python
# ❌ Too many parameters
def create_article(title, content, author, category, tags,
                   published_date, featured, allow_comments,
                   seo_title, seo_description, og_image):
    pass

# ✅ Use object/dict
def create_article(article_data):
    # article_data contains all fields
    pass

# ✅ Or use builder pattern
article = (ArticleBuilder()
    .with_title("My Article")
    .with_content("Content here")
    .with_author(author)
    .build())
```

### Magic Numbers

**Unexplained constants in code.**

```python
# ❌ Magic numbers
if user.age < 18:
    return "Too young"

if order.total > 1000:
    apply_discount(order, 0.1)

# ✅ Named constants
MINIMUM_AGE = 18
BULK_ORDER_THRESHOLD = 1000
BULK_ORDER_DISCOUNT = 0.1

if user.age < MINIMUM_AGE:
    return "Too young"

if order.total > BULK_ORDER_THRESHOLD:
    apply_discount(order, BULK_ORDER_DISCOUNT)
```

### Nested Conditionals

**Deep nesting makes code hard to follow.**

```python
# ❌ Nested conditionals
def process_payment(user, amount):
    if user:
        if user.is_active:
            if user.has_payment_method:
                if amount > 0:
                    if amount <= user.balance:
                        # Process payment
                        return True

# ✅ Guard clauses (early return)
def process_payment(user, amount):
    if not user:
        return False
    if not user.is_active:
        return False
    if not user.has_payment_method:
        return False
    if amount <= 0:
        return False
    if amount > user.balance:
        return False

    # Process payment
    return True
```

---

## Refactoring Techniques

### Extract Function

**Pull code into a separate function.**

```python
# Before
def generate_report(data):
    # Calculate totals
    total = 0
    for item in data:
        total += item['price'] * item['quantity']

    # Format output
    output = f"Total: ${total:.2f}\n"
    output += f"Items: {len(data)}\n"

    return output

# After
def generate_report(data):
    total = calculate_total(data)
    return format_report_output(total, len(data))

def calculate_total(data):
    return sum(item['price'] * item['quantity'] for item in data)

def format_report_output(total, item_count):
    return f"Total: ${total:.2f}\nItems: {item_count}\n"
```

### Rename Variable/Function

**Make names more descriptive.**

```python
# Before
def calc(x, y):
    z = x * y * 0.1
    return z

# After
def calculate_discount(price, quantity):
    discount_rate = 0.1
    discount_amount = price * quantity * discount_rate
    return discount_amount
```

### Extract Variable

**Name intermediate results.**

```python
# Before
if (user.age >= 18 and user.country == 'US' and
    user.has_verified_email and not user.is_banned):
    allow_access()

# After
is_adult = user.age >= 18
is_us_user = user.country == 'US'
is_verified = user.has_verified_email
is_allowed = not user.is_banned

if is_adult and is_us_user and is_verified and is_allowed:
    allow_access()
```

---

## When to Refactor vs Rewrite

### Refactor When:
- Code works but is messy
- Tests exist (or can be added)
- Changes are incremental
- Team understands the code
- Business logic is sound

### Rewrite When:
- Technology is obsolete
- No tests and code is incomprehensible
- Architecture is fundamentally broken
- Cost of refactoring > cost of rewriting
- Business requirements changed drastically

---

## Refactoring Workflow

### Step-by-Step Process

```
1. Identify code smell
   ↓
2. Write tests (if missing)
   ↓
3. Verify tests pass
   ↓
4. Make one small refactoring
   ↓
5. Run tests
   ↓
6. Commit
   ↓
7. Repeat from step 4
```

---

## Refactoring Checklist

### Before Refactoring
- [ ] Tests exist and pass
- [ ] You understand what the code does
- [ ] You have a clear goal (what smell are you fixing?)
- [ ] You have time to do it properly
- [ ] Code is in version control

### During Refactoring
- [ ] Making small, incremental changes
- [ ] Running tests after each change
- [ ] Committing after each successful change
- [ ] Not adding features or fixing bugs
- [ ] Keeping behavior unchanged

### After Refactoring
- [ ] All tests still pass
- [ ] Code is more readable
- [ ] Code is easier to modify
- [ ] No new bugs introduced
- [ ] Documented any non-obvious decisions

---

## Common Mistakes

### ❌ Refactoring Without Tests
```python
# "I'll just clean this up real quick"
# [Breaks production]
```

### ✅ Write Tests First
```python
# Write tests for current behavior
# Then refactor safely
```

---

### ❌ Big Bang Refactoring
```python
# Rewrite entire module in one commit
# 1000 lines changed
# Tests pass but behavior changed subtly
```

### ✅ Incremental Refactoring
```python
# Commit 1: Extract function A
# Commit 2: Rename variables
# Commit 3: Simplify logic
# Each commit is independently verifiable
```

---

### ❌ Mixing Refactoring with Features
```python
# Commit: "Refactor user service and add password reset"
# Which change broke tests?
```

### ✅ Separate Commits
```python
# Commit 1: "refactor: extract user validation logic"
# Commit 2: "feat: add password reset feature"
```

---

## Further Reading

- [Refactoring: Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html) — Martin Fowler
- [Working Effectively with Legacy Code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/) — Michael Feathers
- [Code Smells Catalog](https://refactoring.guru/refactoring/smells)
- [Refactoring Patterns](https://refactoring.guru/refactoring/techniques)
