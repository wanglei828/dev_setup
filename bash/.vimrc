" it highlights extraneaous whitespace and tabs (so you can easily remove
" them), sets column length to a max of 78 characters, expands tabs, and sets
" a tab width of 4 spaces.

" *NOTE 1* this doesn't guarantee that your code with fit the style guidelines,
" so you should still to double check everything, but it helps with a lot of
" tedious stuff.

" *NOTE 2* if you do actually NEED to use a tab, e.g., in a Makefile, enter
" insert mode and type ctrl-v first, which will make tabs behave as expected

filetype indent on "auto indenting
set tabstop=4 "tabs = 4 spaces
set shiftwidth=4 "auto indent = 4 spaces
set expandtab "expand tabs to spaces
set tw=78 "max cols is 78

" highlight extrawhite space with light blue background
highlight ExtraWhitespace ctermbg=lightblue guibg=lightblue
match ExtraWhitespace /\s\+$\|\t/

" stuff to prevent the light blue highlighting from showing up at the end of
" lines when you're in insert mode. i.e., everytime you enter a space as you're
" entering text the highlighting will kick in, which can be annoying. this will
" make the highlighting only show up if you finish editing and leave some extra
" whitespace
autocmd BufWinEnter * match ExtraWhitespace /\s\+$\|\t/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$\|\t\%#\@<!/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\|\t/
autocmd BufWinLeave * call clearmatches()


" optionally set a vertical line on column 79. anything on, or after the line
" is over the limit. this can be useful as set tw=78 won't breakup existing
" lines that are over the limit, and the user can also do certain things to
" make lines go past the set textwidth, e.g., joining a line (shift-j or J)

"if exists('+colorcolumn')
"    set colorcolumn=79
"endif


" optionally set spell checking
"set spell

" optionally highlight whitespace with specified characters. tab for trailing
" tabs, trail for trailing whitespace, extends for lines that extend beyond
" screen when wrap is off, and non-breakable white spaces. list must be set
" for these characters to display.
"set list
"set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
