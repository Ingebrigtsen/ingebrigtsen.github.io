---
applyTo: "LinkedIn/**"
---
# LinkedIn Writing Guide - Einar's Style

Use this when writing or editing LinkedIn posts. LinkedIn is a different medium than the blog — shorter, punchier, and built for scrolling. But it should still unmistakably sound like Einar.

---

## Core Principles

1. **The hook is everything** — The first line is what people see before clicking "See more". Make it count. Bold claim, provocative question, or a surprising statement.
2. **Short paragraphs** — One to three sentences max. White space is your friend on mobile.
3. **Personal and opinionated** — Share a real perspective. LinkedIn rewards authenticity and strong (but fair) takes.
4. **Concrete over abstract** — Always back up claims with specific examples, numbers, or real situations.
5. **No corporate speak** — No "synergies", no "leverage", no "ecosystem". Write like a human.

---

## Structure

### The Hook (Line 1–2)
What gets people to click "See more". Options:
- A bold/provocative statement: *"Most companies don't own their cloud infrastructure. They rent opinions."*
- A question: *"When did 'just use a managed service' become the answer to every architecture decision?"*
- A surprising observation: *"I just deployed 56 Kubernetes resources on a cloud provider most people have never heard of. It went fine."*

### The Setup (2–4 short paragraphs)
Brief context. What's the situation, what's the tension, what's the experience you're drawing from?

### The Point (2–4 short paragraphs)
The actual opinion or insight. Be direct. Use "I would argue...", "The way I see it...", "Here's the thing:".

### The Concrete Stuff (optional but valuable)
Examples, numbers, a short list. Make it real.

### The Close
Wrap up with a reflection, a call to action, or a question to the reader. Invite engagement without begging for it.

### Hashtags
4–6 relevant hashtags at the end, separated by spaces. No hashtag stuffing.

---

## Voice Checklist

- [ ] First line is a strong hook
- [ ] Paragraphs are short (1–3 sentences)
- [ ] First-person perspective ("I", "my", "we")
- [ ] Opinionated but fair — uses "I would argue", "IMO", "the way I see it"
- [ ] At least one concrete example, number, or real-world reference
- [ ] No passive voice where active is clearer
- [ ] Ends with something — a question, a reflection, or a CTA
- [ ] 4–6 relevant hashtags

---

## Length

Aim for **150–300 words** for the visible body. LinkedIn truncates at roughly 200 characters on the first "read", so the hook must work standalone. Posts over 500 words rarely outperform shorter ones unless they're genuinely exceptional.

---

## What to Avoid

- Listicle baiting ("10 things you must know about...") — Einar's voice is essay-style, not clickbait
- Humblebragging wrapped in advice
- Ending with "What do you think? Drop a comment below 👇" — it's fine to invite discussion naturally but not mechanically
- Excessive emoji — use sparingly, max 1–2 if at all
- Generic takes that anyone could write — if it sounds like a press release or a LinkedIn influencer template, rewrite it

---

## File Naming

Files live in `LinkedIn/YYYY/MM/` and use a short kebab-case slug describing the topic:

```
LinkedIn/2026/03/cloud-infrastructure-sovereignty.md
LinkedIn/2026/04/event-sourcing-misconceptions.md
```

---

## Frontmatter

Each post file starts with YAML frontmatter:

```yaml
---
date: "YYYY-MM-DD"
title: "Short descriptive title (internal reference, not the LinkedIn headline)"
tags:
  - cloud
  - architecture
published: false   # set to true once posted
---
```
