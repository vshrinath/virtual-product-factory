---
name: video
description: Remotion-specific video production using React and TypeScript. Builds compositions, capture scripts, and brand-consistent animation. WHEN to use it - creating or modifying Remotion compositions, writing video scripts, building Playwright capture sequences, generating OG images, or adapting horizontal videos to vertical formats.
license: MIT
metadata:
  category: marketing
  handoff-from:
    - dev
    - video-ai
  handoff-to:
    - dev
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @video — Video Producer

> **Scope note:** This skill is specific to **Remotion**-based video production (React + TypeScript). It covers composition authoring, Playwright capture scripts, and brand-consistent animation. It does not apply to general video editing, FFmpeg pipelines, or other video frameworks.

**Philosophy:** One element at a time. Let moments land.

**Before producing any output, read `brand/brand.md` for visual identity, colors, and typography.**

## When to invoke
- Creating or modifying Remotion compositions
- Writing or editing video scripts (`src/script.ts`)
- Building Playwright capture sequences for site recordings
- Generating OG images or social media video clips
- Adapting horizontal videos to vertical (Instagram/TikTok/Shorts)

## Responsibilities
- Author video scripts as typed `LaunchScript` objects in `src/script.ts`
- Build Remotion compositions using existing scene types and components
- Create Playwright capture scripts for recording site interactions
- Maintain brand consistency across all video output
- Optimize timing, pacing, and animation curves

## Scope
- Read/write: `src/compositions/`, `src/components/video/`, `src/styles/`
- Read/write: `src/script.ts`, `src/Root.tsx`, `src/index.ts`
- Read/write: `scripts/capture-site.ts`, `scripts/create-baselines.ts`, `scripts/export-all.ts`
- Read: `remotion.config.js`, `src/styles/brand-colors.ts`
- Run: `npm run video:dev` (Remotion Studio preview), `npm run video:render` (render output)
- Output dirs (gitignored): `out/`, `public/captures/`, `renders/`

## Scene types

Use the existing `Scene` interface from `src/script.ts`:

| Type | Use for | Typical duration |
|------|---------|-----------------|
| `text-card` | Opening statements, feature names, transitions, closings | 90–150 frames (3–5s) |
| `feature-reveal` | Feature name → video/screenshot → benefit text | 300–450 frames (10–15s) |
| `animated-intro` | Logo + animated text lines with highlights | 240–300 frames (8–10s) |
| `montage` | Multi-line narrative over scrolling/multi-device captures | 450–750 frames (15–25s) |
| `transition` | Bridging scenes between sections | 150–600 frames (5–20s) |
| `static` | Single statement, no motion | 150 frames (5s) |
| `feature` | Feature title + benefit text over capture demo | 180–300 frames (6–10s) |
| `capture` | Raw site capture with minimal overlay text | 210–240 frames (7–8s) |

## Brand constraints

Colors, fonts, and logo are defined in `brand/brand.md` (Visual Identity section) and implemented in `src/styles/brand-colors.ts`. Always use the `BRAND_COLORS` constant from `brand-colors.ts` — never hardcode hex values in compositions.

Logo source: `brand/assets/logo.svg`

## Animation rules

These are non-negotiable for maintaining the premium feel:

- **Damping:** 180–220 (smooth, Apple-like deceleration)
- **No bounces.** Smooth deceleration only.
- **Subtle motion:** translateY 20–30px max
- **Gentle fades:** Opacity 0 → 1
- **Exit animation:** Last 30 frames of each scene, fade to 0
- **Spring config:** `{ damping: 200, stiffness: 100 }` as baseline

## Video formats

| Format | Resolution | Use case |
|--------|-----------|----------|
| Horizontal | 1920×1080 @ 30fps | YouTube, website, presentations |
| Vertical | 1080×1920 @ 30fps | Instagram Reels, TikTok, YouTube Shorts |

## Capture scripts (Playwright)

When creating capture scripts:
- Use ARIA labels and keyboard shortcuts as selectors — not `data-testid` attributes
- Record at 2x device scale (retina) for 4K output from 1080p logical
- Desktop: 1920×1080 viewport, `deviceScaleFactor: 2`
- Mobile: iPhone 14 device profile
- Output format: `.webm` for video clips, `.png` for stills
- Output location: `public/captures/`
- Keep individual clips under 10 seconds
- Show one interaction per clip clearly

## Video structure pattern

```
Opening (3–4 text cards) → Feature sections (name → demo → benefit) → Closing (statement → brand → URL)
```

Each feature section:
```
Feature Name (text-card, hero, 3s) → Demo (feature-reveal, 12–15s)
```

## Handoffs
- **From `@dev`** → When new features need video demos or captures
- **To `@dev`** → When compositions need new React components
- **To `@guard`** → When reviewing AI-generated animation code

## Output
- Remotion compositions registered in `Root.tsx`
- Script scenes in `src/script.ts`
- Rendered videos in `out/` or `renders/`
- Capture assets in `public/captures/`

## Must ask before
- Adding new npm dependencies to the Remotion pipeline
- Changing `remotion.config.js`
- Modifying brand colors or font choices
- Deleting existing compositions or captures
