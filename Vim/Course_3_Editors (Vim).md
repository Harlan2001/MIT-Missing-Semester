1. Complete vimtutor. Note: it looks best in a 80x24 (80 columns by 24 lines) terminal window.


2. Download our basic vimrc and save it to ~/.vimrc. Read through the well-commented file (using Vim!), and observe how Vim looks and behaves slightly differently with the new config.

3. Install and configure a plugin: ctrlp.vim.
```
 let g:ctrlp_map ='<c-p>' 
 let g:ctrlp_cmd = 'CtrlP'
 let g:ctrlp_working_path_mode = 'ra' # Set the default path to the current path
 ```

4. To practice using Vim, re-do the Demo from lecture on your own machine.


5. Use Vim for all your text editing for the next month. Whenever something seems inefficient, or when you think “there must be a better way”, try Googling it, there probably is. If you get stuck, come to office hours or send us an email.


6. Configure your other tools to use Vim bindings (see instructions above).


7. Further customize your ~/.vimrc and install more plugins.


8. (Advanced) Convert XML to JSON (example file) using Vim macros. Try to do this on your own, but you can look at the macros section above if you get stuck.

Gdd, ggdd deletes the first and last rows

Macro to format the last element (register e)

Jump to line with <name> qe^r"f>s": "<ESC>f<C"<ESC>q

Format a person's macro

Jump to the line with <person> qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q

A macro that formats one person and then goes to another

Jump to the line with <person> qq@pjq

Execute macro to the end of file 999@q

Manually remove the last, then add the [and] delimiters
