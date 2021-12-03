---
title: My First Event Sourced Application
date: 2018-01-09T10:53:43+00:00
draft: false
tags: [elixir]
categories: [programming]
---

![arrows](header.jpg)

*TL;DR:* I built an event sourced application that shows the latest version of common programming languages. Find it [here](https://releaseping.com).

For I while I thought about building an [event sourced](https://martinfowler.com/eaaDev/EventSourcing.html) application. The concept is so different from a classical CRUD approach that I was very intrigued.

I tried once with a podcasting transcription app (the details of that can be read [here](/blog/2017/12/12/how-playing-around-with-experimental-technologies-landed-me-a-6-month-freelance-gig/)) but I quickly became overwhelmed by all the design decisions I had to make.

After a while, I stumbled upon an event sourcing library called [commanded](https://github.com/commanded/commanded) which already provides a lot of the parts you need for an ES application.

After playing around with it I quickly decided on a problem I wanted to solve for myself:

**I want to have an overview of the latest versions of the most common programming languages**

Spoiler alert you can find it here: [https://releaseping.com](https://releaseping.com)

Obviously, I didn't want a spreadsheet but a system that automatically updates itself.

Choosing an ES application for this use seemed like a good idea, so I got started.

I pretty quickly had a general idea. Most of the programming languages out there have a Github repository (or at least a GitHub mirror) with the versions defined as git tags.

So pretty much all I need to do is poll the tags of these repositories and whenever I find a new version, dispatch it as a command.

But first I need an aggregate and a genesis event to create it:

```elixir
defmodule AddSoftware do
  defstruct [
    uuid: nil,
    name: nil,
    website: nil,
    github: nil,
    licenses: []
  ]
end
```


Dispatching this command to the aggregate will create a new piece of software (if not already present):

```elixir
def execute(%Software{uuid: nil}, %AddSoftware{} = add) do
%SoftwareAdded{
      uuid: add.uuid,
      name: add.name,
      type: add.type,
      website: add.website,
      github: add.github,
      licenses: add.licenses
    }
  end
end
```


After this a scheduled process will poll all tags from the configured github repository and dispatch `PublishRelease` commands:

```elixir
def execute(%Software{} = software, %PublishRelease{} = publish) do
  cond do
    is_nil(publish.version_string) -> nil
    MapSet.member?(software.existing_releases, publish.version_string) -> nil
    true ->
      %ReleasePublished{
        uuid: publish.uuid,
        software_uuid: publish.software_uuid,
        version_string: publish.version_string,
        release_notes_url: publish.release_notes_url,
        display_version: display_version,
        published_at: Conversion.from_iso8601_to_naive_datetime(publish.published_at),
        pre_release: publish.pre_release,
      }
  end
end
```


Some basic validation (don't emit event when version has already been captured before or if the version information is nil) and then a new `ReleasePublished` event is emitted. The field `pre_release` is a boolean that indicates if the version is a pre_release (alpha, beta, rc etc...).

I have implemented some other events (mainly for correcting previously entered fields) but that is the gist of it.

From these 2 events you can build the projection that makes up the page:

```elixir
defmodule ReleasePing.Api.Projectors.Software do
  use Commanded.Projections.Ecto, name: "Api.Projectors.Software"

  project %SoftwareAdded{} = added, %{stream_version: stream_version} do
    Ecto.Multi.insert(multi, :software, %Software{
      id: added.uuid,
      stream_version: stream_version,
      name: added.name,
      slug: added.slug,
      website: added.website,
      licenses: Enum.map(added.licenses, &map_license/1),
    })
  end

  project %ReleasePublished{} = published, _metadata do
    existing_software = Repo.get(Software, published.software_uuid)
    existing_stable = existing_software.latest_version_stable
    existing_unstable = existing_software.latest_version_unstable

    version_info = published.version_string

    stable_version_to_set = cond do
      published.pre_release -> existing_stable # published version is not a pre release? no change here
      existing_stable == nil -> new_version # version has not been set before? latest version will be changed
      VersionUtils.compare(new_version, existing_stable) == :gt -> new_version  # version is newer? latest version will be changed
      true -> existing_stable # for everything else, don't change the version
    end

    # same applies for the unstable version, except we ignore the `pre_release` flag
    unstable_version_to_set = cond do
      existing_unstable == nil -> new_version
      VersionUtils.compare(new_version, existing_unstable) == :gt -> new_version
      true -> existing_unstable
    end

    changeset = existing_software
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_embed(:latest_version_stable, stable_version_to_set)
      |> Ecto.Changeset.put_embed(:latest_version_unstable, unstable_version_to_set)

    Ecto.Multi.update(multi, :api_software, changeset)
  end
end
```

There's more to it, specifically, the polling from Github is a little bit more tricky as not all programming languages follow the same version scheme.

In the end, I had a lot of fun building it and am already thinking of possible features to implement.

[Contact me](https://twitter.com/leifg) with ideas on where to take this.
