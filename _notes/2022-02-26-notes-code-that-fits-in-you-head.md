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
- I'm having a hard time seeing the advantage of creating small,
  feature-toggled MRs for a feature that I'm developing.
- OpenAPI builds its feature set on REST and is simply a framework for
  creating rest APIs from configuration (yaml, json) files.
- Feature flags are good in cases of refactoring. Add a new, more
  well-designed method to your class, leave the old one. That's one
  MR. Then _one after the other_ replace the usages. For simple
  refactorings, this may be overkill, but for more complicated ones,
  each call to the method can be its own MR.
- Strangler pattern: In refactoring, adding a new method and then
  one-by-one migrating the places that called the old implementation
  to calling the new implementation.

### 11. Editing Unit Tests

- "formally speaking...you can't refactor unit tests" p. 224
- Test code has a dependency on production code and vice versa. For
  this reason you should edit them independent of one-another. If the
  test code is working, you can change production code. If production
  code is working, you can change test code. Changes to either one
  aren't guaranteed to be safe.
- Interaction with the external world should happen in the shape of
  polymorphic types, e.g. interfaces.
- How do you get similar help out of a dynamic language as static
  typing gives you in static languages? There has to be some other way
  of achieving the same. In the end, you do have more flexibility with
  dynamic languages.
- When you're struggling through code, it might be good to describe
  what's happeinging and then explicitly "tagging" anything that's a
  black hole.

### 12. Troubleshooting

- race conditions are fixed by serializing reads and writes p. 249

### 13. Separation of Concerns

- Things that change at the same rate belong together. Things that
  change at a different rate belong apart. p. 257
- Maybe you should be the driver of decomposing code
- ActiveRecord method chains are an example of sequential
  composition. p 262
- a pure function is equal to its output. In that sense, they amplify
  the essential p. 264
- I think cross-cutting concerns in Rails tends to be handled by
  middleware, not decorators.

### 14. Rhythm

- Take breaks, even if you're in the zone. It might help you realize
  that you're going the wrong way. Usually if you're in the zone and
  you are on the right way, a five minute break won't hurt your
  rhythm.
- I don't recall having had a single revelation while sitting in front
  of the computer. p 278
