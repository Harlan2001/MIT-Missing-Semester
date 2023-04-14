## Exercises

### Debugging
1.Use journalctl on Linux or log show on macOS to get the super user accesses and commands in the last day. If there aren’t any you can execute some harmless commands such as sudo ls and check again.

```shell
journalctl | grep sudo
#4月 14 14:06:34 harlan-virtual-machine sudo[2167]:   harlan : TTY=pts/0 ; PWD=/home/harlan/桌面 ; USER=root ; COMMAND=/usr/bin/ls
#4月 14 14:06:34 harlan-virtual-machine sudo[2167]: pam_unix(sudo:session): session opened for user root(uid=0) by (uid=1000)
#4月 14 14:06:34 harlan-virtual-machine sudo[2167]: pam_unix(sudo:session): session closed for user root
```

2.Do this hands on pdb tutorial to familiarize yourself with the commands. For a more in depth tutorial read this.

3.Install shellcheck and try checking the following script. What is wrong with the code? Fix it. Install a linter plugin in your editor so you can get your warnings automatically.

```shell
#!/bin/sh
## Example: a typical script with several problems
for f in $(ls *.m3u)
do
  grep -qi hq.*mp3 $f \
    && echo -e 'Playlist $f contains a HQ file in mp3 format'
done
```

### solution
```shell
vim wrongcheck.sh
```

and paste the contend into it

```shell
shellcheck wrongcheck.sh
```

and it says

```
In wrongcheck.sh line 3:
for f in $(ls *.m3u)
         ^---------^ SC2045 (error): Iterating over ls output is fragile. Use globs.
              ^-- SC2035 (info): Use ./*glob* or -- *glob* so names with dashes won't become options.


In wrongcheck.sh line 5:
  grep -qi hq.*mp3 $f \
           ^-----^ SC2062 (warning): Quote the grep pattern so the shell won't interpret it.
                   ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: 
  grep -qi hq.*mp3 "$f" \


In wrongcheck.sh line 6:
    && echo -e 'Playlist $f contains a HQ file in mp3 format'
            ^-- SC3037 (warning): In POSIX sh, echo flags are undefined.
               ^-- SC2016 (info): Expressions don't expand in single quotes, use double quotes for that.
```

4.(Advanced) Read about reversible debugging and get a simple example working using rr or RevPDB.


###Profiling

5.Here are some sorting algorithm implementations. Use cProfile and line_profiler to compare the runtime of insertion sort and quicksort. What is the bottleneck of each algorithm? Use then memory_profiler to check the memory consumption, why is insertion sort better? Check now the inplace version of quicksort. Challenge: Use perf to look at the cycle counts and cache hits and misses of each algorithm.

here is the sorts.py
```python
import random


def test_sorted(fn, iters=1000):
    for i in range(iters):
        l = [random.randint(0, 100) for i in range(0, random.randint(0, 50))]
        assert fn(l) == sorted(l)
        # print(fn.__name__, fn(l))


def insertionsort(array):

    for i in range(len(array)):
        j = i-1
        v = array[i]
        while j >= 0 and v < array[j]:
            array[j+1] = array[j]
            j -= 1
        array[j+1] = v
    return array


def quicksort(array):
    if len(array) <= 1:
        return array
    pivot = array[0]
    left = [i for i in array[1:] if i < pivot]
    right = [i for i in array[1:] if i >= pivot]
    return quicksort(left) + [pivot] + quicksort(right)


def quicksort_inplace(array, low=0, high=None):
    if len(array) <= 1:
        return array
    if high is None:
        high = len(array)-1
    if low >= high:
        return array

    pivot = array[high]
    j = low-1
    for i in range(low, high):
        if array[i] <= pivot:
            j += 1
            array[i], array[j] = array[j], array[i]
    array[high], array[j+1] = array[j+1], array[high]
    quicksort_inplace(array, low, j)
    quicksort_inplace(array, j+2, high)
    return array


if __name__ == '__main__':
    for fn in [quicksort, quicksort_inplace, insertionsort]:
        test_sorted(fn)
```

