# `rid`

**`rid`** ("resource id") is a human-friendly (readable/typeable<sup>1</sup>)
unique ID function built for use with distributed/decentralised apps.




# Why?

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
_first-hand_
Yes, there are services like
[CloudFlare](https://www.cloudflare.com/ddos)
or
[Imperva](https://www.incapsula.com/ddos-protection-services.html)
which promise to _mitigate_ against DDoS
the _reality_ is that they are only providing "frontend" protection.


# Who?

If you are building apps that will use a _single_ database instance
for whatever reason (_e.g: they aren't very "complex"
or don't need to be distributed or work offline-first_)
keep enjoying the simplicity and maybe come back to this
later when you feel you _need_ this functionality.

We feel that _most_ apps can benefit
from being decentralised/distributed by default
because it means they work "offline" when any element fails
and data can easily be "synched" when connection is re-established.

Network and hardware ***fault-tolerance*** is a ***essential***
for many apps and enables a whole _new_ "class" of apps to be created.

Specifically applications that are "federated".
see: https://en.wikipedia.org/wiki/Federated_architecture




In a distributed database, we need a way of creating IDs
for the records without any risk of "collision".

There are _many_ ways of creating unique IDs.

Consider the following

location-app.com/venues/123e4567-e89b-12d3-a456-426655440000

append-only log.



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rid` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rid, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rid](https://hexdocs.pm/rid).


# Research, Background & Relevant Reading

+ (Please) Stop Using Unsafe Characters in URLs
https://perishablepress.com/stop-using-unsafe-characters-in-urls/
+ Safe characters for friendly URLs:
https://stackoverflow.com/questions/695438/safe-characters-for-friendly-url
+ Raft consensus: https://en.wikipedia.org/wiki/Raft_(computer_science)

<br />

## Instagram's (_Apparently_) Random String IDs

From the start Instagram got _several_ things "right" in
both their iOS App, their backend App/API design and infrastructure choices.
We will be producing a _separate_ "case study" on Instragram
in the _near_ future, meanwhile let's focus on one thing: the post IDs.

The **_first_ image** posted on Instagram (16th July 2010)
was taken by
[Kevin Systrom](https://en.wikipedia.org/wiki/Kevin_Systrom)
it features a dog in Mexico near a taco stand,
with a guest appearance by his girlfriend’s foot:
https://www.instagram.com/p/C/
![first-instagram-post](https://user-images.githubusercontent.com/194400/49203797-7e5b5880-f3a1-11e8-9c7c-c85ee9622994.png)

> In many ways this image is _representative_ of the social network as a whole,
it uses the "**X-PRO2**" filter and is _insignificant_ to _most_
of the **99,704 people** who "**liked**" it, unless these almost 100K people
are general "dog-lovers" who "like" _all/any_ dogs ... 💭


Notice how the URL of this image is `/p/C/`? <br />
The `/p/` part refers to the
"posts controller" in the
(_[Django](https://quora.com/What-programming-languages-are-used-at-Instagram)
-based_) Web App. <br />
The `/C/` is the the `ID` of the post.
[Mike Krieger](https://firstround.com/review/how-instagram-co-founder-mike-krieger-took-its-engineering-org-from-0-to-300-people)
chose to use a **`String`** for the Post IDs
(_rather than an_ `Auto-incrementing Integer`)
for a _three_ simple reasons:  <br />
1. Strings can be shorter than Ints because the
2. Strings **_obscure_ how many posts** have been made on the network
(_whereas an **Int** would make it
  **immediately obvious** how **popular** the network was!_)
3. Strings make it more difficult to **guess** the ID of the next post
"scrape" the site's content.

Sure enough, the **_second_ post** on Instagram is:
https://www.instagram.com/p/D/
![tacos](https://user-images.githubusercontent.com/194400/49208839-c6ce4280-f3b0-11e8-9c45-eb10f0c424f9.png)
**24,402 likes** ... seems legit.
everyone is entitled to their own "taste" in what content to "like".

If we keep going through the alphabet we soon discover that ID `F`
does not exist:
https://www.instagram.com/p/F/
![instagram-F-does-not-exist](https://user-images.githubusercontent.com/194400/49223657-3fe09080-f3d7-11e8-9616-8d1f4edfe56b.png)

This could either be because it was never assigned
(_the system skipped this ID_) or because it was deleted.


By December of 2010 Instagram was claiming to have **1 Million Users**:
https://www.instagram.com/p/pLY-/
![image](https://user-images.githubusercontent.com/194400/49203915-e873fd80-f3a1-11e8-83de-5fbc3b0ef002.png)
> And while we have no reason to _doubt_ their claim,
there is an _obvious_ incentive for any venture-backed startup to
[overstate metrics](https://venturebeat.com/2016/09/23/facebook-apologizes-for-error-in-overstating-video-views/)
in order to _fuel_ adoption and secure more funding.<br />
It's certainly _interesting_ that a photo of a random Taco stand
gets [**24k**](https://youtu.be/UqyT8IEBkvY) "likes"
but the _milestone_ announcement
that there are now 1 Million Users on the app
gets only **390**;
you would think people in the early insta-community would have been more
excited about this ...? Anyway, back to the IDs!

At the point where they passed 1 Million Users,
the post IDs where **4 characters** in length: **`pLY-`**
This means there was an "address space" big enough for almost 19M photos
(_see below_) an average of 19 posts per user.

This **`pLY-`** post ID gives us quite a lot more information.
**`pLY-`** indicates that the IDs are both `UPPERCASE` and `lowercase`
letters of the alphabet (`ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`)
and URL-safe characters; in this case a _hyphen_.

A more recent post on Instagram has an ID of **`BqHTJ9WHptI`**
(_11 characters_):
https://www.instagram.com/p/BqHTJ9WHptI
![instagram-record-id](https://user-images.githubusercontent.com/194400/49209240-e023be80-f3b1-11e8-9282-5e1c4a80e1bd.png)

The **`BqHTJ9WHptI`** post ID tells us
that they are also using _Numeric_ characters
(`0123456789`).

So we know they are using a URL-safe human-readable character set
which _almost_ matches **Base64**:

https://en.wikipedia.org/wiki/Base64#Base64_table <br />

![base64-character-set](https://user-images.githubusercontent.com/194400/49223407-9bf6e500-f3d6-11e8-8241-84fdc924c64d.png)

The key distinction between the Instagram ID charset and Base64,
is that Base64 allows the _forward slash_ (`/`) character
which is a reserved character in URLs.
Which makes us think that Instagram's UIs are more along the lines of
[RFC 3986](https://www.ietf.org/rfc/rfc3986.txt):
```sh
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-~.
```
**66 characters**.

With a 66 character set and 4 char ID length
there are **66^4** = **18,974,736** IDs.

With an ID length of 11 (_as is the case in the most recent insta posts_),
the potential number of posts is **66^11** = **103,510,234,140,112,521,216** ...
**103 _Quintillion_**.
Enough for _each_ of the Earth's 7.5 Billion people
to post **14 Billion images**.

It appears that Instagram have inflated their ID length in order to
achieve objectives 2 and 3 (_described above_),
they don't want anyone to know how much
activity there _really_ is on the network.




# Notes

<sup>1</sup> The quality of being "typeable"
