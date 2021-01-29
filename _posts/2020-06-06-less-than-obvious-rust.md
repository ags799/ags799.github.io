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


# What is a Mutable Reference?
Okay so we know that if we want to change a variable, we have to make it mutable:
```rust
let mut i = 1;
i = 2;
```
And sometimes when we pass a variable around, we just want to pass a reference to that variable:
```rust
let mut i = 1;
do_something(&i);
```
Did you know that `do_something` would not be allowed to change the variable with `*i = 3`?

What if we wanted to pass a reference to the variable to a function, and we wanted to modify the variable in that
function? We would use a _mutable reference_:
```rust
let mut i = 1;
do_something(&mut i);
```


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


# You Can Make Structs from Tuples
Coming from Go, this kind of struct syntax in Rust was pretty familiar:
```rust
struct Person {
  name String,
  age i32,
}
```
What was surprising, however, was that you could make a struct out of a tuple:
```rust
struct Years(u32)


fn main() {
  let y = Years(5);
  println!("{}", y.0); // "5"
}
```
These are called _tuple structs_.


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


# You can do a _lot_ with Patterns
```rust
match x {
  1 | 2 => "multiple patterns",
  3 ... 5 => "ranges",
  Color { red: 255, .. } => "use `..` to ignore the rest of the fields in a struct",
  Color { blue, .. } => "get the `blue` field without using `:`",
  Color { blue: value @ 120 ... 200 } => "capture the `blue` field in `value` and test that it's in a range",
  _ => "catch-all",
}
```


# The Order of Operations with Patterns and Match Guards
Firstly, you need to know that you can do some crazy stuff with `match`:
```rust
match x {
  1 | 2 | 3 => println!("x is 1, 2, or 3"),
  _ if x > 10 => println!("x is greater than 10"),
  _ => println!("x is between 4 and 9, inclusive"),
}
```
What about this?
```rust
match x {
  1 | 2 | 3 if y == 0 => println!("x is 1 and y is 0, or x is 2 and y is 0, or x is 3 and y is 0"),
  // etc...
}
```
Basically, it's not-so-obvious that the _match guard_ `y == 0` applies to all the patterns on the left. Just wanted to
point that out.


# How can I use a Trait as a Parameter Type?
Rust doesn't let you do
```rust
fn f(s: Debug) { // replace `Debug` with any trait
    // do something
}
```
You have to do
```rust
fn f<T: Debug>(s: T) {
    // do something
}
```


# Navigating the Maze of Generic Syntax for Traits
The difficulty here is best explained with an example:
```rust
impl<T> SomeTrait<T> for SomeStruct {
  fn some_method(&self, parameter: T);
}
```
That's a lot of `<T>`. Let's break it down:
```rust
// let's start by describing our trait
trait SomeTrait<T> { // so our trait takes a type parameter
  fn some_method(&self, parameter: T); // this same type parameter is used in a method
}

// now we implement for a specific T
impl SomeTrait<i32> for OurStruct {
  fn some_method(&self, parameter: i32) {
    // whatever...
  }
}
```
Alternatively, we could do this generic implementation, _but you can't have both_:
```rust
// we have to have `<T>` after `impl` to indicate that we are parameterizing the trait
impl<T> SomeTrait<T> for SomeStruct {
  fn some_method(&self, parameter: T) {
    // whatever...
  }
}
```
Want things to get even crazier? What if we did it with a generic struct:
```rust
struct SomeStruct<T> {
  item: T,
}

// you can only use one of these impl blocks:
// 1. generic struct
impl<T> SomeTrait<i32> for SomeStruct<T> {
  fn some_method(&self, parameter: i32);
}

// 2. generic trait
impl<T> SomeTrait<T> for SomeStruct<i32> {
  fn some_method(&self, parameter: T);
}

// 3. both are generic
impl<T, U> SomeTrait<T> for SomeStruct<U> {
  fn some_method(&self, parameter: T);
}
```


# What is a Trait Object?
Quoting from the book:
> A trait object points to both an instance of a type implementing our specified trait as well as a table used to look
> up trait methods on that type at runtime.

Remember that these objects _point_ to the instance of the type. So they have to be represented as a pointer, with `&`,
`Box`, or some other pointer. We also must use the `dyn` keyword, for reasons I haven't understood yet.

So it would look like
```rust
Box<dyn Trait>
```

Another quote from the book, helps in understanding the etymology:
> ...we refrain from calling structs and enums "objects" to distinguish them from other languages' objects...the data
> in the struct fields and the behavior in `impl` blocks are separated...[h]owever, trait objects _are_ more like
> objects...in the sense that they combine data and behavior.


# Only Certain Traits can be Trait Objects
In order to be a _trait object_, a trait must be _object-safe_. In order to be _object-safe_, all methods of the trait must:
- not return `Self`
- have no generic type parameters


# Traits Can Inherit Other Traits
That's right: Rust does have inheritance. Not the object kind though. A _trait_ can inherit another trait. It's like
saying that the trait requires all of the things of the other trait, and then some new stuff. Here's an example:
```rust
trait Phone {
  fn call(&self, contact: Contact);
}

trait Smartphone: Phone { // note the colon, that's the syntax, Smartphone inherits Phone
  fn browse_web(&self, website: Url);
}
```
One last bit of terminology, here we say that `Phone` is a _supertrait_ of `Smartphone`.


# &Trait, Box&lt;Trait&gt;, impl Trait, and dyn Trait
First, see the heading "What is a Trait Object?".

Then, read [this](https://joshleeb.com/posts/rust-traits-and-trait-objects/).


# All Closures have Types

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


# Each Instance of a Closure has its Own Type
That is, in
```rust
let f1 = |x| x;
let f2 = |x| x;
```
`f1` and `f2` have different types. What does this mean in practical programming? You *cannot* do this:
```rust
struct S {
    closure: Fn(u32) -> u32,
}

fn main() {
    let f = |x| x;
    let s = S { closure: f };
}
```
The compiler won't let you use `f`, a closure, as this field, because it considers the closure to have its own type
(you might see the type reported as something like `[closure@src/main.rs:20:13: 20:18]`).

To use a closure here, you have to use a _generic_:
```rust
struct S<T where T: Fn(u32) -> u32> {
    closure: T,
}
```


# Nested Functions Cannot Use Variables in the Outer Scope
We all love closures for letting us do things like
```rust
let x = 1;
let c = |y| y == x;
```
and Rust permits us this fancy.

However, if it strikes our fancy to use function syntax instead:
```rust
let x = 1;
fn f(y: i32) -> bool { y == x };
```
We'll get an error. Rust doesn't let nested functions use variables in the outer scope.


# What's the Difference Between an Associated Type and a Generic?
A generic:
```rust
trait Throw<T> {
  fn throw(&self, item: T);
}
```
can be implemented for a type in multiple ways:
```rust
struct Person {
  name: String,
}

impl Throw<Baseball> for Person {
  fn throw(&self, item: Baseball) {
    // throw the baseball
  }
}

impl Throw<Football> for Person {
  // you get it...
}
```
You can even parameterize your implementation:
```rust
impl<T> Throw<T> for Person {
  fn throw(&self, item: T) {
    println!("{} threw something", self.name);
  }
}
```
Associated types, on the other hand, only allow you to implement the trait one way:
```rust
trait Kick {
  type Item;

  fn kick(&self, item: Self::Item); // note the need to use `Self::` to address `Item`
}

impl Kick for Person {
  type Item = SoccerBall

  fn kick(&self, item: Self::Item) {
    // kick the soccer ball...
  }
}
```
