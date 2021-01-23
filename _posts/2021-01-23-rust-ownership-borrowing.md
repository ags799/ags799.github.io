---
title: "The Rules Behind Rust Ownership and Borrowing"
layout: post
date: 2021-01-23
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- rust
- ownership
- borrowing
category: blog
author: andrew
description: The fundamental rules behind ownership and borrowing in Rust.
---

Rust's ownership and borrowing systems are fundamental to one of its greatest features: automated memory management
without garbage collection.

Wrapping your head around these features can be tough in practical code, however. Here's the most concise list of rules
I could come up with to describe the model:

1. Each value has exactly 1 owner.
1. When the owner goes out of scope, the value will be dropped.
1. At any given time, a value may have one of the following (not both):
  - 1 mutable reference
  - any number of immutable references
