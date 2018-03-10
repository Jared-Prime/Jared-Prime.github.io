---
layout: post
title: "What is grep?"
date: 2012-11-06 00:00:00
preview: a greenhorn's introduction to the grep program
---

The Unix program "grep" stands for "global regular expression print." As its expanded name implies, the program prints to the terminal all regular expression matches for a given string.

I've already complicated this simple yet powerful tool; so let's try an example. Say you've opened a folder in your terminal with the command "$ cd ~/Documents/Work". If you'd like to quickly search for a particular file - say a report containing the section title "Third Quarter Results", you can use grep.

    $ grep "Third Quarter Results" *.docx

"grep" calls the program, "Third Quarter Results" enters the plaintext string to search for, and *.docx tells grep to search all files (*) with the .docx file extension. Thus the basic patter for "grepping" is

    $ grep [search terms...] [file...]

Very easy. It's likely easy enough for a novice to learn grep within the first few minutes of opening up a terminal. But the purpose of the 1UP challenge is to push skills _beyond_ the basics, and to discover techniques that unleash the full power of even the simplest tools.

Consider the complete usage description for grep, which you can see on your machine by simply running grep without any arguments.

    $ grep
    usage: grep [-abcDEFGHhIiJLlmnOoPqRSsUVvwxZ] [-A num] [-B num] [-C[num]]
    [-e pattern] [-f file] [--binary-files=value] [--color=when]
    [--context[=num]] [--directories=action] [--label] [--line-buffered]
    [--null] [pattern] [file ...]

(NOTE: I'm writing this article on a machine running OSX 10.8. Linux users might find slightly different options depending on their distribution. Windows users are out of luck.)

This can get interesting.
