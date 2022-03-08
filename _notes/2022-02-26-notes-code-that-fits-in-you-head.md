---
title: "Notes: Code that Fits in Your Head"
layout: post-nojs-03242013
published: true
---

## Part 1

- cyclomatic complexity starts at 1, i.e. simply having a method
  implies one. Any if-statement/branching-statement after that is
  already a 2.
- The notion that objects should never be able to be in an invalid
  state flies in the face of Rails, where the models are explicitly
  designed with erroneous states in minde
- DTOs "model messy interactions with the outside world". In
  dotnet/csharp, models are intended to always be in a valid state.
- DTOs have a `validate()` method that return a valid model.
- Parse don't validate - _projecting_ the input data into a stronger
  representation of the same data. -- Alexis King
- A parser is a function that turns less structured data into more
  structured data. It is a partial function, where some values in the
  domain do not map to values in the range. All parsers have some
  notion of failure. -- Alexis King p. 148
- Startup.cs is the entry point in a dotnet application
- Fractal architecture - the highest level of resolution is when
  methods don't call any other parts of your code.
- Cyclomatic complexity and number of variables are considered
  independent of one another.
- Code degrades over time p. 153
- When you think of API design, think in terms of affordance.
- dot-driven-development - development with the help of an IDE in
  statically typed languages
- I wish essay writing had been taught to me in terms of _Sender_ and
  _Receiver_. p. 160
- Code is read more than it is written p. 160

### Chapter 8

- Comments aren't simply bad because they go out of date, but also
  because _code_ is the only artefact you can _trust_.
- _Commands_ are methods that produce side effects and should return
  void to signal this
- _Queries_ are methods that return data and should be without side
  effects.
- How does this work with newly created objects. Don't you want, for
  instance, the id of the newly created record?
- We should use more custom validator classes, as well as
  `EachValidator`s
- It also seems worth creating lib/models for domain models in the
  sense of DDD, i.e. models that aren't bound to active record, but
  represent the domain anyway.
- Evaluate programmer-semantic vs. domain-semantic
- Command/Query separation doesn't see Queries as side effects. In
  Haskell any kind of IO is a side effect
- Separating "repository" functionality from "model" functionality as
  DDD describes them, is analog to the model/view-model separation
  that we sometimes see discussed in rails.
- What are DTOs in dotnet, are they analogous to view-models, are they
  a level of abstraction between the controller and the view-model?
- When you're changing code, it's imporant to reflect on whether
  you're (at any given time) _dealing_ with an implementation detail
  or _changing_ an implementation detail p. 174
- A major hurdle in abstracting and simplifying code in a domain
  oriented way, aside from the actual code, is the fact that in any
  domain, you're going to have a limited knowledge of the domain, so
  your "vocabulary" may run out at some point.

  Additionally, depending on the length of their tenure in a project,
  different developers have different levels of knowledge over the
  domain. Perhaps this is what separates "staff" from "principal" from
  "normal" developers in an organization. It's as much the general
  programming knowledge as it is the specifics of the domain.

### 9. Teamwork

- A code review that takes more than an hour isn't effective p. 295
- Ownership over certain parts of code is fine as long as it's "weak"
  ownership. p. 199

Summary: Mostly about collaboration, reflective of things I've
internalized.

## Part 2: Sustainability

### 10. Augmenting Code

- (according to chapter 9), you should merge into "main" at least
  twice a day? I'm not sure how I feel about this. In most of my
      experience, that should mean merging incomplete features.
- Important to learn: the difference/relationship between OpenAPI and
  Rest
