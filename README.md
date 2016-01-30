NIN-VI-MODE
=======

This plugin increases `vi-like` zsh functionality.Press `ESC` to enter normal mode.

Navigating History
-------

- `/`      : Search backward in history
- `n`      : Repeat the last `/`

Mode indicators
---------------

Use a theme that defines normal mode indication for `bindkey -v`.


Vim edition: for when things get hairy
-----------

If things get real complex, you can always edit the current command line in Vim using `K` in normal mode.


Movements
--------

- `$`   : To the end of the line
- `^`   : To the first non-blank character of the line
- `0`   : To the first character of the line
- `w`   : [count] words forward
- `W`   : [count] WORDS forward
- `e`   : Forward to the end of word [count] inclusive
- `E`   : Forward to the end of WORD [count] inclusive
- `b`   : [count] words backward
- `B`   : [count] WORDS backward
- `t{char}`   : Till before [count]'th occurrence of {char} to the right
- `T{char}`   : Till before [count]'th occurrence of {char} to the left
- `f{char}`   : To [count]'th occurrence of {char} to the right
- `F{char}`   : To [count]'th occurrence of {char} to the left
- `;`   : Repeat latest f, t, F or T [count] times
- `,`   : Repeat latest f, t, F or T in opposite direction


Insertion
---------

- `i`   : Insert text before the cursor
- `I`   : Insert text before the first character in the line
- `a`   : Append text after the cursor
- `A`   : Append text at the end of the line
- `o`   : Insert new command line below the current one
- `O`   : Insert new command line above the current one


Delete and Insert
-----------------

- `d{motion}`   : Delete text that {motion} moves over
- `dd`          : Delete line
- `D`           : Delete characters under the cursor until the end of the line
- `c{motion}`   : Delete {motion} text and start insert
- `cc`          : Delete line and start insert
- `C`           : Delete to the end of the line and start insert
- `r{char}`     : Replace the character under the cursor with {char}
- `R`           : Enter replace mode: Each character replaces existing one
- `x`           : Delete [count] characters under and after the cursor
- `X`           : Delete [count] characters before the cursor

Credits
-------

Based on the `vi-mode` plugin that comes with [oh-my-zsh][1].


[1]: <https://github.com/robbyrussell/oh-my-zsh>
