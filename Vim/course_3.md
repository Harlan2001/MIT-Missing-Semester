1. Complete vimtutor. Note: it looks best in a 80x24 (80 columns by 24 lines) terminal window.
2. Download our basic vimrc and save it to ~/.vimrc. Read through the well-commented file (using Vim!), and observe how Vim looks and behaves slightly differently with the new config.
3. Install and configure a plugin: ctrlp.vim.
Create the plugins directory with mkdir -p ~/.vim/pack/vendor/start

Download the plugin: cd ~/.vim/pack/vendor/start; git clone https://github.com/ctrlpvim/ctrlp.vim

Read the documentation for the plugin. Try using CtrlP to locate a file by navigating to a project directory, opening Vim, and using the Vim command-line to start :CtrlP.

Customize CtrlP by adding configuration to your ~/.vimrc to open CtrlP by pressing Ctrl-P.

4. To practice using Vim, re-do the Demo from lecture on your own machine.
5. Use Vim for all your text editing for the next month. Whenever something seems inefficient, or when you think “there must be a better way”, try Googling it, there probably is. If you get stuck, come to office hours or send us an email.
6. Configure your other tools to use Vim bindings (see instructions above).
7. Further customize your ~/.vimrc and install more plugins.
8. (Advanced) Convert XML to JSON (example file) using Vim macros. Try to do this on your own, but you can look at the macros section above if you get stuck.
