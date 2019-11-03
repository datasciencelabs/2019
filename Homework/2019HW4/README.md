---
title: 'Homework 4: Monte Carlo Simulations'
output: html_document
---
### Due: November 10, 2019 by 11:59pm

In this homework you will practice coding different Monte Carlo simulations. We use the example of [baseball](https://en.wikipedia.org/wiki/Baseball) here, but you do not need to know any specifics about the game - just that the [Red Sox](https://www.mlb.com/redsox) and [Astros](https://www.mlb.com/astros) are two US baseball teams. 

Assume the baseball playoffs are about to start. During the first round of the playoffs, teams play a best of a five game series. After the first round, they play a seven game series.

### Question 1

The Red Sox and Astros are playing a five game series. Assume the teams are equally good. This means each game is like a coin toss. Build a Monte Carlo simulation to determine the probability that the Red Sox win the series. (Hint: start by creating a function `series_outcome` similar to the `roulette` function from lecture and lab.)

```{r}
# Your code here
```

### Question 2

The answer to Question 1 is not surprising. What if one of the teams is better? Compute the probability that the Red Sox win the series if the Astros are better and have a 60% chance of winning each game.

```{r}
# Your code here
```

Your answer here.

### Question 3

How does this probability change if instead of five games, they play seven? How about three? What law did you learn in lecture that explains this?

```{r}
# Your code here
```

Your answer here.

### Question 4

Now, assume again that the two teams are equally good. What is the probability that the Red Sox still win the series if they lose the first game? Do this for a five game and seven game series.

```{r}
# Your code here
```

Your answer here.
