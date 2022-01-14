---
title: "Play Wordle for a Different Day"
date: 2022-01-12T17:55:24-08:00
draft: false
tags: [javascript,wordle]
categories: [programming]
---

![header](cover.png)

**UPDATE 13 January 2022:** A previous version of the article did not include Google Chrome's Override instructions.

One element of writing my last [wordle article](/blog/2022/01/09/building-a-wordle-solver-with-regex-and-elixir) was creating screenshots to illustrate the solving algorithm. But I didn't want to use the word of that day (which was "gorge"), I wanted to use a specific word ("tiger" fom Jan 5).

This is where my digging into the workings behind wordle started. I was curious how the word of the day is chosen. I noticed that the new word is always available at midnight of "your" timezone so I suspected that all of the logic is implemented in the frontend (no secrets that are fetched from a server).

Formatting the minified frontend code drew my attention to this line:

```javascript
e.today = new Date; // <---- Seed for the solution (Today's date)
return Na(
      ...
      e.boardState = new Array(6).fill(""),
      e.evaluations = new Array(6).fill(null),
      e.solution = Da(e.today),  // <---- Setting the actual solution
      e.dayOffset = Ga(e.today),
      e.lastCompletedTs = o.lastCompletedTs,
      e.hardMode = o.hardMode,
      ....
```

So it seems like the solution is calculated as a modulo of the current date.

Not only does that provide an easy way to cheat (type `$("game-app").solution"` in your browser console if you really want to do that), it also shows a way on how to get a different solution word.

In theory, all you need to do is to set `#("game-app").solution` to something different. That's great if you want to create screenshots for a specific word, but if you actually want to play the solution for a different day you would somehow have to manipulate the value of `#("game-app").today` before it is actually used to calculate the target word.

The easiest solution I came up with is manipulating the source code because it is evaluated. So in order to get a different word you will need to get your hands dirty in the Developer Console in [Safari](https://support.apple.com/guide/safari/use-the-developer-tools-in-the-develop-menu-sfri20948/mac) or [Chrome](htt.ps://developer.chrome.com/docs/devtools/open/)

## 1. Reset the Current Game State

If you already played a game you need to remove the game state from the local storage:

### Safari

- Navigate to "Storage" in the Developer Console
- Select Local Storage
- Delete the entry for `gameState`

{{< figure src="setup_safari_light.png" class="inline dark:hidden" >}}

{{< figure src="setup_safari_dark.png" class="hidden dark:inline" >}}

### Chrome

- Navigate to "Application" in the Developer Console
- Select Local Storage under the wordle page (www.powerlanguage.co.uk)
- Delete the entry for `gameState`

{{< figure src="setup_chrome_light.png" class="inline dark:hidden" >}}

{{< figure src="setup_chrome_dark.png" class="hidden dark:inline" >}}

## 2. Create a Local Override for the Wordle JavaScript

[Safari](https://webkit.org/web-inspector/local-overrides/) and [Chrome](https://developer.chrome.com/blog/new-in-devtools-65/#overrides) provide a feature called Local Overrides which essentially lets you replace any request and response triggered by the current page you are on.

This feature can be used to change the input for the function that calculates the solution word:

### Safari

- Navigate to "Sources" in the Developer Console
- Scroll down to the `main.xxxxxxxx.js` entry and right click
- Click "Create Response Local Override"

{{< figure src="step_01_safari_light.png" class="inline dark:hidden" >}}

{{< figure src="step_01_safari_dark.png" class="hidden dark:inline" >}}

### Chrome

In Chrome you will actively need to create a local override.

To do that:

- Navigate to "Sources" in the Developer Console
- Select the "Overrides Tab" and select a folder to save your overrides
- Allow Chrome full access to the selected folder
- Enable local overrides

{{< figure src="step_01_chrome_light.png" class="inline dark:hidden" >}}

{{< figure src="step_01_chrome_dark.png" class="hidden dark:inline" >}}

## 3. Replace Code

Now you will see a full copy of the javascript source that you can freely edit.

### Safari

- Make sure the formatting is enabled (bracket symbol in the upper right corner)
- Scroll to the line where the solution is calculated (around line 1140)
- Change `today = new Date;` to `today = new Date("<Preferred Date>T00:00:00");`

{{< figure src="step_02_safari_light.png" class="inline dark:hidden" >}}

{{< figure src="step_02_safari_dark.png" class="hidden dark:inline" >}}

### Chrome

- Navigate to "Sources" in the Developer Console
- Open `main.xxxxxxxx.js` entry
- Go to the part that fetches the solution (Ctrl + F for `today=new Date` helps)
- Change `today = new Date;` to `today = new Date("<Preferred Date>T00:00:00");`

{{< figure src="step_02_chrome_light.png" class="inline dark:hidden" >}}

{{< figure src="step_02_chrome_dark.png" class="hidden dark:inline" >}}

Leave the console open and refresh. This should give you an alternative word you can solve.

## Conclusion

While changing the solution to a different word is trivial (`$("game-app").solution = "other"`), changing the solution to something unknown is much harder. I have not found a way around the overrides, it would be great to just chuck in some code into the console and get a new word. But I suppose part of the appeal of wordle is that you get a word a day so you'll have to pace yourself.


*Attribution: [Programming HTML CSS](https://pixabay.com/photos/programming-html-css-javascript-1873854/) by [Boskampi](https://pixabay.com/users/boskampi-3788146)*
