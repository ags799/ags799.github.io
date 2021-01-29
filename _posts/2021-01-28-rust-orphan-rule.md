---
title: "Rust's Orphan Rule"
layout: post
date: 2021-01-28
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- rust
category: blog
author: andrew
description: What is Rust's Orphan Rule?
---

[Source.](https://doc.rust-lang.org/book/ch19-03-advanced-traits.html#using-the-newtype-pattern-to-implement-external-traits-on-external-types)

The orphan rule in Rust states that, to implement a trait for a type, either the trait or the type must be local to
your crate.

So you can
```rust
use std::fmt::Debug

struct YourStruct {
  // your fields...
}

impl Debug for YourStruct {
  // your implementation...
}
```
or you can
```rust
use url::Url;

trait YourTrait {
  // your methods...
}

impl YourTrait for Url {
  // your implementation...
}
```
but you cannot
```rust
use url::Url;
use std::fmt::Debug;

impl Debug for Url { // for what it's worth, Url already implements Debug
  // whatever...
}
```

# A Workaround
Make a _tuple struct_ out of the type, and implement the trait for that:
```rust
struct YourStruct(Url);

impl Debug for YourStruct {
  // remember that you can reach the inner Url with `self.0`
}
```
Next, if you want to reach all of the methods of the inner type (in this example, `Url`), implement `Deref` for your
tuple struct.