then we run in shell
```shell
python -m cProfile -s time sorts.py | grep sorts.py
```

and it returns

```
     1000    0.052    0.000    0.052    0.000 sorts.py:11(insertionsort)
33558/1000    0.048    0.000    0.051    0.000 sorts.py:32(quicksort_inplace)
33532/1000    0.045    0.000    0.071    0.000 sorts.py:23(quicksort)
     3000    0.025    0.000    0.241    0.000 sorts.py:6(<listcomp>)
    16266    0.012    0.000    0.012    0.000 sorts.py:28(<listcomp>)
    16266    0.011    0.000    0.011    0.000 sorts.py:27(<listcomp>)
        3    0.007    0.002    0.437    0.146 sorts.py:4(test_sorted)
        1    0.000    0.000    0.439    0.439 sorts.py:1(<module>)
```

Add the decorator @profile for the function you want to parse and execute

```shell
kernprof -l -v sorts.py
```

First, the analysis of quicksort:

```
 Wrote profile results to sorts.py.lprof
 Timer unit: 1e-06 s

 Total time: 0.490021 s
 File: sorts.py
 Function: quicksort at line 22

 Line #      Hits         Time  Per Hit   % Time  Line Contents
 ==============================================================
     22                                           @profile
     23                                           def quicksort(array):
     24     32594      91770.0      2.8     18.7      if len(array) <= 1:
     25     16797      36674.0      2.2      7.5          return array
     26     15797      37626.0      2.4      7.7      pivot = array[0]
     27     15797     125796.0      8.0     25.7      left = [i for i in array[1:] if i < pivot]
     28     15797     119954.0      7.6     24.5      right = [i for i in array[1:] if i >= pivot]
     29     15797      78201.0      5.0     16.0      return quicksort(left) + [pivot] + quicksort(right)
```

Then the insertion sort is analyzed:

```
 Total time: 1.33387 s
 File: sorts.py
 Function: insertionsort at line 11

 Line #      Hits         Time  Per Hit   % Time  Line Contents
 ==============================================================
     11                                           @profile
     12                                           def insertionsort(array):
     13
     14     26801      44242.0      1.7      3.3      for i in range(len(array)):
     15     25801      43372.0      1.7      3.3          j = i-1
     16     25801      41950.0      1.6      3.1          v = array[i]
     17    234763     434280.0      1.8     32.6          while j >= 0 and v < array[j]:
     18    208962     380062.0      1.8     28.5              array[j+1] = array[j]
     19    208962     343217.0      1.6     25.7              j -= 1
     20     25801      45248.0      1.8      3.4          array[j+1] = v
     21      1000       1503.0      1.5      0.1      return array
```

Insertion sort takes a little more time.The bottleneck for quicksort is left and right assignments, while the bottleneck for insertion sort is in the while loop.
Use memory_profiler for analysis

Let's start by looking at the memory usage of quicksort:

```
python -m memory_profiler sorts.py

 Filename: sorts.py

 Line #    Mem usage    Increment  Occurences   Line Contents
 ============================================================
     22   20.199 MiB   20.199 MiB       32800   @profile
     23                                         def quicksort(array):
     24   20.199 MiB    0.000 MiB       32800       if len(array) <= 1:
     25   20.199 MiB    0.000 MiB       16900           return array
     26   20.199 MiB    0.000 MiB       15900       pivot = array[0]
     27   20.199 MiB    0.000 MiB      152906       left = [i for i in array[1:] if i < pivot]
     28   20.199 MiB    0.000 MiB      152906       right = [i for i in array[1:] if i >= pivot]
     29   20.199 MiB    0.000 MiB       15900       return quicksort(left) + [pivot] + quicksort(right)
```

Analyze memory usage for insertion sort:

