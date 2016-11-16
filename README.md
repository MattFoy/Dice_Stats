# Dice_Stats
A ruby gem for handling dice related statistics.

##Usage

###Instantiating and rolling:

```ruby
$ irb -r dice_stats --simple-prompt
>> ds = Dice_Stats::Dice_Set.new("1d6 + 3 + 2d8")

>> # clean_string returns the input pattern, sorted by dice face in descending order
>> ds.clean_string
=> "2d8 + 1d6 + 3"

>> # roll simulates a roll of the specified dice
>> ds.roll
=> 13

>> ds.roll
=> 17

>> ds.roll
=> 11
```

###Simple statistics:
Basic statistical information about the set of dice can also be returned through class methods.

```ruby
>> ds.expected
=> 15.5

>> ds1.variance
=> 13.4166666667

>> ds1.standard_deviation
=> 3.6628768298

>> ds1.min
=> 6

>> ds1.max
=> 25
```

###Advanced statistics:

More advanced queries can be performed on the dice set. Results are returned as BigDecimals. 
For readability, these examples will round and change them to floats.
Queries are conducted with the p method, clauses are cumulative (all implicitly joined with "AND")

```ruby
>> # p(x = 12)
>> ds1.p.eq(12).get.round(8).to_f
=> 0.0703125

>> # p(15 < x < 20)
>> ds1.p.gt(15).lt(20).get.round(8).to_f
=> 0.35416667

>> # p(x > 15)
>> ds1.p.gt(15).get.round(8).to_f
=> 0.5

>> # p(x <= 15)
>> ds1.p.lte(15).get.round(8).to_f
=> 0.5

>> # p(12 <= x <= 19)
>> ds1.p.gte(12).lte(19).get.round(8).to_f
=> 0.70833333

>> # p(12 < x < 19)
>> ds1.p.gt(12).lt(19).get.round(8).to_f
=> 0.56770833

>> # p(x != 25,24,6,7) i.e. not the two highest or two lowest results
>> ds1.p.ne(25).ne(24).ne(6).ne(7).get.round(8).to_f
=> 0.97916667
```


## How it works:

Each single type of dice is broken out separately at first, so in the case of "2d6 + 3d8" first "2d6" and "3d8" are each considered.

The probability distribution for any number of a single type of dice can be calculated by using a generating function.
Wolfram has an excellent article explaining this here: [http://mathworld.wolfram.com/Dice.html]
The key equation is on line (10).

The next step is to determine the combined probability distribution. This is a little trickier, but is done by taking the Cartesian product of the probability distributions of the separate dice types. The real challenge is taking the Cartesian product of an unknown number of sets, for example maybe it is just the two "d8"s and "d6"s, but it could also be many more, ie. "2d20 + 2d12 + 2d10 + 2d8 + 2d6 + 2d4". This means some nested loops are out of the question. I solve this by creating a counter that ticks up for each possible combination. It may not be the most elegant solution, but it works nicely.


## Why:

I wanted to learn Ruby; this is my "Hello World!". 

I've created a similar program before in C#, so I was already familiar with the core concepts.


## Todo:

1. Create a Rails app that wraps this gem for ease of use and visualization. Also to learn Rails!
2. Add "Or" groupings for queries
3. See if the n-ary cartesian product process can be simplified.