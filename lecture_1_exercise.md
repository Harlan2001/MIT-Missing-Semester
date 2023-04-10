2.Create a new directory called missing under /tmp.
```shell
mkdir tmp  # I don't have tmp folder in my virtural machine, so i just make one
cd tmp
mkdir missing
```

3.Look up the touch program. The man program is your friend.
```shell
man touch
```

4.Use touch to create a new file called semester in missing.
```shell
touch semester
```

5.Write the following into that file, one line at a time:

!/bin/sh

curl --head --silent https://missing.csail.mit.edu

The first line might be tricky to get working. It’s helpful to know that # starts a comment in Bash, and ! has a special meaning even within double-quoted (") strings. Bash treats single-quoted strings (') differently: they will do the trick in this case. See the Bash quoting manual page for more information.

```shell
ehco '#!/bin/sh' > semester
echo curl --head --silent https://missing.csail.mit.edu >> semester 
# here is >>, use > will just overwrite the file
cat semester
```

which return 

```
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

6.Try to execute the file, i.e. type the path to the script (./semester) into your shell and press enter. Understand why it doesn’t work by consulting the output of ls (hint: look at the permission 
bits of the file).

```shell
./semester
```

and it says:

```
#bash: ./semester: 权限不够
```

then we print

```shell
ls -l
```

which says:

```
总用量 4
drwxrwxr-x. 2 harlan harlan  6 4月  10 19:52 missing
-rw-rw-r--. 1 harlan harlan 61 4月  10 20:07 semester
```

7.Look up the chmod program (e.g. use man chmod).

```shell
man chmod
```

8.Use chmod to make it possible to run the command ./semester rather than having to type sh semester. How does your shell know that the file is supposed to be interpreted using sh? See this page on the shebang line for more information.
```shell
chmod 777 semester
ls -l
```
and return:
```
总用量 4
drwxrwxr-x. 2 harlan harlan  6 4月  10 19:52 missing
-rwxrwxrwx. 1 harlan harlan 61 4月  10 20:07 semester
```

9.Use | and > to write the “last modified” date output by semester into a file called last-modified.txt in your home directory.
```shell
./semester | grep last-modified > ~/last-modified.txt
```

10.Write a command that reads out your laptop battery’s power level or your desktop machine’s CPU temperature from /sys. Note: if you’re a macOS user, your OS doesn’t have sysfs, so you can skip this exercise.

here is a problem, I use cent os 7, and no such file in my virtual machine, sorry
