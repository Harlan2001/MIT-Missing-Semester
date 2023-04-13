1.Take this short interactive regex tutorial.


2.Find the number of words (in /usr/share/dict/words) that contain at least three as and don’t have a 's ending. What are the three most common last two letters of those words? sed’s y command, or the tr program, may help you with case insensitivity. How many of those two-letter combinations are there? And for a challenge: which combinations do not occur?

For the number of words

```shell
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^([^a]*a){3}.*$" | grep -v "'s$" | wc -l
#854
```

For the number of conbination
```shell
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^([^a]*a){3}.*$" | grep -v "'s$" | sed -E "s/.*([a-z]{2})$/\1/" | sort | uniq -c | sort | tail -n3
```

which combination has not occured?

First, we generate a list of all combination:

```shell
#!/bin/bash
for i in {a..z};do
 for j in {a..z};do
    echo  "$i$j"
 done
done
```

then

```shell
./all.sh > all.txt
```

now we compare:

```shell
cat /usr/share/dict/words | tr "[:upper:]" "[:lower:]" | grep -E "^([^a]*a){3}.*$" | grep -v "'s$" | sed -E "s/.*([a-z]{2})$/\1/" | sort | uniq > occurance.txt
```

```shell
diff --unchanged-group-format='' <(cat occurance.txt) <(cat all.txt) | wc -l
```


3.To do in-place substitution it is quite tempting to do something like sed s/REGEX/SUBSTITUTION/ input.txt > input.txt. However this is a bad idea, why? Is this particular to sed? Use man sed to find out how to accomplish this.

```shell
sed -i.bak s/REGEX/SUBSTITUTION/ input.txt
```

4.Find your average, median, and max system boot time over the last ten boots. Use journalctl on Linux and log show on macOS, and look for log timestamps near the beginning and end of each boot. On Linux, they may look something like:

```
Logs begin at ...
```
and
```
systemd[577]: Startup finished in ...
```
On macOS, look for:
```
=== system boot:
```
and
```
Previous shutdown cause: 5
```

### solution 

To perform this exercise, we need to first allow journalctl to log multiple powerups

```shell
vim /etc/systemd/journald.conf
```

Set Storage=persistent Run the preceding command and restart

Use the systemd-analyze tool to see where the startup time is spent:

```shell
sudo systemd-analyze plot > systemd.svg
```

Next, write the script getlog.sh to get the data for the last ten startup times:

```shell
#!/bin/bash
for i in {0..9}; do
   journalctl -b-$i | grep "Startup finished in"
done
```

```shell
./getlog > starttime.txt
```

```shell
# Get maximum time
cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/"| sort | tail -n1
Get minimum time
cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/"| sort -r | tail -n1
# Average
cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/"| paste -sd+ | bc -l | awk '{print $1/10}'
# Median
cat starttime.txt | grep "systemd\[1\]" | sed -E "s/.*=\ (.*)s\.$/\1/"| sort |paste -sd\  | awk '{print ($5+$6)/2}'
```

5.Look for boot messages that are not shared between your past three reboots (see journalctl’s -b flag). Break this task down into multiple steps. First, find a way to get just the logs from the past three boots. There may be an applicable flag on the tool you use to extract the boot logs, or you can use sed '0,/STRING/d' to remove all lines previous to one that matches STRING. Next, remove any parts of the line that always varies (like the timestamp). Then, de-duplicate the input lines and keep a count of each one (uniq is your friend). And finally, eliminate any line whose count is 3 (since it was shared among all the boots).

Simply modify getlog.sh to get the last three logs and run the following command:
```shell
cat last3start.txt | sed -E "s/.*pi\ (.*)/\1/" | sort | uniq -c | sort | awk '$1!=3  { print }'
```

6.Find an online data set like this one, this one, or maybe one from here. Fetch it using curl and extract out just two columns of numerical data. If you’re fetching HTML data, pup might be helpful. For JSON data, try jq. Find the min and max of one column in a single command, and the difference of the sum of each column in another.


