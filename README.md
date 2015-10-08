my-perl-scripts

===============
contains all perl scripts!!!!!!

http://www.tutorialspoint.com/perl/perl_coding_standard.htm

Each programmer will, of course, have his or her own preferences in regards to formatting, but there are some general guidelines that will make your programs easier to read, understand, and maintain.

The most important thing is to run your programs under the -w flag at all times. You may turn it off explicitly for particular portions of code via the no warnings pragma or the $^W variable if you must. You should also always run under use strict or know the reason why not. The use sigtrap and even use diagnostics pragmas may also prove useful.

Regarding aesthetics of code lay out, about the only thing Larry cares strongly about is that the closing curly bracket of a multi-line BLOCK should line up with the keyword that started the construct. Beyond that, he has other preferences that aren't so strong:

    4-column indent.

    Opening curly on same line as keyword, if possible, otherwise line up.

    Space before the opening curly of a multi-line BLOCK.

    One-line BLOCK may be put on one line, including curlies.

    No space before the semicolon.

    Semicolon omitted in "short" one-line BLOCK.

    Space around most operators.

    Space around a "complex" subscript (inside brackets).

    Blank lines between chunks that do different things.

    Uncuddled elses.

    No space between function name and its opening parenthesis.

    Space after each comma.

    Long lines broken after an operator (except and and or).

    Space after last parenthesis matching on current line.

    Line up corresponding items vertically.

    Omit redundant punctuation as long as clarity doesn't suffer.


Personal:
    1. Best to wrap all variables as object variables in Class programming
