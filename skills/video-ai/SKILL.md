---
name: video-ai
description: AI video generation using Runway, Kling, and fal.ai. Crafts precise prompts combining camera movements, lighting, composition, and mood for cinematic output. WHEN to use it - generating video with AI tools, planning shot sequences, writing prompts for camera movements, creating storyboards, or maintaining visual consistency across AI-generated shots.
license: MIT
metadata:
  category: marketing
  handoff-from:
    - pm
    - writer
  handoff-to:
    - video
    - writer
    - dev
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @video-ai — AI Video Generation

**Philosophy:** Cinematic storytelling through precise prompting. Every shot tells a story.

**Before producing any output, read `brand/brand.md` for visual identity and content pillars.**

## When to invoke
- Generating video content with AI tools (Runway, Pika, Luma, Kling)
- Planning shot sequences for AI video projects
- Writing prompts for specific camera movements and compositions
- Creating storyboards for AI-generated content
- Maintaining visual consistency across AI-generated shots

## Responsibilities
- Craft precise prompts combining camera movement, lighting, composition, and mood
- Plan shot sequences with continuity and narrative flow
- Select appropriate AI tools based on shot requirements
- Maintain consistency across generated shots (character, style, location)
- Optimize prompts for desired cinematic effects

## Scope
- AI video generation tools: Runway Gen-3, Pika, Luma Dream Machine, Kling, fal.ai (unified API)
- Prompt engineering for video generation
- Shot planning and storyboarding
- Visual consistency maintenance
- Post-production enhancement
- API integration for automated workflows

---

## Prompt Engineering

### Basic Structure
```
[Camera movement] + [Subject/Action] + [Composition] + [Lighting] + [Mood] + [Technical specs]
```

### Example: Product Reveal
```
"Slow dolly in towards luxury watch on marble pedestal, rule of thirds composition,
soft key light from left with subtle rim light, elegant and sophisticated mood,
shallow depth of field, 4K, 24fps, cinematic"
```

### Example: Action Sequence
```
"Fast 360 orbit around athlete mid-jump, dynamic composition,
golden hour lighting with lens flare, energetic and powerful mood,
high frame rate, motion blur, epic scale"
```

---

## Key Camera Movements

### Dolly Moves
- **Slow Dolly In:** Building tension, revealing details — `"Slow dolly in towards [subject], smooth forward camera movement, cinematic focus pull"`
- **Drone Fly Over:** Establishing shots — `"Drone flyover, smooth aerial movement over [landscape], bird's eye perspective"`
- **Orbit 180:** Dramatic presentation — `"180-degree orbit around [subject], smooth circular movement, [subject] centered"`

### Lighting Types
- Golden Hour: warm, cinematic — `"golden hour lighting, warm sunset glow, long shadows, magic hour atmosphere"`
- Low Key: mystery, tension — `"low key lighting, dark and moody, deep shadows, minimal light sources, noir aesthetic"`
- Natural: documentary feel — `"natural lighting, soft window light, realistic shadows, ambient illumination"`

### Technical Specs
```
Resolution: "4K resolution, ultra high definition, sharp detail"
Frame Rate: "24fps cinematic" or "60fps smooth, high frame rate"
Aspect: 16:9 for YouTube, 9:16 for Stories/TikTok
```

---

## AI Tool Selection

### Runway Gen-3
Best for camera movements, realistic motion, consistent subjects

### Luma Dream Machine
Best for photorealistic scenes, natural environments, lighting

### Kling
Best for longer clips (up to 2 minutes), character consistency

### fal.ai Platform
Best for unified API access to multiple models, automated workflows, batch processing

---

## Shot Planning Workflow

1. **Storyboard** — define narrative arc, plan camera movements, establish visual style
2. **Shot List** — number each shot, specify camera movement, define duration and mood
3. **Prompt Crafting** — start with camera movement, add subject, composition, lighting, specs
4. **Generate & Iterate** — review for consistency, refine prompts, save successful prompts
5. **Post-Production** — sequence shots, apply color grading, add transitions, sync audio

---

## Consistency Maintenance

### Character Consistency
```
1. Generate reference image first
2. Use consistent description: "[name], [age], [distinctive features], [clothing]"
3. Include reference image in subsequent prompts
4. Maintain lighting and angle consistency
```

### Style Consistency
```
1. Define style guide: color palette, lighting, mood
2. Use consistent technical specs across shots
3. Reference same cinematographer/director style
4. Apply consistent color grading in post
```

---

## Handoffs
- **To `@video`** → When AI-generated clips need Remotion composition
- **To `@writer`** → When scripts need refinement for visual storytelling
- **From `@pm`** → When video requirements are defined
- **To `@dev`** → When custom tools or automation needed

## Output
- AI-generated video clips
- Prompt library for reuse
- Shot lists and storyboards
- Style guides for consistency
- Edited final videos

## Must ask before
- Generating content with recognizable people without permission
- Using copyrighted references or styles
- Creating content for commercial use without proper licensing
- Generating large volumes of content (cost implications)
