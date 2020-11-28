# Ruby Spellchecker

Fast ruby spelling and grammar checker that can be used for autocorrection. Used by [SiteInspector](http://github.com/siteinspector/siteinspector).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-spellchecker'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby-spellchecker

## Usage

### Get list of errors

```ruby
Spellchecker.check(text)
```

### Autocorrection

```ruby
text = <<~TEXT
  I started my schooling as the majority did in my area, at the local
  primarry school. I then went to the local secondarry school and
  recieved grades in English, Maths, Phisics, Biology, Geography,
  Art, Graphical Comunication and Philosophy of Religeon. I'll not
  bore you with the 'A' levels and above.

  Notice the ambigous English qualification above. It was, in truth,
  a cource dedicated to reading "Lord of the flies" and other gems,
  and a weak atempt at getting us to commprehend them. Luckilly my
  middle-class upbringing gave me a head start as I was was already
  aquainted with that sort of langauge these books used (and not just
  the Peter and Jane books) and had read simillar books before. I will
  never be able to put that paticular course down as much as I desire
  to because, for all its faults, it introduced me to Steinbeck,
  Malkovich and the wonders of Lenny, mice and pockets.

  My education never included one iota of grammar. Lynn Truss points
  out in "Eats, shoots and leaves" that many people were excused from
  the rigours of learning English grammar during their schooling over
  the last 30 or so years because the majority or decision-makers
  decided one day that it might hinder imagination and expresion (so
  what, I ask, happened to all those expresive and imaginative people
  before the ruling?).
TEXT

corrected = Spellchecker.correct(text)
```

Wdiff:

```ruby
require 'wdiff'

Wdiff.diff(text, corrected)

```

Result:

```diff
I started my schooling as the majority did in my area, at the local
[-primarry-] {+primary+} school. I then went to the local [-secondarry-] {+secondary+} school and
[-recieved-] {+received+} grades in English, Maths, [-Phisics,-] {+Physics,+} Biology, Geography,
Art, Graphical Comunication and Philosophy of [-Religeon.-] {+Religion.+} I'll not
bore you with the 'A' levels and above.

Notice the [-ambigous-] {+ambiguous+} English qualification above. It was, in truth,
a [-cource-] {+course+} dedicated to reading "Lord of the flies" and other gems,
and a weak [-atempt-] {+attempt+} at getting us to [-commprehend-] {+comprehend+} them. [-Luckilly-] {+Luckily+} my
middle-class upbringing gave me a head start as I was [-was-] already
[-aquainted-] {+acquainted+} with that sort of [-langauge-] {+language+} these books used (and not just
the Peter and Jane books) and had read [-simillar-] {+similar+} books before. I will
never be able to put that [-paticular-] {+particular+} course down as much as I desire
to because, for all its faults, it introduced me to Steinbeck,
Malkovich and the wonders of Lenny, mice and pockets.

My education never included one iota of grammar. Lynn Truss points
out in "Eats, shoots and leaves" that many people were excused from
the rigours of learning English grammar during their schooling over
the last 30 or so years because the majority or decision-makers
decided one day that it might hinder imagination and [-expresion-] {+expression+} (so
what, I ask, happened to all those [-expresive-] {+expressive+} and imaginative people
before the ruling?).
```
