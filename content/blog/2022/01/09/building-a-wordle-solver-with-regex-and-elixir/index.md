---
title: "Building a Wordle Solver With Regular Expressions and Elixir"
date: 2022-01-09T16:46:21-08:00
draft: false
tags: [elixir,wordle]
categories: [programming]
---

![Wordle](cover.jpg)

This is one of these articles that is predestined to start with "unless you've been living under a rock, you have heard of ...". Unfortunately I don't know how popular the thing I'm gonna write about is outside my bubble but here we go.

Among my group of friends and colleagues the online game [wordle](https://www.powerlanguage.co.uk/wordle/) has been hugely popular. It's a mix of [Scrabble](https://en.wikipedia.org/wiki/Scrabble) and [Mastermind](https://en.wikipedia.org/wiki/Mastermind_(board_game)) where you'll have to guess a five letter word. Hints about individual characters are conveyed to you via yellow, green and gray indicators. Green means the target word has this character at this location, yellow means the target word has this character but in a different location and gray means the character is not in the target word at all.

It's a lot of fun and I'm looking forward to a new word every day. But after failing one of the words (it was "banal" on Thursday Jan 6), I thought to myself: "I could write a solver for this". I decided to not look up any solver algorithms that would help me out and instead started with some thinking it through and using the knowledge I already had.

## First Step Throw Some Regular Expressions at a Dictionary

My first instinct is, the algorithm can't be that hard. All I need is a big enough dictionary file and iteratively apply filters until only one word is left. In my search for an appropriate list of words I came across [Scrabble dictionary](https://raw.githubusercontent.com/jesstess/Scrabble/master/scrabble/sowpods.txt), which the developer of the game most likely uses.

Using that as a starting point the the algorithm is pretty simple.

1. Turn the feedback of a wordle step into a formal filter criterion
2. Filter on all words specified by that filter criterion
3. Pick one word from the remaining list as the next word
4. Continue with step 1

Run this until the feedback gives you 5 green letters.

So I started with a rather naive approach: **Regular Expressions and some shell command**. Turns out, if you know a little bit about `grep` and pipes you can do it.

Let's walk through it together using the riddle from Jan 5:

Using `WATER` as the first guess will yield the following result:

![Wordle Water gray gray yellow green green](wordle_guess_01.png)

We get all three feedbacks, there are letters that are are in the target word at the right position (green), ones that are in the target word but in the wrong position (yellow) and ones that are not in the target word at all (gray).

So how can we filter a list of word to only include words that match those criteria.

The easiest one does not oven include regular expressions. Only find words without `W` and `A`. We can utilize [grep's](https://linux.die.net/man/1/grep) `--invert-match` or `-v` flag. If you pipe all the absent letters together your output will look like this:


```shell
cat sowpods.txt | grep -v 'W' | grep -v 'A'
```

That narrows it down quite a bit but we can do better. We could do a regular grep on `T`, `E` and `R` but that doesn't go far enough because we have additional information about these letters. We know that `E` and `R` need to be at a specific position and we know that `T` needs to be on a different position.

We can achieve both of these patterns with a regular expression. For the correct positional match you specify a regular expression like this: `^...ER$` meaning the word must end in `ER` and there must be 3 letters in front of it.

The non-positional match is a little harder to do so I split it up in two matches. The first one is easy because we know that that the letter `T` has to be in the word, so a simple `grep 'T'` will work. But we can filter it even more. Similar to the positional matching regular expression, we can express that a certain positions shouldn't match utilizing the caret character: `^..[^T]..$`.

Stitching this all together our filter looks like this:

```shell
grep -E '^....$' sowpods.txt | grep -v 'W' | grep -v 'A' | grep 'T' \
| grep -E '^..[^T]..$' \ | grep -E '^...ER$' | shuf -n 1
```

This chain of commands will filter all words first to all five letter words (notice the regex in the first grep) to the possible ones and then randomly picks one utilizing the [shuf](https://linux.die.net/man/1/shuf) command.

The result in this case was `OTHER`, repeating this pattern will yield `TUNER` then `TIMER` and finally the solution `TIGER`

![Wordle Water gray gray yellow green green](wordle_guess_02.png)

The whole line looks like this:

```shell
grep -E '^.....$' sowpods.txt | grep -v 'W' | grep -v 'A' \
| grep -E '^...ER$' | grep 'T' | grep -E '^..[^T]..$' \
| grep -v 'O' | grep -v 'H' | grep -E '^.[^T]...$' \
| grep -v 'U' | grep -v 'N' | grep -E '^T....$' \
| grep -v 'M' | grep -E '^.I...$'
```

This command will output two possible words: `TIGER` and `TILER` so it could have lasted one round longer, not to mention that the intermediate terms were luck as well. But it could have solved it quicker (by getting `TIMER`, at the second or third try).

This then gave me the idea of trying to optimize so that it converges to a solution quicker. But I was tired of copy and pasting regular expressions around and I wanted to automate this a little bit.

## Second Step: Wrap your Regular Expressions in Some Code

My initial goal was to find out how many attempts a solver would take to solve the daily riddle and as a side quest find a good starting word.

So I implemented a [wordle solver](https://github.com/leifg/wordle_solver) in Elixir. I pretty much applied these techniques I described before with "some" adjustments (turns out, repeating letters ruin everything ...).

This way I could put in arbitrary start and target words and count the attempts the solver would find. With randomizing the next guess I already got pretty far but this is where I started ranking the words.

## Last Step: Prioritize by Letter Distribution

My thought here was as follows: start with words that include common letters but also have 5 different letters. The rational being if you eliminate common letters early you filter down the list much quicker. And using as many different characters has the potential to reveal more information quicker.

The solvers pre sorts the word list in the following way:

1. Figure out which letters are the most commonly used ones by tallying up the letters of all words (for 5 letter words in this list it's `E`, `S` and `A`)
2. For each word determine how many different letters it has (first sort criterion)
3. Sum up the occurrences for every letter of the word (second sort criterion)

If you're curious the 3 words with the highest ranks are: `SOARE`, `AROSE` and `AEROS` (all anagrams of each other).

This works pretty well but still has a decent amount of words that won't be found within 6 guesses, especially words with repeating letters are still a challenge (to find `BOOKS` from `SOARE` is still 8 guesses).

I wrote a script that will let you input any word of the list and then write down the number of guesses necessary to find every other word. Afterwords it will print out what percentage of target words are found in more than 6 guesses. Unfortunately I could only run it for 80 words so far because the runtime of the script is insane (finding these 80 words took my laptop around 8 hours).

So far `IMPEL` seems to be a great start word.

{{< chart >}}
type: 'bar',
data: {
  labels: ['IMPEL', 'REDIP', 'ANTIC', 'BIRCH', 'IMAGO'],
  datasets: [{
    label: '# % of words that need more than 6 guesses',
    data: [9.9695, 11.2117, 11.2358, 11.388, 11.4201],
  }]
}
{{< /chart >}}

This is pretty much where I am at now. My idea is to run every word as an input against every other word (12000^2 runs) but my most optimistic estimate of the runtime of this with my laptop would be 30 days. One obvious optimization would be to reduce the initial list (if you look at the wordle page source you can see that the wordle website is choosing words from a 2000 list subset of the Scrabble word list) but I consider that cheating :wink:.

## Conclusion

If you read this and immediately thought "you should have used the ${algorithm} you are probably right. I'd be shocked if this is the most elegant solution that anyone could come up with. But I chose to not do any research and get my hands dirty as quickly as possible because this is what gives me the most joy. I can only recommend using these kind of solving problems as your side project.

Ultimately I will probably do some digging into Mastermind solving and english word ranking algorithms but not before I optimize the runtime so that running every word against every other word becomes feasible. Additionally I also want to implement a interactive mode so you can actually use it to solve the daily wordle puzzle instead of just running it against existing words and finding out how many attempts it would have taken.

*Attribution: [Scrabble](https://pixabay.com/photos/scrabble-website-marketing-server-2129648/) by [Daniel Schmieder](https://pixabay.com/users/bavarian_web_solutions-4173887)*
