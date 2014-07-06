---
layout: post
title: instructions for 'unless' or 'if not'
date: 2012-11-13 00:00:00
categories: Ruby
preview: a dynamic language syntax does not imply dynamic compilation (obvious in hindsight)
---

Reading Pat Shaughnessy's recent book, *Ruby Under a Microscope* (which I strongly recommend), I've become interested in using experiment 1.3 to examine the structure of my code. Basically, Shaughnessy explains how to print Ruby's YARV instruction sequence to the command line for any given snippet of code. The technique is very easy, and once you've oriented yourself to Ruby's internal instruction commands (eg. YARV instructions), you'll find the exercise extremely illuminating.

Here's the 'experiment' I ran to settle a pet-peeve: comparing the YARV instructions for 

    a = "not true"
    return false unless a == "true"

and

    a = "not true"
    return false if ! a == "true"

which code has the smaller instruction set?

I admit the experiment is highly contrived. The local variable assignment, the return statement, and the string comparison are identical. The only difference between the code snippets is the use of "unless" in place of "if !". This contrivance is intentional, since the pet-peeve I want to "put under the microscope" - to use Shaughnessy's phrase - is the alternate use of "unless" in place of "if !".

Open an *irb* session in the latest *Ruby 1.9.3*, and save the two snippets as strings code1 and code2.

    $ irb
    1.9.3p327 :001 > code1 =<<STR
    1.9.3p327 :002"> a = 'not true'
    1.9.3p327 :003"> false unless a == 'true'
    1.9.3p327 :004"> STR
     => "a = 'not true'\n false unless a == 'true'\n"
    1.9.3p327 :005 > code2 =<<STR
    1.9.3p327 :006"> a = 'not true'
    1.9.3p327 :007"> false if ! a == 'true'
    1.9.3p327 :008"> STR
     => "a = 'not true'\n false if ! a == 'true'\n"

Now, make your bets. Having an anti-*unless*, I believed code1 would contain a larger instruction set than code2.

    1.9.3p327 :009 > RubyVM::InstructionSequence.compile(code1).disasm
    == disasm: <RubyVM::InstructionSequence:<compiled>@<compiled>>==========
    local table (size: 2, argc: 0 [opts: 0, rest: -1, post: 0, block: -1] s1)
    [ 2] a          
    0000 trace            1                                               (   1)
    0002 putstring        "true"
    0004 setlocal         a
    0006 trace            1                                               (   2)
    0008 getlocal         a
    0010 putstring        "true"
    0012 opt_eq           <ic:1>
    0014 branchunless     19
    0016 putnil           
    0017 leave            
    0018 pop              
    0019 putobject        false
    0021 leave            
     => nil 

That's the unless statement. Now for the "if !" statement.

    1.9.3p327 :010 > RubyVM::InstructionSequence.compile(code2).disasm
    == disasm: <RubyVM::InstructionSequence:<compiled>@<compiled>>==========
    local table (size: 2, argc: 0 [opts: 0, rest: -1, post: 0, block: -1] s1)
    [ 2] a          
    0000 trace            1                                               (   1)
    0002 putstring        "true"
    0004 setlocal         a
    0006 trace            1                                               (   2)
    0008 getlocal         a
    0010 opt_not          <ic:2>
    0012 putstring        "trueerrrfg
    0014 opt_eq           <ic:3>
    0016 branchunless     22
    0018 putobject        false
    0020 leave            
    0021 pop              
    0022 putnil           
    0023 leave            
     => nil 
    [p;9
The stack for code2 ('if !') is two units more than the stack for code1 ('unless')! The extra instructions can be accounted for by "opt_not", which is an optimized instruction called in response to the bang ("!") token.

Interestingly, the last four instructions appear in a different order. code1 places nil on the stack before leaving the conditional, then places false. code2 places false on the stack first, then places nil. This means that, in the case where the conditional fails to obtain, code1 defaults to false and code2 defaults to nil.

    1.9.3p327 :011 > a = 'not true'
    1.9.3p327 :012 > puts false unless a == "true"
    false
     => nil
    1.9.3p327 :013 > puts false if ! a == "true"
     => nil

In other words, you're *guaranteed* a return when you use *unless*. Which you knew before, but now you know why.
