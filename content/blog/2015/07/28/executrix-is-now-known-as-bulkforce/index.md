---
title: Executrix is now known as Bulkforce
date: 2015-07-28T11:36:59+00:00
draft: false
tags: [ruby]
categories: [programming]
---

Today I released a new version of the ruby gem to interact with the Salesforce [Bulk API](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/).

I decided to go with a different name and introduce some breaking changes.

And here it is: [Bulkforce](http://github.com/propertybase/bulkforce).

The [old gem](old gem) will still be available as a reference and to provide a backwards compatible option for all users out there. New features however will only be introduced in Bulkforce.

Not only did I rename the gem, I also introduced a new feature. The authentication has been overhauled.

Now the constructor takes a hash instead of a list of user, password and security token.

Furthermore authenticating via [session_id](https://github.com/propertybase/bulkforce#session-id-and-instance) and [oauth](https://github.com/propertybase/bulkforce#oauth) are possible.

In addition to that, [authentication via env variables](https://github.com/propertybase/bulkforce#env-variables) is possible now as well.
