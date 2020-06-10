---
title: "Less-Than-Obvious Kubernetes"
layout: post
date: 2020-06-06
image: /assets/images/markdown.jpg
headerImage: false
tag:
- development
- kubernetes
category: blog
author: andrew
description: The somewhat confusing details of Kubernetes I want to remember.
---

There's no doubt that Kubernetes pushes software development forward like gale-force winds. That doesn't mean its
interface is as clear as day. These are the less-than-obvious details of its CLI that I'd like to remember.


# Managing CronJobs
Really, the confusion boils down to this: you don't manage cronjobs like
```bash
kubectl describe job $name
```

You do it like this
```bash
kubectl describe cronjob $name
```

All I'm trying to say is, don't think of a cronjob as a kind of job. Cronjobs are cronjobs, jobs are jobs. That may be
obvious to some, it wasn't to me. Something to remember.
