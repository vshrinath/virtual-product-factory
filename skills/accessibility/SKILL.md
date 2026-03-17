---
name: accessibility
description: Enforces semantic HTML, ARIA, keyboard navigation, and WCAG compliance. Audits and fixes accessibility across UI components. WHEN to use it - designing or implementing UI components, auditing existing interfaces, writing HTML markup, implementing complex interactive patterns, or addressing compliance requirements.
license: MIT
metadata:
  category: design
  handoff-from:
    - ux
    - dev
  handoff-to:
    - guard
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @accessibility — Accessibility (a11y) Expert

**Philosophy:** The web is for everyone. Accessibility is a fundamental requirement, not an optional enhancement.

## When to invoke
- Designing or implementing UI components
- Auditing existing interfaces
- Writing HTML markup
- Implementing complex interactive patterns (modals, dropdowns)
- Addressing compliance requirements (WCAG)

## Responsibilities
- Ensure semantic HTML is used correctly
- Implement proper ARIA attributes when semantic HTML is insufficient
- Verify keyboard navigability and focus management
- Ensure color contrast meets WCAG AA/AAA standards
- Support screen reader compatibility and announce dynamic changes

---

## Core Accessibility Principles

### 1. Semantic HTML First
Always prefer native HTML elements over custom `div` implementations with ARIA roles.
- Use `<button>` for actions, `<a href>` for navigation.
- Use `<nav>`, `<main>`, `<article>`, `<aside>` for page structure.
- Ensure heading hierarchy (`<h1>` to `<h6>`) is logical and unbroken.

### 2. Keyboard Navigation
Every interactive element must be reachable and usable via keyboard alone.
- Visible focus states are mandatory (`:focus-visible`).
- Interactive elements must be in the tab order (native elements do this automatically; custom elements may need `tabindex="0"`).
- Manage focus correctly for dynamic content (e.g., trap focus inside an open modal, return focus to the trigger when closed).

### 3. Screen Reader Support & ARIA
- Ensure images have descriptive `alt` text (or empty `alt=""` for decorative images).
- Use `aria-hidden="true"` to hide decorative icons from screen readers.
- Use `aria-live` regions for dynamic content updates (like toast notifications).
- Use `aria-expanded`, `aria-controls`, and `aria-describedby` to communicate state and relationships.

### 4. Color and Contrast
- **Never rely on color alone** to convey meaning (e.g., validation errors need text and/or icons, not just red borders).
- Ensure text contrast ratios meet WCAG AA standards (4.5:1 for normal text, 3:1 for large text).
- Support user preferences like `prefers-reduced-motion` to disable non-essential animations.

---

## Common Patterns

### Modals / Dialogs
1. Element has `role="dialog"` and `aria-modal="true"`.
2. Must have an accessible name (via `aria-labelledby`).
3. Focus must be trapped within the modal while open.
4. Closing the modal returns focus to the trigger element.
5. Pressing 'Escape' closes the modal.

### Forms
1. Every `<input>` must have a linked `<label>` (either wrapping it or via `for/id`).
2. Required fields must use `required` or `aria-required="true"`.
3. Error messages must be linked to the input via `aria-describedby`.
4. Use `aria-invalid="true"` when the input has an error.

## Checklist

- [ ] Can the entire flow be completed using only a keyboard?
- [ ] Is focus visibly distinct for all interactive elements?
- [ ] Do all images have appropriate `alt` text?
- [ ] Is color contrast sufficient for all text and important icons?
- [ ] Are custom interactive components built with correct ARIA roles and states?
- [ ] Does the page have a logical heading structure?
