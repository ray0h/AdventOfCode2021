# Learnings from going through AOC with Python
## My general approach was to solve the day's problem using Ruby and then refactoring the algorithm/approach using Python.  

**General / refreshers**
- Python files have `.py` extension. 
- Need to include "hashbang" at top of file `#! \usr\bin\python3` pointing to location of python interpreter.
- Python is dynamically typed and relies more on indentations (no semicolons or end statements?)
- "arrays" are referred to as "lists" in python.
- functions, conditionals, loops are followed by a colon(:) at the end of the line.  
- `print()` to output values

**Day 1**
- Reading from files

  ``` 
  with open(<path name>) as f:
    lines = f.readlines()
  ```
  `with` also takes care of closing the file.

- for loop 
  
  for iterating over values:
  `for i in range(length):` 

- mapping over list (array)

  `map()` function takes a function and list as arguments and returns an iterable object.  This can be transformed using `list()`:

  ```
  def strip(str):
    return int(str.rstrip())
  
  arr = list(map(strip, lines))
  ```

  `int()` transforms str digit to integer.
  `rstrip()` removes newlines and whitespace (can specify)

**Day 2**
- Conditionals
  ```
  if <conditional>:
    <statement 1>
  elif <conditional2>:
    <statement 2>
  else:
    <statement 3>
  ```

- for loops (list)

  `for line in data:`

**Day 3**

Python has ALOT of libraries.  
Looking into reduce:

``` 
from operator import add
from functools import reduce

add(1,3) # => 4
reduce(<reducer function>, list)
```

*some list methods*
- `append()`

  JS and Ruby use `push()` to add elements to end of array.  Python uses `append()` to add elements to end of list.

- `count()`, `reverse()`

  sames as in JS or Ruby; but `reverse` runs in place.

- `copy()`

  clones a list

- `filter()`

  `filter(function, list` returns iterable object (can be transformed with `list()`)
  Learned about lambda functions:
  `lambda x: fn(x)` that are invoked immediately?

- mapping alternative

  `[<function(x)> for x in <list>]`

**Day4**
- `set`
  creates a `set` from a list.

  can then see if a set is a subset of another
  `set(a) <= set(b)` # set a a subset of set b

  difference of two sets
  `set(a) - set(b)`

  *List Comprehension methods*

- `pop()`
  list method to remove element from list.  include an index to specify which element to remove.  

- slice type method:
  `<Array>[i:j]` i = index starting, j = index ending

**Day5**

- Dictionaries (hashes/objects)

  syntax: `{<key>:<value>}`
  
  {} , can pull `.keys()`, `.values()` as lists.  can `.copy()` to clone.

**Day8**

alot of list methods can be used on strings.
```
string = "hello"
len(string) # => 5
string[3] # => "l"
string.index('e') # => 1
```

`.join()` method to join together a list of characters:
`"".join(['h', 'e', 'l', 'l', 'o']) # => "hello"`

`.split(<parameter>)` can be used to create a list split by parameter (e.g. " ", ",")
`list(string)` can also be used to create a list of individual characters.
watch out with variable names (str renders `str()` useless)...

**Day9**

more list methods
`.sort()` to sort list; can add `reverse=True` as parameter to reverse the sort.

`if <conditional>: <result>` for oneline statements

ternary statement:
`<result> if <conditional> else <result2>`

list slicing:
`arr[ind, no of elements]` returns a subset of list.

**Day10**