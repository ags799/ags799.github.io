---
title: "The Difference Between Rust's Eq and Partial Eq"
layout: post
date: 2021-01-28
image: /assets/images/markdown.png
headerImage: false
tag:
- development
- rust
category: blog
author: andrew
description: What is a PartialEq, anyway?
---

It won't take long for a Rust learner to come across the trait `PartialEq`. If you want to compare instances of one of
your structs, it's what you do:
```rust
#[derive(PartialEq)]
struct YourStruct {
  your_field: i32,
}
```
It begs the question, surely there must be a trait `Eq`? There is. Let's talk about it.


# What is `Eq` and how is it different?
`Eq` is not a trait that requires you to implement new methods for your structs. It's a _marker trait_. You say that your
type implements the trait, like
```rust
impl Eq for YourStruct {}
```
and it tells the compiler that your type is `Eq`. Now code that expects an `Eq` type, like
[`core::cmp::Ord`](https://doc.rust-lang.org/1.8.0/core/cmp/trait.Ord.html), knows it can use your type.


# `Eq` inherits `PartialEq`
Alright, if this is the first time you've encountered trait inheritance, this probably comes across as a surprise. I
didn't know the term "inheritance" applied to anything within Rust until I came across this `Eq` vs. `PartialEq`
conundrum. Well, here it is:

A trait _inherits_ another trait when it has all the same requirements as that other trait. So when we say that `Eq`
_inherits_ `PartialEq`, it requires all the required methods of `PartialEq`. There's only one:
```rust
// this is an abbreviation of the real source
pub trait PartialEq {
  fn eq(&self, other: Self) -> bool;
}
```

We say that `Eq` inherits `PartialEq` in code with the `:` symbol:
```rust
// this is an abbreviation of the real source
pub trait Eq: PartialEq {}
```

So because `Eq` inherits `PartialEq`, if you want your type to implement `Eq`, it's going to need to implement
`PartialEq`:
```rust
impl PartialEq for YourStruct {
  fn eq(&self, other: &Self) -> bool {
    // do your thing...
  }
}
```

Then you have to throw in this last bit (mentioned earlier):
```rust
impl Eq for YourStruct {}
```


# Why Wouldn't We Do This All The Time?
`Eq` makes assumptions about your type that `PartialEq` doesn't. They both assume:
- symmetry: `a == b` implies `b == a`
- transitivity: `a == b` and `b == c` implies `a == c`

`Eq` also assumes:
- reflexivity: `a == a`

So if you can't guarantee that your `fn eq(&self, other)` implementation is reflexive, don't implement `Eq`!


# Side note: `Eq` is derivable
If all the fields of your type are `Eq`, you can derive it:
```rust
#[derive(Eq, PartialEq)] // don't forget PartialEq!
type YourStruct {
  your_field: i32,
}
```
