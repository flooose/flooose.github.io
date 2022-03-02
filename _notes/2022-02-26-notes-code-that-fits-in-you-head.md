---
title: "Notes: Code that Fits in Your Head"
layout: post-03242013
published: true
---

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
- Comments aren't simply bad because they go out of date, but also
  because _code_ is the only artefact you can _trust_.
-
