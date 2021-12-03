---
title: Never compare dates in Elixir using "<" or ">"
date: 2017-05-29T12:23:23+02:00
draft: false
tags: [elixir]
categories: [programming]
---

For the examples in this article I use the data structure [Date](https://hexdocs.pm/elixir/1.4.4/Date.html). The same applies for [DateTime](https://hexdocs.pm/elixir/1.4.4/DateTime.html) or [NaiveDateTime](https://hexdocs.pm/elixir/1.4.4/NaiveDateTime.html)

Consider this:

```elixir
early_june = ~D[2017-06-01]
late_june = ~D[2017-06-30]
```


How do you find out what's earlier?

The naive approach is to use the comparison operator `<`:

```elixir
early_june < late_june
# => true
```


That works. But this is tricky. It only works in some cases.

Now consider this:

```elixir
late_june = ~D[2017-06-30]
early_july = ~D[2017-07-01]
```


What do you think the output is now?

```elixir
late_june < early_july
# => false
```

Turns out: comparison with `<` (or `>`) just compares the struct fields (as the [current version of the documentation](https://hexdocs.pm/elixir/master/DateTime.html) states. My best guess is for same reason the day field has higher priority than the month field so this comparison fail sometimes.

To solve this use the `compare` function of the according modules:

```elixir
Date.compare(late_june, early_july) == :lt
# => true
```
