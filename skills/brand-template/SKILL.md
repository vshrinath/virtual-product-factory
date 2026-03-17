---
name: brand-template
description: Brand guide template defining voice, audience, visual identity, and content pillars. All marketing personas read this before producing output. WHEN to use it - when filling out brand identity for a new project, when marketing skills need brand guidance, or when reviewing brand consistency across output.
license: MIT
metadata:
  category: brand
  handoff-from:
    - user-input
  handoff-to:
    - writer
    - seo
    - perf
    - video
    - video-ai
    - ux
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# Brand Guide — [Your Brand Name]

All marketing personas must read this file before producing any output.

---

## Identity

- **Name:** [Your Brand Name]
- **Tagline:** [Your tagline]
- **Mission:** [Your mission statement]
- **Founded:** [Year]
- **URL:** [yourdomain.com]

---

## Voice

### Attributes
[List 4-6 voice attributes with contrasts]
- [Attribute], not [opposite]
- [Attribute], not [opposite]
- [Attribute], not [opposite]

### Tone do's
- [Guideline 1]
- [Guideline 2]
- [Guideline 3]
- [Guideline 4]

### Tone don'ts
- [What to avoid 1]
- [What to avoid 2]
- [What to avoid 3]
- [What to avoid 4]

---

## Audience

### Primary
- [Demographic description]
- [Age range]
- [Behavioral characteristics]
- [What they care about]

### What they value
- [Value 1]
- [Value 2]
- [Value 3]
- [Value 4]

### What they ignore
- [What doesn't resonate 1]
- [What doesn't resonate 2]
- [What doesn't resonate 3]

---

## Content Pillars

1. **[Pillar 1]** — [Description]
2. **[Pillar 2]** — [Description]
3. **[Pillar 3]** — [Description]
4. **[Pillar 4]** — [Description]
5. **[Pillar 5]** — [Description]

---

## Visual Identity

### Colors
| Name | Hex | Usage |
|------|-----|-------|
| Primary | `#000000` | [Usage description] |
| Primary Dark | `#000000` | [Usage description] |
| Primary Light | `#000000` | [Usage description] |
| Text Primary | `#000000` | Body text, headings |
| Text Secondary | `#000000` | Captions, metadata |
| Background | `#FFFFFF` | Default background |
| Background Alt | `#F3F3F3` | Secondary backgrounds |

### Typography
- **Primary font:** [Font name]
- **Headings:** Weight [weight]
- **Body:** Weight [weight]
- **Letter spacing:** [spacing] for headings

### Logo
- **Primary:** `brand/assets/logo.svg`
- **Dark background variant:** `brand/assets/logo-dark.svg` (if available)
- **Minimum clear space:** [Clear space rule]
- **Never:** Stretch, recolor, or add effects to the logo

### Favicon
- `brand/assets/favicon.ico` — Standard favicon
- `brand/assets/favicon.svg` — Modern browsers

### Default OG Image
- `brand/assets/og-default.png` — Used when no article-specific OG image exists
- Dimensions: 1200×630px

---

## Content Formats

| Format | Description | Typical length |
|--------|-------------|---------------|
| [Format 1] | [Description] | [Length] |
| [Format 2] | [Description] | [Length] |
| [Format 3] | [Description] | [Length] |

---

## Platform Presence

| Platform | Handle | Content type | Cadence |
|----------|--------|-------------|---------|
| Website | [domain] | All formats | [Frequency] |
| Newsletter | [Platform] | [Type] | [Frequency] |
| LinkedIn | [Handle] | [Type] | [Frequency] |
| Twitter/X | [Handle] | [Type] | [Frequency] |
| Instagram | [Handle] | [Type] | [Frequency] |
| YouTube | [Handle] | [Type] | [Frequency] |

---

## Competitor Positioning

**We are not:**
- [What you're not 1]
- [What you're not 2]
- [What you're not 3]

**We are:**
- [What you are 1]
- [What you are 2]
- [What you are 3]

---

## Using This File

This file is loaded by all marketing personas (`@video`, `@video-ai`, `@writer`, `@seo`, `@perf`).

**To customize for your project:** Replace the bracketed placeholders with your brand's identity, voice, audience, colors, and positioning. The persona files remain unchanged — they reference `brand/brand-template.md` generically.
