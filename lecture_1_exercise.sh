#Create a new directory called missing under /tmp.
cd tmp
mkdir missing

#Look up the touch program. The man program is your friend.

#Use touch to create a new file called semester in missing.

#Write the following into that file, one line at a time:
#!/bin/sh
#curl --head --silent https://missing.csail.mit.edu
#The first line might be tricky to get working. It’s helpful to know that # starts a comment in Bash, and ! has a special meaning even within double-quoted (") strings. Bash treats single-quoted strings (') differently: they will do the trick in this case. 
#See the Bash quoting manual page for more information.

#Try to execute the file, i.e. type the path to the script (./semester) into your shell and press enter. Understand why it doesn’t work by consulting the output of ls (hint: look at the permission bits of the file).

#Run the command by explicitly starting the sh interpreter, and giving it the file semester as the first argument, i.e. sh semester. Why does this work, while ./semester didn’t?

#Look up the chmod program (e.g. use man chmod).

#Use chmod to make it possible to run the command ./semester rather than having to type sh semester. How does your shell know that the file is supposed to be interpreted using sh? See this page on the shebang line for more information.

#Use | and > to write the “last modified” date output by semester into a file called last-modified.txt in your home directory.

#Write a command that reads out your laptop battery’s power level or your desktop machine’s CPU temperature from /sys. Note: if you’re a macOS user, your OS doesn’t have sysfs, so you can skip this exercise.
