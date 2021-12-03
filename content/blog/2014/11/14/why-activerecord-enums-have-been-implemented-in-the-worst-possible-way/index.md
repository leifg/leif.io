---
title: "Why ActiveRecord Enums Have Been Implemented in the Worst Possible Way"
date: 2014-11-14T10:38:04+00:00
draft: false
tags: [ruby,rails]
categories: [programming]
---

**UPDATE:** I tried out enums in ActiveRecord 5.0 and the biggest pet peeve has been eliminated. Point 3 is no longer valid. Nevertheless decide for yourself if you want to use it.

With Rails 4.1 [enums have been introduced to ActiveRecord](http://edgeguides.rubyonrails.org/4_1_release_notes.html#active-record-enums). I took a good look at it and from the start I didn't like it. Here are 3 reasons why:

## 1. It's all in the application layer

Ok this might be a bit unfair as Rails **is** the application layer. Nevertheless the feature could have taken advantage of [Postgres'](http://www.postgresql.org/docs/9.1/static/datatype-enum.html) or [MySQL's](http://dev.mysql.com/doc/refman/5.0/en/enum.html) native type. An example of how that could look like is in my experimental gem [activerecord-real_enums](http://github.com/leifg/activerecord-real_enums).

## 2. It's based on integers

From time to time I'd like to look in the database. And seeing a row that has a value 1 for the the column 'status' doesn't help much in understanding the datamodel.
But even if you load the model using the Rails console it takes a while to get what's going on. Using the [Rails example](http://api.rubyonrails.org/v4.1.0/classes/ActiveRecord/Enum.html) this is what I mean:

```ruby
Conversation.last
=> #<Conversation
      id: 1,
      name: "I talk a lot",
      status: 0,
      created_at: "2014-11-14 10:06:00",
      updated_at: "2014-11-14 10:06:00">
```

The status visible in the model is displayed as an integer. So an additional step is necessary to actually find out what "0" actually stands for.

```ruby
Conversation.last.status
=> "archived"
```

## 3. It breaks query interface

OK question time. Suppose you have the Conversation model with 2 status ("active" as 0, and "archived" as 1). Now you do the following query:

```ruby
Conversation.where(status: "active")
```

What do you get? Exactly! All active conversations. Quite what you would expect.

Next question. Take the following query:

```ruby
Conversation.where(status: "archived")
```

What do you get?

...

wait for it

...

If your answer is: "All archived conversations." you are **WRONG**

Again you will get all **active** conversations.

**But why?**

Turns out, the query interface of ActiveReord will convert the input string to integer by using the `#to_i` method of ruby. And any string that cannot be parsed as a number will return 0 (the integer for status "active").

Hint: The correct way for querying the archived conversations would be:

```ruby
Conversation.where(status:  Conversation.statuses[:archived])
```

## Conclusion

Particular the last point I find problematic because it contradicts expectation. Even worse it will work sometimes. Especially when the first value of the enum is the most common one the error will go unnoticed on the first try.

If you want an alternative I suggest the enum type of the underlying database. If you don't want to rely on a specific database you could also use a gem like [symbolize](https://github.com/nofxx/symbolize) that uses strings as representation for enums.
