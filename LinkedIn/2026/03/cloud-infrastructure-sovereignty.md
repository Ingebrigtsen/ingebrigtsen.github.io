---
date: "2026-03-19"
title: "Cloud infrastructure sovereignty — the lock-in you don't see coming"
tags:
  - cloud
  - architecture
  - infrastructure
  - sovereignty
published: false
---

You don't lose control of your cloud infrastructure all at once. You lose it one managed service at a time.

Every time you wire up an Azure Function, drop an SQS queue into a workflow, or let a Lambda handle your background jobs, you're making a trade. Convenience now for optionality later. That trade isn't always wrong — but most teams make it without realising they're making it at all.

We talk a lot about data sovereignty. Where does the data physically live? Whose laws govern it? The CLOUD Act and GDPR have made this conversation unavoidable, especially for European companies. But I'd argue there's a second, underappreciated concern: **infrastructure sovereignty**. Who controls the shape of your system? How hard would it be to move?

Here's the thing — a lot of the services that paint you into a corner are solving problems you might not even have. Azure Functions and AWS Lambdas are excellent when you genuinely need to absorb massive, unpredictable burst traffic. But most line-of-business applications don't burst. They hum. A simple container running a background worker handles the same job, runs anywhere, and costs you nothing extra to migrate.

The same logic applies to proprietary queues (SQS, Service Bus), managed auth (Cognito, Azure AD B2C), and platform-native AI pipelines. Each one is genuinely useful in context. Each one also means that "just moving to another provider" is no longer an afternoon's work.

So what's the alternative? Start by asking the question before you reach for the managed service: do I actually need this, or is it just the path of least resistance? Use open standards and portable primitives where you can — containers, Kubernetes, open-source databases. Keep provider-specific glue at the edges, not in the core.

For European companies, there are now real alternatives. [UpCloud](https://upcloud.com) is one I've been working with directly — a European-owned provider with a solid managed Kubernetes offering, object storage, and proper GDPR footing. It's not about rejecting AWS or Azure wholesale. It's about not defaulting to them for everything without thinking.

Infrastructure sovereignty isn't about purity. It's about knowing what you're trading and making that call consciously.

#CloudArchitecture #Infrastructure #CloudStrategy #DataSovereignty #UpCloud
