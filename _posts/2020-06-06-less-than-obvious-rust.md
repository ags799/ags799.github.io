---
title: "Less-Than-Obvious Rust"
layout: post
date: 2020-06-06
image: /assets/images/rust.png
headerImage: false
tag:
- development
- rust
category: blog
author: andrew
description: I read the Rust book. Here are the confusing details I want to remember.
---

I started to learn Rust because it's a language that comes up in my work, and also to
gain a deeper understanding of systems languages and what problems they try to
solve.

I've never taken the time to truly understand another systems language, so take
this with a grain of salt, but I think that Rust makes for a great entry into this
category of languages. It's compiler works really hard to find potential bugs that other
systems languages might allow. It forces the developer to write good code,
and depending on your investment into understanding the compiler's error messages, you
have the chance to understand memory management on a deeper level.

I've been learning via
[the Rust book](https://smile.amazon.com/Rust-Programming-Language-Covers-2018/dp/1718500440/ref=sr_1_2?dchild=1&keywords=rust+book&qid=1591471713&sr=8-2).
I appreciate the careful pace and comprehensiveness of the book.

As much as I've come to respect Rust for all the work it does to make performant code
safe, there are a few less-than-obvious details of its syntax that I want to point out.
This is a list of things I think are important to remember as a beginner continues their
journey with Rust. Here they are:

# String Concatenation with +
E.g.
```rust
let s1 = "one".to_string();
let s2 = "two".to_string();
let s = s1 + s2;
println!("{}", s);
```

Gives the error
```
expected `&str`, found struct `std::string::String`
help: consider borrowing here: `&s2`
```

That's because `s1 + s2` doesn't concatenate two strings to form a third string. It's a
method on `s1: String` with one parameter `s2: &str`. It appends `s2` to `s1` and returns
a new `String`. `s1` is gone.

This is done to avoid copying `s1` and `s2` into a new string. It reuses `s1`, copies
`s2`, and clobbers `s1` as a side-effect.

That's fine and dandy, but not obvious given the syntax. If we really wanted to append
one string to another, our impulse would be `s1 += &s2`.

Regardless, there is an alternative that carries the semantics we're looking for:
```rust
let s1 = "one".to_string();
let s2 = "two".to_string();
let s = format!("{}{}", &s1, &s2);
```

`format!` takes two immutable strings and returns a `String`. It makes more copies than
`+`, but has the advantage of preserving immutability and not moving ownership of its
arguments. There are times when we can't afford to be so lax with memory usage, but in
other cases, `format!` makes for more maintainable code.
