<div align="center">

# `cid`

**`cid`** ("content id") is a _human-friendly_
_unique_ ID function 
used by mobile-first/distributed apps.

![Snowflake-intro-image](https://github.com/dwyl/mvp/assets/194400/3ae84c13-3493-4012-b667-8af9377a66b6)

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/cid/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/cid/main.svg?style=flat-square)](http://codecov.io/github/dwyl/cid?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/excid?color=brightgreen&style=flat-square)](https://hex.pm/packages/cid)
[![Libraries.io dependency status](https://img.shields.io/librariesio/release/hex/cid?logoColor=brightgreen&style=flat-square)](https://libraries.io/hex/cid)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/cid/issues)
[![HitCount](http://hits.dwyl.com/dwyl/cid.svg)](http://hits.dwyl.com/dwyl/cid)


</div>

<!-- add link to example of single-server setup using cid!
> **Note**: `cid` can also/easily be used for centralised apps
which do not require offline/client support.  
-->

# Why?

We needed a way of running our App(s) across multiple servers/devices
without fear/risk of collisions in the IDs of records.

# How?

1. Add `excid` to your list of `deps` in your `mix.exs` file:

```elixir
def deps do
  [
    {:excid, "~> 0.1.0"}
  ]
end
```

then run `mix deps.get` to download.

2. Define in your mix configuration which base you want to use to create the cid.
The value of the base should be the either `:base32` or `:base58`.
If the base is not defined then `excid` will use the `base32` by default.

```elixir
config :excid, base: :base32
```

3. Call the `cid/1` function 
  with a `String`, `Map`, or `Struct` as the single argument:

```elixir
Cid.cid("hello")
"zb2rhZfjRh2FHHB2RkHVEvL2vJnCTcu7kwRqgVsf9gpkLgteo"

Cid.cid(%{key: "value"})
"zb2rhn1C6ZDoX6rdgiqkqsaeK7RPKTBgEi8scchkf3xdsi8Bj"
```

If the argument is not one of the ones listed above 
then the function will return `"invalid data type"`.

```elixir
Cid.cid([])
"invalid data type"
```

# What?

The goal is to allow records to be created _offline_ (_e.g: on a mobile device_)
with the ID generated on the _client_ and when the record is synched/saved
to the server (database) it can be _verified_
and the ID does not need to change.
Furthermore because the ID is based on a cryptographic hash
there is virtually zero chance of collision. 

We _could_ have used "_Ye olde_" **UUID** (_random/nondeterministic_)
as the IDs and achieve the desired collision-avoidance,
but we felt we could do _much_ better
and allow us to build a "checksum" mechanism
into our app that will _verify_ records created by any device
to allow an _effortless_ distributed/decentralised system.

This may all sound "esoteric" if you have not yet built
an "offline-first" application. Our hope is that this `README.md`
will _clarify_ our _reasoning_ for "_reinventing the wheel_".

## Context

In a "basic" Relational Database
(e.g: PostgreSQL, MySQL, MariaDB, etc.)
the default way of identifying records
is using an auto-incrementing integer: 1, 2, 3, etc.
This is the _optimal_ way of referencing records
in a _single_ (database) server setup
where the counter
for the number of records
in a given table
only needs to be known by one machine
and there is no chance of conflict.
e.g. if there are currently 100 blog posts in the database,
the server will assign the _next_ blog post the id **101**;
there is no chance that it will create a `new` post with id **99**
which would conflict with the post you wrote yesterday.

## Centralised = _Single_ Point of _Failure_

As users of software or beginners _building_ apps,
we don't often think about _failure_.
The _reality_ however, is that systems fail _all-the-time_.
All the most popular systems/services fail even Google
who have _thousands_ of world-class engineers dedicated
to keeping the system up.

Most Apps are designed to be centralised
because it's _much_ easier to get started
and for the most part there won't be any issues.

The problem comes when something in the system (_e.g: the database_) _fails_.

![centralised-vs-distributed](https://user-images.githubusercontent.com/194400/49139062-bd79a300-f2e8-11e8-9041-ab5c1b98ee86.png "centralised versus distributed networks")

If the _single_ databases server handling all the requests
fails, _all_ users are affected by the outage
for as long as it takes the team to revive it.

> Having witnessed ***Distributed Denial of Service*** ("DDoS") attacks
_first-hand_, we have _experienced_ the pain of having to recover
crashed servers with corrupted mission-critical customer data; it's bleak.
Yes, there are services like
[CloudFlare](https://www.cloudflare.com/ddos)
or
[Imperva](https://www.incapsula.com/ddos-protection-services.html)
which promise to _mitigate_ against DDoS attacks,
however the _reality_ is that they are only providing "frontend" protection;
if for _any_ reason your _single-server_ database was to _crash_,
your app will still be out-of-action regardless of having CloudFlare.

## Why _Decentralise_?

If you have _never_ had the experience of being _offline_
or the service you are using being interrupted,
then you either live in hyper-connected Paolo Alto
(_with backup/redundant networks and city-wide WiFi_)
or simply don't _use_ the Internet "_enough_" to notice the outages.

All the work we do depends on having access to the Internet.
We need to _systematically_ `reduce` that dependency.

Network and hardware ***fault-tolerance*** is ***essential***
for many apps and enables a whole _new_ "class" of apps to be created.

Specifically applications that are "federated".
see: https://en.wikipedia.org/wiki/Federated_architecture

The Apps that we (@dwyl) are creating
_must_ be decentralised;
there _cannot_ be a single point of failure.

Decentralisation is not just "_philosophical_" argument,
as creative technologists we are _directly_ responsible
for the technology we create.
The lives of _billions_ of people are at stake
if we continue to _allow_ the centralised _control_
of our communication networks.

If you believe in
the universal human right to
[privacy](https://www.un.org/en/universal-declaration-human-rights)
[Article 12]
_freedom_ from oppression
and the [Golden Rule](https://en.wikipedia.org/wiki/Golden_Rule),
then _logically_ this is the _only_ thing to do.

# Who?

Anyone who is techno-curious about the future of the Internet
and wants to _understand_ the way decentralised applications
derive the IDs for content.

We feel that _most_ apps can benefit
from being decentralised/distributed by `default`
because it means they work "***offline***" when any element fails
and data can easily be "synched" (_and verified_)
when connection is re-established.

If you want to build a
**mobile/offline-first _progressive_ mobile web app** (PWA)
that **feels _native_** on both Android and iOS,
then _understanding_ CIDs is a good place to start.

> If you are building apps that will use a _single_ database instance
for whatever reason (_e.g: they aren't very "complex"
or don't need to be distributed or work offline-first_)
keep enjoying the simplicity and maybe come back to this
later when you feel you _need_ this functionality.

# What?

In a distributed database, we need a way of creating IDs
for the records without any risk of "collision".
We _also_ need a _consistent_ way of creating IDs both on the server
and on the client (_to allow for offline-first distributed apps_).

### Why _Not_ Use UUIDs?

There are _many_ ways of creating unique IDs,
the most popular has historically been UUID (Universally Unique Identifier)
https://en.wikipedia.org/wiki/Universally_unique_identifier

A UUID is a 128-bit number usually represented as base16 (_hexadecimal_)
for example:
```
85594564-5be7-465f-b007-0fada384ed44
```
(via https://www.uuidgenerator.net )

Consider the following URL
(_featuring a **UUID** as the `id` of a record_):

location-app.com/venues/85594564-5be7-465f-b007-0fada384ed44

It doesn't exactly roll off the tongue. 🙄

append-only log.

One of our ... readable/typeable[<sup>1</sup>](#notes)

```
123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz
```
With a **56** characters in the set,
we can create IDs of the following lengths:<br />
+ 2: **56^2** = 3,136
+ 3: **56^3** = 175,616
+ 4: **56^4** = 9,834,496
+ 5: **56^5** = 550,731,776
...
+ 22:

Crucially, we can create a system where the IDs start out at 2 characters
and increase gradually as required
(_similar to how Instagram grew their IDs as they scaled, see below_).


# Real world usage

### `cid` from a `String`

A real world use case for
wanting a `cid` based on a `String`
is a URL shortener.
For example you have a long URL:
https://github.com/dwyl/phoenix-ecto-append-only-log-example
the `cid` of this url is:

```
require Cid

Cid.cid("https://github.com/dwyl/phoenix-ecto-append-only-log-example") # > "zb2rhjLfmD2trAmpEi3ZJSpFtuNokCrpfFido7QHCQRVnGoZW"
```

We can then create a URLs table
in our URL shortening app/service
with the following entry:

| `inserted_at ` | **`URL`** (PK)                                               | `cid`                                   | `short` |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------- | ----- |
| 1541609554     | https://github.com/dwyl/phoenix-ecto-append-only-log-example | zb2rhjLfmD2trAmpEi3ZJSpFtuNokCrpfFido7QHCQRVnGoZW | zb2   |

So the "short" url would be
[dwyl.co/zb2](https://github.com/dwyl/phoenix-ecto-append-only-log-example)

This is a relatively "boring" but still perfect _valid_ use case.
If someone attempts to create a short URL for this (_same_) _long_ URL,
the URL shortening app will simply return
[dwyl.co/zb2](https://github.com/dwyl/phoenix-ecto-append-only-log-example)
the _same_ short URL each time.

The _reason_ we can abbreviate the URL to just `zb2`
is because our SHORT URL service has a _centralised_ Database/store.
If we wanted to run a _decentralised_ content addressing system,
we would simply link to the _full_ `cid`:
[dwyl.co/zb2rhjLfmD2trAmpEi3ZJSpFtuNokCrpfFido7QHCQRVnGoZW](https://github.com/dwyl/phoenix-ecto-append-only-log-example)

Where the chance of `cid` collision
is less than 1 in "the number of
atoms in the Universe".
If we generated 1 Billion CIDs per _second_
for the next Trillion years there would
still be less than a **0.001%** chance of collision.<sup>3</sup>

<!-- ### `cid` from a `Map` -->
<!-- add example for map. Can link to https://github.com/dwyl/phoenix-ecto-append-only-log-example/issues/22
when then example is finished. -->


## Tests

The tests for this module are a combination of doctests, unit tests and property based tests.

To run the property based tests you will need to install [IPFS](https://ipfs.io/).
See https://github.com/dwyl/learn-ipfs#how for details.

The property based tests will run by default. These tests are more comprehensive
when compared to the "regular" tests. They will run the `Cid.cid` function on
100 randomly generated strings and maps, comparing the results of these to the
IPFS generated cid, ensuring our function is correct in its implementation.

These tests take a little longer to run that the "regular" tests, so if you wish
you can skip them with `mix test --exclude ipfs`

# Research, Background & Relevant Reading
+ Real World examples of services that use Strings as IDs instead of Integers. [Real World Examples](https://github.com/dwyl/cid/blob/master/read_world_examples.md)
+ (Please) Stop Using Unsafe Characters in URLs
https://perishablepress.com/stop-using-unsafe-characters-in-urls/
+ Safe characters for friendly URLs:
https://stackoverflow.com/questions/695438/safe-characters-for-friendly-url
+ When to use non-sequential Strings as IDs instead of Integers:
https://softwareengineering.stackexchange.com/questions/361395/when-use-a-long-string-id-instead-of-a-integer
+ Running out of numeric IDs in JavaScript!
https://asana.com/developers/news/string-ids
+ Clean URL: https://en.wikipedia.org/wiki/Clean_URL
+ URL Slugs: https://seo-hacker.com/url-seo-tutorial
+ Raft consensus: https://en.wikipedia.org/wiki/Raft_(computer_science)
+ What are the odds of collisions for a hash function with 256-bit output?
https://crypto.stackexchange.com/questions/39641/what-are-the-odds-of-collisions-for-a-hash-function-with-256-bit-output
+ Collision (computer science):
https://en.wikipedia.org/wiki/Collision_(computer_science)
+ Hash Collision Probabilities:
https://preshing.com/20110504/hash-collision-probabilities
+ UUID collisions:
https://softwareengineering.stackexchange.com/questions/130261/uuid-collisions

<br /> <hr /> <br />

# Notes

<sup>1</sup> The quality of being "typeable" _specifically_ on a mobile device,
means that a human being can type an ID in a _reasonable_ amount of time
(_e.g: fewer than 7 seconds_) and

<sup>2</sup> The list of Discontinued Google services continues to grow
https://en.wikipedia.org/wiki/Category:Discontinued_Google_services

<sup>3</sup> How to calculate collision probability in an ID system?

https://en.wikipedia.org/wiki/Universally_unique_identifier
![image](https://user-images.githubusercontent.com/194400/49408702-47949200-f755-11e8-9d25-bb31808ffc21.png)


<!--
```
# consider the following
iex> {:ok, buff} = "C56A4180-65AA-42EC-A945-5FD21DEC0538"
  |> String.replace("-", "")
  |> Base.decode16
iex> buff |> Base.encode64
# "xWpBgGWqQuypRV/SHewFOA==" (22 characters + 2 "=" signs as "padding")
```
-->

With a Base16 character set and **32 character** of ID length,

![base16-32-chars-probability](https://user-images.githubusercontent.com/194400/49407836-f2a34c80-f751-11e8-9d61-694c139808fc.png)

# FAQs

### How can we guarantee the the CID generated will be unique?

We will be using the SHA256 hash which _to date_ has not incurred a single
[hash collision](https://learncryptography.com/hash-functions/hash-collision-attack).
256 bits of data is used by _most_ crypto currencies. Enough "smart people" have
done the _homework_ on this for us not to worry about it.

This is a good video on **256 bit** hash collision probability:
[![image](https://user-images.githubusercontent.com/194400/49812120-9c8b6600-fd5c-11e8-9b1b-2c599d810f40.png)](https://youtu.be/S9JGmA5_unY)
https://youtu.be/S9JGmA5_unY

This video does not cover the "Birthday Paradox" see:
https://github.com/nelsonic/nelsonic.github.io/issues/576. But again, for the
purposes of this answer and indeed any project we are likely to work on in our
_lifetime_, when dealing with 256 bit hashes, the chance of a "birthday attack"
creating a collision is "_ignorable_".

### If all unique content creates a unique CID, how do we update content in our database?

The update version of content would be linked to the _previous_ version using a
**`prev`** field the way it happens in IPFS, Etherium and Bitcoin (_so it will
be **familiar** to people_)

**`prev: previous_cid`** address _example_:

| `inserted ` | **`cid`**(PK)<sup>1</sup> | **`name`** | **`address`**                                                                                                                                                                                                  | **`prev`**         |
| ----------- | ------------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| 1541609554  | **gVSTedHFGBetxy**        | Bruce Wane | 1007 Mountain Drive, Gotham                                                                                                                                                                                    | null               |
| 1541618643  | smnELuCmEaX42             | Bruce Wane | [Rua Goncalo Afonso, Vila Madalena, Sao Paulo, 05436-100, Brazil](https://www.tripadvisor.co.uk/ShowUserReviews-g303631-d2349935-r341872180-Batman_Alley-Sao_Paulo_State_of_Sao_Paulo.html "Batman Alley ;-)") | **gVSTedHFGBetxy** |

When a row does _not_ have a **`prev`** value then we know it is the _first_
time that content has been inserted into the database. When a **`prev`** value
is defined in a row we know this is a new _version_ of a previously inserted
content and we can "traverse the tree" to see all previous versions.
