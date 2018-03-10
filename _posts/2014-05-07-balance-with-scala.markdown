---
layout: post
title: "Balance with Scala"
date: 2014-05-08
preview: about the pleasure of learning a great new language
---

Scala is a pleasant and powerful language. Here's a simple exercise demonstrating functional programming by checking whether a string has balanced parentheses or no.

    def balanced(chars: List[Char]): Boolean = {
      def innerBalance(thisChar: Char, rest: List[Char], center: Int): Int = {
        def shift(thisChar: String, center: Int): Int = {
          if      (thisChar == "(") center << 1
          else if (thisChar == ")") center >> 1
          else center
        }
        if (rest.isEmpty) shift(thisChar.toString, center)
        else innerBalance(rest.head, rest.tail, shift(thisChar.toString, center))
      }
      innerBalance(chars.head, chars.tail, 1) == 1
    }

very pleasant indeed!
