---
title: Export your Salesforce Objects to SQLite
date: 2015-12-11T02:11:22+00:00
draft: false
tags: [elixir]
categories: [programming]
---

Sometimes it can be quite useful to export data you have in Salesforce Org (transferring your data over to a new system is probably the biggest use case).

[Saleforce's suggestion](https://help.salesforce.com/HTViewHelpDoc?id=exporting_data.htm) is to use the [dataloader](http://dataloader.io) but that has a lot of drawbacks:

- Flat File Format only
- Not (sufficiently) scriptable
- Manual process to select the fields you want (instead of just *everything*)
- Only one object at a time

As most of the information you need for a proper export a available via Salesforce's field description, it was pretty simple to come up with a solution that would let me export a range of objects to a database format (SQLite currently but very easy to extend for other RDBMS).

And here it is: [salesforce_exporter](github.com/propertybase/salesforce_exporter). With a simple export command you are now able to export as many objects as the org holds:

```elixir
client = SalesforceExporter.new
db = client.export(objects: ["Contact", "Account"], to: "sqlite://test.db")
```

Not only does it export all the data into an SQLite database; it also preserves the datatypes and sets the constraints accordingly:

- Data types will be converted to the closest [SQLite data type](https://www.sqlite.org/datatype3.html)
- Not Null and Unique constraints will be kept
- Id field will be set as primary key of the according table
