---
title: "Synchronizing Copilot Setup Across Repositories and Devices"
date: 2026-04-12
categories: [GitHub, DevOps, Copilot, Automation]
tags: [github-actions, workflow-synchronization, ai-setup, multi-device-development]
---

When we're working with [Cratis](https://cratis.io), we work across lots of different devices — phones, iPads, Macs, random browsers, whatever's nearby. We use GitHub issues heavily because people register via issues and we want to assign them. That shapes how we optimize everything.

One thing we've done is synchronize all our Copilot setup across repositories and devices. We structured it so you can edit the configuration in any repository and it automatically synchronizes everywhere. We often find small things that need fixing while we're working on something specific, so we just tell the model to fix the instructions, skills, or prompts — whatever needs it. When those changes merge to main, they automatically sync to all other repositories in the organization.

## Why This Matters: The Perfect Storm of Inconsistency

Here's the problem we were facing: our team works across multiple repositories, and we're literally always switching contexts. One minute I'm working on one project from my Mac, the next I'm on my iPad looking at something else entirely. Copilot setup files (instructions, skills, prompts) traditionally live in individual repositories. When you discover a bug or improvement while working on a specific project, you need to update it everywhere.

Without automation, these changes diverge immediately. Repository A gets an improvement, but Repository B doesn't. A new team member clones Repository C and gets an outdated setup. The inconsistency compounds over time, and suddenly your AI tooling experience is totally different depending on where you're working. That's friction we didn't want.

## How We Fixed It: GitHub Workflows to the Rescue

So what we've done is basically build a system where all the Copilot configuration stays synchronized automatically. Here's how it works:

**1. Edit Anywhere, Sync Everywhere**

We've structured our setup to allow edits in any repository. While working on Chronicle, or any other project, if I find something that needs fixing in the Copilot instructions or a skill, I just edit it. No special process, no "which repo is the source of truth?" — I just commit and push.

**2. Automatic Synchronization on Merge**

When changes merge to `main` in any repository, a GitHub Actions workflow kicks in and automatically synchronizes those changes to all other repositories in the organization.

All our common workflows live in the [Cratis/Workflows](https://github.com/Cratis/Workflows) repository. This is where we keep the reusable workflow logic that ensures consistency across the organization.

A specific instance of this in action is in [Chronicle's propagate-copilot-instructions workflow](https://github.com/Cratis/Chronicle/blob/main/.github/workflows/propagate-copilot-instructions.yml). This workflow runs on merge to `main` and synchronizes all the `.instructions.md`, `.prompt.md`, and other AI-related configuration files to every other repository in our organization. The workflow creates pull requests automatically, so the sync is visible and auditable — you can see exactly what changed and approve it if needed.

**3. Dedicated AI Configuration Repository**

We've also made our own AI repo that we point others to for getting the setup. The reasoning is simple: this repo contains not just our Copilot configuration, but also documentation on how to use our stuff effectively. It's basically a reference hub.

Check out [cratis/ai](https://github.com/cratis/ai) — this is where we keep the best practices, setup guides, and examples. This repo is also part of the sync cycle, so improvements made here propagate everywhere across the organization.

## The Real Benefits

**Device and Environment Agnostic**: I can work from my Mac, check something on my iPad, look at an issue on my phone, and in every single place, my Copilot setup is exactly the same. No more "my setup doesn't match yours" problems. No more manual sync headaches. Whatever device I grab, I'm productive immediately.

**Improvements Happen Naturally**: Here's what actually happens in practice — someone's working, finds something that could be better, fixes it in the Copilot config, and it just rolls out to everyone. No coordination meetings, no "I'll file a ticket to update the central config," nothing like that. If you find a problem while solving something, you fix it right there and then. Everyone benefits.

**You Can Edit Anywhere**: This is the key thing — you're not fighting the system to figure out where the "real" config lives. You just edit it wherever you're working. Is the problem in Chronicle? Edit there. Is it in another repo? Edit there. The system handles keeping everything in sync.

**No Toil, No Friction**: No manual processes, no forgotten updates, no config drift. The device and environment agnostic bit means we're not adding complexity — we're removing it. The system gets out of the way and lets us focus on actual work instead of configuration management theater.

## How It Actually Works

The technical piece is pretty straightforward. Each repository contains its Copilot configuration files — `.instructions.md`, `.prompt.md`, skills, and whatever else we need. When you merge changes to `main`, a GitHub Actions workflow runs automatically.

The workflow does a few things:

1. **Detects what changed** in the AI configuration files
2. **Clones or updates all other repositories** in the organization
3. **Copies the configuration files** to match the source repository
4. **Creates pull requests** in each target repository with the changes

Because we create pull requests instead of force-pushing, everything is auditable and reviewable. You can see exactly what changed. The PRs get auto-merged if there are no conflicts, so the system moves fast but stays transparent.

The magic is in having a shared workflow repository. Check out [Cratis/Workflows](https://github.com/Cratis/Workflows) — this centralizes the workflow logic so we don't have to maintain the sync logic in fifty different places. Individual repositories just call this common workflow when they merge to `main`.

It's not complicated — it's just GitHub Actions doing what it's designed to do. The benefit is huge though: zero manual work, perfect sync, and the ability to edit config from anywhere.

## Why This Matters

The benefit is basically this: we're device and environment agnostic. I can do this from anywhere. I can work on my Mac, grab my iPad, switch back to my phone, and everywhere I go, the Copilot setup is exactly the same. That's the whole point.

Most teams treat Copilot configuration like baggage — something that lives in a specific repo and gets forgotten. We treat it like a product that we're continuously improving. When someone finds a bug or discovers a better way to write a prompt while working on something specific, they just fix it and move on. The system makes sure everyone benefits immediately.

The key insight is this: **Your setup should work for you, not against you.** If you have to think about keeping things in sync, you've already lost. Automation should eliminate that toil. By synchronizing Copilot configuration across all our repositories, we've removed friction from the equation. We can be productive from any device, in any repository, and never worry about whether our setup is current.

That's the goal. That's what we built. And honestly, it works.

If this sounds interesting for your team, check out our repositories: the [common workflows](https://github.com/Cratis/Workflows) where we share the sync logic, the [example implementation](https://github.com/Cratis/Chronicle/blob/main/.github/workflows/propagate-copilot-instructions.yml) in Chronicle, and the [AI reference repository](https://github.com/cratis/ai) where we document how to use this effectively.
