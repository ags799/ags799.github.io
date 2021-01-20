---
title: "What is npm shrinkwrap?"
layout: post
date: 2020-01-20
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- npm
- shrinkwrap
category: blog
author: andrew
description: What is npm shrinkwrap?
---

Let's start from the top:

# What is `npm`?
The *Node package manager*. It's a command-line tool I describe [here](./from-zero-to-one-with-node/).
It's responsible for the `package.json` files in your JavaScript projects.

# What is `npm shrinkwrap`?
It's a subcommand of the `npm` tool. You run it within a Node project to create a file `npm-shrinkwrap.json`.

# What is the `npm-shrinkwrap.json` for?
It's a list of all of your dependencies and their exact versions.

# What do we need this?
Your dependencies and their versions are also described in your `package.json`, so why isn't that enough? Well,
`package.json` allows for some fuzzy matching with syntax like `^1.2.3`, which allows for version `1.2.3` and any
version that's backwards compatible with it, like `1.2.5` or `1.3.0`.

In theory, that should create a deterministic build. In practice, however, semantic versioning is more of a suggestion
than a rule, and it creates non-deterministic builds. So we have `npm-shrinkwrap.json` as a way of being more specific.
