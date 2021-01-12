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
category of languages. Its compiler works really hard to find potential bugs that other
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


# Clone vs Copy
From [the docs](https://doc.rust-lang.org/std/clone/trait.Clone.html#:~:text=Differs%20from%20Copy%20in%20that,Clone%20and%20run%20arbitrary%20code.),
> `Copy` is implicit and extremely inexpensive, while `Clone` is always explicit and may or may not be expensive.


# Vec<T>, [T], and &[T]
Let's get some terminology out of the way:

**array.** A fixed-length list where all elements share a type. Coded as `[a, b, c]`. Can be typed as `[i32]` or with the
length as `[i32; 5]`.

**slice.** A reference to a part of an array. If we have an array `a = [1, 2, 3]`, we can get a slice with `&a[0..2]`. A
slice can be typed as `&[T]`.

**vector.** A dynamic-length list where all elements share a type. Coded as `vec![a, b, c]`. Typed as `Vec<T>`.

At this point you might be wondering, is something still a *slice* if we include the whole range? That is, is there a
difference in name between a `&a[0..2]` a `&a`? AFAICT, they're both *slices*. Maybe I'm wrong.

One thing is for sure, `&Vec<T>` is `&[T]`. If you have a `fn f(a: &[i32])` you can pass it `&vec![1, 2, 3]`. It
doesn't work the other way around of course. The takeaway is: you better have a good reason to write a function with a
`&Vec<T>` parameter. `&[T]` is safer.

## What about String, str, [char], and [u8]?
Before moving on to using any of these types, ensure that you're working with *text*. The kind you'd print to the screen.
There's no reason to deal with the following complexity otherwise.

That said, **str** seems to be a synonym for `[u8]`. Just as you can have a slice like `&[u8]`, `&str` is a *string slice*.

**String** is definitely the analog to *vectors*. It's a list of UTF-8 characters that can change in length. Of course, being
UTF-8, there's a lot of other features that vectors don't have. But it's the same idea.

There isn't so much interoperability with `[char]`. `str` is not `[char]`, neither is
`String`, and it doesn't work the other way around, either. So `&str` seems like the
greatest common denominator for working with strings. When you think about it, `[char]`
is something different. It isn't a contiguous series of space-saving UTF-8. It's an
array of UTF-8 characters, and my guess is each character occupies the full 4 bytes.


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


# How does *for i in v* work?
I'm not talking about
```rust
for i in v.iter()
```

or
```rust
for i in v.iter_mut()
```

Just plain old `for i in v`.

It's syntactic sugar for `for i in v.into_iter()`. In other words, `v` needs to implement
[IntoIterator](https://doc.rust-lang.org/std/iter/trait.IntoIterator.html).


# &Trait, Box&lt;Trait&gt;, impl Trait, and dyn Trait

Read [this](https://joshleeb.com/posts/rust-traits-and-trait-objects/).


# All Closures Have Types

Rust lets you elide type annotations on closures. So while you'd have to type a function:
```rust
fn identity(x: u32) -> u32 { x }
```
you don't need to type a closure
```rust
let identity = |x| x;
```
That doesn't mean the closure has a more flexible type, however. You can't
```rust
let identity = |x| x;
identity("Hello");
identity(5);
```
Here, the compiler gives `identity` type `Fn(String) -> String`. It makes this inference from the function body and the
first call to the function. The second call won't compile because it fails the inferred type check.
