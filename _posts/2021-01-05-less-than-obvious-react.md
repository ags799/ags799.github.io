---
title: "Less-Than-Obvious React"
layout: post
date: 2020-06-06
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- react
- javascript
category: blog
author: andrew
description: I'm learning React. Here are the confusing details I want to remember.
---

I'm using React at work and want to keep track of some of the less-than-obvious details here in my blog. Here we go:


# useState vs. useRef
It's pretty clear that `useState` is used for component state and `useRef` is used to reference DOM elements. One of
the niceties of this comparison is that changing state causes a re-render, while changing a ref does not. That's all
I want to point out.
