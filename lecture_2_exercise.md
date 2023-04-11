1.Read man ls and write an ls command that lists files in the following manner
Includes all files, including hidden files
Sizes are listed in human readable format (e.g. 454M instead of 454279954)
Files are ordered by recency
Output is colorized
A sample output would look like this
```
 -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
 drwxr-xr-x   5 user group  160 Jan 14 09:53 .
 -rw-r--r--   1 user group  514 Jan 14 06:42 bar
 -rw-r--r--   1 user group 106M Jan 13 12:12 foo
 drwx------+ 47 user group 1.5K Jan 12 18:08 ..
 ```
 ```shell
 ls -a
 ls -h
 ls -t
 ls --color=auto
 ```
2.Write bash functions marco and polo that do the following. Whenever you execute marco the current working directory should be saved in some manner, then when you execute polo, no matter what directory you are in, polo should cd you back to the directory where you executed marco. For ease of debugging you can write the code in a file marco.sh and (re)load the definitions to your shell by executing source marco.sh.

 solution is:
 ```shell
 #!/bin/bash
 marco(){
     echo "$(pwd)" > $HOME/marco_history.log
     echo "save pwd $(pwd)"
 }
 polo(){
     cd "$(cat "$HOME/marco_history.log")"
 }
```

3.Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. Bonus points if you can also report how many runs it took for the script to fail.
```
 #!/usr/bin/env bash

 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
 fi

 echo "Everything went according to plan"
 ```
solution is:
```shell
 #!/usr/bin/env bash

 n=$(( RANDOM % 100 ))

 if [[ n -eq 42 ]]; then
     echo "Something went wrong"
     >&2 echo "The error was using magic numbers"
     exit 1
 fi

 echo "Everything went according to plan"
```
This is done using a while loop
```shell
 count=1

 while true
 do
     ./buggy.sh &>> out.log
     if [[ $? -ne 0 ]]; then
         cat out.log
         echo "failed after $count times"
         break
     fi
     ((count++))

 done
```
This is done using the for loop
```shell
 for ((count=1;;count++))
 do
     ./buggy.sh &>> out.log
     if [[ $? -ne 0 ]]; then
         cat out.log
         echo "failed after $count times"
         break

     echo "$count try"
     fi
 done
```
Use until to complete
```shell
 #!/usr/bin/env bash
 count=0
 until [[ "$?" -ne 0 ]];
 do
     count=$((count+1))
     ./random.sh &>> out.txt
 done

 cat out.txt
 echo "found error after $count runs"
```
4.As we covered in the lecture find’s -exec can be very powerful for performing operations over the files we are searching for. However, what if we want to do something with all the files, like creating a zip file? As you have seen so far commands will take input from both arguments and STDIN. When piping commands, we are connecting STDOUT to STDIN, but some commands like tar take inputs from arguments. To bridge this disconnect there’s the xargs command which will execute a command using STDIN as arguments. For example ls | xargs rm will delete the files in the current directory.

Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check -d flag for xargs).

If you’re on macOS, note that the default BSD find is different from the one included in GNU coreutils. You can use -print0 on find and the -0 flag on xargs. As a macOS user, you should be aware that command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by using brew.

Start by creating the required files
```shell
  mkdir html_root
  cd html_root
  touch {1..10}.html
  mkdir html
  cd html
  touch xxxx.html
  ├── html_root
  │   ├── 1.html
  │   ├── 10.html
  │   ├── 2.html
  │   ├── 3.html
  │   ├── 4.html
  │   ├── 5.html
  │   ├── 6.html
  │   ├── 7.html
  │   ├── 8.html
  │   ├── 9.html
  │   └── html
  │       └── xxxx.html
  ```
Run the find command
```shell
  #for MacOS
  find html_root -name "*.html" -print0 | xargs -0 tar vcf html.zip
  #for Linux
  find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf html.zip
  a html_root/9.html
  a html_root/5.html
  a html_root/4.html
  a html_root/8.html
  a html_root/3.html
  a html_root/html/xxxx.html
  a html_root/2.html
  a html_root/1.html
  a html_root/10.html
  a html_root/7.html
  a html_root/6.html
```
5.(Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?
```shell
find . -type f -mmin -60 -print0 | xargs -0 ls -lt | head -10
```
