## Real World Examples

There are _many_ Apps and Services that use Strings as IDs instead of Integers.

### Google URL Shortener

While the
[Google URL Shortener](https://en.wikipedia.org/wiki/Google_URL_Shortener)
https://goo.gl
has recently been discontinued<sup>2</sup>,
you are likely to continue seeing it's short links
around the web for the foreseeable future
and it still serves as an insightful case study.

The https://goo.gl service is a basic URL shortener
that allows people (_registered Google users_)
to paste links into an input field
and when the "SHORTEN URL" (_shouty_) button is clicked/tapped,
a much shorter URL is created:

![googl-url-shortner-form](https://user-images.githubusercontent.com/194400/49341817-b5a06280-f64a-11e8-9db2-db0e81661679.png)

e.g: https://goo.gl/nKXAdA

When Google announced they were shutting down the service (_for new links_),
I downloaded the CSV of the links I created for _one_ of my accounts:

![googl-url-shor-links](https://user-images.githubusercontent.com/194400/47958195-6ec53b80-dfbe-11e8-84d1-3269f6d2aba7.png)

Notice how the IDs are all **6 alphanumeric characters**?
The "character set" is:
```sh
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
```
I've never seen a goo.gl short URL with a special character. <br />
But since it's a closed-source product, there's no way of knowing for sure.

With a 63 character set, and an ID length of 6,
there are **63^6** = 62,523,502,209 **62.5 Billion IDs**. <br />
It was _unlikely_ Google was going to "run out" of IDs,
they must have decided to shut down the service
because it was being used for "SPAM" and "PHISHING" ...
e.g: https://lifehacker.com/5708311/new-virus-watch-out-for-googl-links-on-twitter

People with unethical motives is reason
[_why we can't have "nice things"_!](https://youtu.be/2oBPK_iqBZc)

#### Learning Point

If you have a simple Blog or Site with a few thousand links,
you can _easily_ use short URLs with **3 characters**.
**63^3** = 250,047 **250K IDs** is _enough_ for even a _popular_ blog!
and **63^4** = 15,752,961 **15.7 Million IDs**
is plenty for the first few years of a link sharing service!

We will be integrating this knowledge into our App.

<br /> <hr /> <br />

### Instagram's (_Apparently_) Random String IDs

From the start Instagram got _several_ things "right" in
both their iOS App, their backend App/API design and infrastructure choices.
We will be producing a _separate_ "case study" on Instragram
in the _near_ future, meanwhile let's focus on one thing: the post IDs.

The **_first_ image** posted on Instagram (16th July 2010)
was by
[Kevin Systrom](https://en.wikipedia.org/wiki/Kevin_Systrom).
It features a dog in Mexico near a taco stand,
with a guest appearance by his girlfriend’s foot wearing a flip-flop:
https://www.instagram.com/p/C/
![first-instagram-post](https://user-images.githubusercontent.com/194400/49203797-7e5b5880-f3a1-11e8-9c7c-c85ee9622994.png)

> In many ways this image is _representative_ of the social network as a whole,
it uses the "**X-PRO2**" filter and is _totally insignificant_ to _most_
of the **99,704 people** who "**liked**" it, unless these almost 100K people
are general "dog-lovers" who "like" _all/any_ dogs ... 💭


Notice how the URL of this image is `/p/C/`? <br />
The `/p/` part refers to the
"posts controller" in the
(_[Django](https://quora.com/What-programming-languages-are-used-at-Instagram)
-based_) Web App. <br />
The `C` is the the `ID` of the post. Yes, `String` is used for "ID"!
[Mike Krieger](https://firstround.com/review/how-instagram-co-founder-mike-krieger-took-its-engineering-org-from-0-to-300-people)
chose to use a **`String`** for the Post IDs
(_rather than an_ `Auto-incrementing Integer`)
for _three_ simple reasons:  <br />
1. Strings can be shorter than Ints because the character set is larger.
if the character set is just numeric digits `0123456789` then
the number of potential IDs or "posts" corresponds to the length of the ID.
There are only **9999** potential **IDs** if the ID length is 4 characters
(10^4 = 10k, subtract the 0000 ID which would never be used
  in an auto-incrementing database that starts at 1)
2. Strings **_obscure_ how many posts** have been made on the network
(_whereas an **Int** would make it
  **immediately obvious** how **popular** the network was!_)
3. Strings make it more difficult to **guess** the ID of the next post
"scrape" the site's content. This is also _good_ for privacy again because
nobody can _guess_ a _private_ Post's ID.

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
is that Base64 allows the _forward slash_ (`/`) and _plus_ (`+`) characters
which are both reserved characters in URLs.
Which makes us think that Instagram's IDs are more along the lines of
[RFC 3986](https://www.ietf.org/rfc/rfc3986.txt):
```sh
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-~.
```
**66 characters**.

With a 66 character set and 4 charter ID length
there are **66^4** = **18,974,736** IDs.

With an ID length of **11**
(_as is the case in the most recent insta posts_), <br />
the _potential_ number of IDs is **66^11** = **103,510,234,140,112,521,216** ...
**103 _Quintillion_**. <br />
Enough for _each_ of the Earth's 7.5 Billion people
to post **14 Billion images**.

It appears that Instagram have ~~inflated~~ raised their ID length in order to
achieve objectives 2 and 3 (_described above_),
they don't want anyone to know how much
activity there _really_ is on the network.

Instagram are using a distributed system for creating their post IDs.

<br /> <hr /> <br />

### YouTube

Youtube is another example of this. Let's look at a few of the URLS for videos
hosted on the site.

https://www.youtube.com/watch?v=fYyDQBG_tYc <br />
https://www.youtube.com/watch?v=jNQXAC9IVRw <br />
https://www.youtube.com/watch?v=g5eGKw4TWbU

Notice all the ids are 11 alphanumeric characters. The character set appears to
be the same set as the one used by the Google URL shortener
```
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
```

YouTube is a site with **1.9 billion users**. There is no way of knowing for
sure but it is estimated that there are somewhere between **5-7 billion videos**
currently on the site and that number is continuously growing as over **300
hours of video** is uploaded to the site **every minute**.

This number of videos is almost hard to wrap your head around and you might
think that they would have to change their IDs at some point to reflect the
number of videos on the site. Well, let's have a look at that.

With a character set of 63 and ID length of 11 there are **63^11** =
**62,050,608,388,552,824,880** IDs possible. **62 _Quintillion_**. To try and
give this number some context, there are more possilbe IDs than the estimated
number of grains of sand on earth. Close to **9 times more!!!**

We can safely say that YouTube will not be running out of video IDs anytime
soon.

YouTube, unlike Instagram, has implemented this system since the first upload to
the site. In fact one of the 3 links above is the first ever YouTube video and
the other 2 are from late 2018. As you can see, there is no way to tell the
difference without actually clicking the link.

This shows that YouTube was planning for scale from day one. It's also why there
is no way of telling just how many videos are on YouTube.