```
python -m memory_profiler sorts.py

 Filename: sorts.py

 Line #    Mem usage    Increment  Occurences   Line Contents
 ============================================================
     11   20.234 MiB   20.234 MiB        1000   @profile
     12                                         def insertionsort(array):
     13
     14   20.234 MiB    0.000 MiB       26638       for i in range(len(array)):
     15   20.234 MiB    0.000 MiB       25638           j = i-1
     16   20.234 MiB    0.000 MiB       25638           v = array[i]
     17   20.234 MiB    0.000 MiB      237880           while j >= 0 and v < array[j]:
     18   20.234 MiB    0.000 MiB      212242               array[j+1] = array[j]
     19   20.234 MiB    0.000 MiB      212242               j -= 1
     20   20.234 MiB    0.000 MiB       25638           array[j+1] = v
     21   20.234 MiB    0.000 MiB        1000       return array
```

Meanwhile, compare the memory of the quicksort algorithm operated in situ:

```
python -m memory_profiler sorts.py

 Filename: sorts.py

 Line #    Mem usage    Increment  Occurences   Line Contents
 ============================================================
     31   20.121 MiB   20.121 MiB       33528   @profile
     32                                         def quicksort_inplace(array, low=0, high=None):
     33   20.121 MiB    0.000 MiB       33528       if len(array) <= 1:
     34   20.121 MiB    0.000 MiB          42           return array
     35   20.121 MiB    0.000 MiB       33486       if high is None:
     36   20.121 MiB    0.000 MiB         958           high = len(array)-1
     37   20.121 MiB    0.000 MiB       33486       if low >= high:
     38   20.121 MiB    0.000 MiB       17222           return array
     39
     40   20.121 MiB    0.000 MiB       16264       pivot = array[high]
     41   20.121 MiB    0.000 MiB       16264       j = low-1
     42   20.121 MiB    0.000 MiB      124456       for i in range(low, high):
     43   20.121 MiB    0.000 MiB      108192           if array[i] <= pivot:
     44   20.121 MiB    0.000 MiB       55938               j += 1
     45   20.121 MiB    0.000 MiB       55938               array[i], array[j] = array[j], array[i]
     46   20.121 MiB    0.000 MiB       16264       array[high], array[j+1] = array[j+1], array[high]
     47   20.121 MiB    0.000 MiB       16264       quicksort_inplace(array, low, j)
     48   20.121 MiB    0.000 MiB       16264       quicksort_inplace(array, j+2, high)
     49   20.121 MiB    0.000 MiB       16264       return array
```

As you can see, insertion sort is slightly more memory efficient than quicksort, because quicksort requires some extra space to hold the result, whereas insertion sort operates in place

6.Here’s some (arguably convoluted) Python code for computing Fibonacci numbers using a function for each number.

```
#!/usr/bin/env python
def fib0(): return 0

def fib1(): return 1

s = """def fib{}(): return fib{}() + fib{}()"""

if __name__ == '__main__':

    for n in range(2, 10):
        exec(s.format(n, n-1, n-2))
    # from functools import lru_cache
    # for n in range(10):
    #     exec("fib{} = lru_cache(1)(fib{})".format(n, n))
    print(eval("fib9()"))
```
Put the code into a file and make it executable. Install prerequisites: pycallgraph and graphviz. (If you can run dot, you already have GraphViz.) Run the code as is with pycallgraph graphviz -- ./fib.py and check the pycallgraph.png file. How many times is fib0 called?. We can do better than that by memoizing the functions. Uncomment the commented lines and regenerate the images. How many times are we calling each fibN function now?

7.A common issue is that a port you want to listen on is already taken by another process. Let’s learn how to discover that process pid. First execute python -m http.server 4444 to start a minimal web server listening on port 4444. On a separate terminal run lsof | grep LISTEN to print all listening processes and ports. Find that process pid and terminate it by running kill <PID>.

8.Limiting processes resources can be another handy tool in your toolbox. Try running stress -c 3 and visualize the CPU consumption with htop. Now, execute taskset --cpu-list 0,2 stress -c 3 and visualize it. Is stress taking three CPUs? Why not? Read man taskset. Challenge: achieve the same using cgroups. Try limiting the memory consumption of stress -m.

9.(Advanced) The command curl ipinfo.io performs a HTTP request and fetches information about your public IP. Open Wireshark and try to sniff the request and reply packets that curl sent and received. (Hint: Use the http filter to just watch HTTP packets).
