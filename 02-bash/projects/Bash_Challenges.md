# Bash Scripting Challenges

This document covers four Bash scripting challenges I completed while developing my understanding of Bash.

The aim of these notes is not only to document the final scripts, but also to explain the Bash concepts behind them and some of the technical problems I encountered while building them.

---

# Challenge 1: Basic Arithmetic Calculator

## Requirements

Create a Bash script that:

- Takes two numbers as input
- Performs addition
- Performs subtraction
- Performs multiplication
- Performs division
- Handles division by zero

---

## Final Script

```bash
#!/bin/bash

read v1 v2

echo $(( v1 + v2 ))
echo $(( v1 - v2 ))
echo $(( v1 * v2 ))

if [[ "$v2" == 0 ]]; then
    echo "Not divisible by 0"
else
    echo $(( v1 / v2 ))
fi
```

---

## Understanding User Input

One of the first concepts I needed to understand was the difference between **positional parameters** and interactive user input.

Positional parameters such as:

```bash
$1
$2
```

contain arguments passed when the script is executed.

For example:

```bash
bash calculator.sh 10 5
```

would result in:

```text
$1 = 10
$2 = 5
```

However, this challenge required the values to be entered while the script was running.

For this, Bash provides the `read` command:

```bash
read v1 v2
```

If the user enters:

```text
10 5
```

Bash assigns:

```text
v1=10
v2=5
```

A useful distinction is:

```text
$1, $2     = arguments supplied when launching the script
read       = input collected while the script is running
```

---

## Performing Arithmetic in Bash

Bash provides **arithmetic expansion** using:

```bash
$(( expression ))
```

For example:

```bash
echo $(( v1 + v2 ))
```

Addition:

```bash
$(( v1 + v2 ))
```

Subtraction:

```bash
$(( v1 - v2 ))
```

Multiplication:

```bash
$(( v1 * v2 ))
```

Division:

```bash
$(( v1 / v2 ))
```

Bash performs integer arithmetic by default.

For example:

```text
5 / 2
```

returns:

```text
2
```

rather than `2.5`.

---

## Handling Division by Zero

A program should avoid attempting an invalid calculation rather than simply hiding the resulting error.

The divisor can be checked before performing division:

```bash
if [[ "$v2" == 0 ]]; then
    echo "Not divisible by 0"
else
    echo $(( v1 / v2 ))
fi
```

This means the division command only executes when `v2` is not zero.

This was an important lesson in error handling:

> Preventing an invalid command from running is better than allowing it to fail and suppressing the error afterwards.

---

## Key Takeaways

- `$1`, `$2`, etc. represent positional parameters.
- `read` collects interactive user input.
- `$(( ))` performs arithmetic expansion.
- Bash arithmetic uses integers by default.
- Conditional statements can prevent invalid operations from executing.

---

# Challenge 2: File Operations Script

## Requirements

Create a script that:

- Creates a directory called `bash_demo`
- Changes into the directory
- Creates `demo.txt`
- Writes text containing the current date into the file
- Displays the contents of the file

---

## Final Script

```bash
#!/bin/bash

mkdir bash_demo
cd bash_demo

touch demo.txt

echo "File created on $(date)" > demo.txt

cat demo.txt
```

---

## Creating and Entering a Directory

A directory can be created using:

```bash
mkdir bash_demo
```

The script can then move into it using:

```bash
cd bash_demo
```

This changes the script's **current working directory**.

Any relative paths used afterwards will be interpreted from this location.

---

## Creating a File

The `touch` command can be used to create an empty file:

```bash
touch demo.txt
```

This creates:

```text
demo.txt
```

inside the current directory.

---

## Command Substitution

The `date` command displays the current system date and time:

```bash
date
```

However, the challenge required the date to become part of another string.

Bash provides **command substitution**:

```bash
$(command)
```

The command inside `$()` executes first and its output is substituted into the surrounding command.

For example:

```bash
echo "File created on $(date)"
```

could produce:

```text
File created on Sun Oct 4 14:20:30 BST 2026
```

This technique becomes particularly useful when storing command output inside variables.

---

## Output Redirection

The following command writes the text into `demo.txt`:

```bash
echo "File created on $(date)" > demo.txt
```

The `>` operator redirects standard output into a file.

Conceptually:

```text
echo output
     |
     v
  demo.txt
```

Using:

```bash
>
```

will overwrite the existing contents of the destination file.

The redirection operator can also create a file if it does not already exist. This means `touch demo.txt` is technically unnecessary here. It was retained because explicitly creating the file was part of the challenge.

---

## Displaying File Contents

The contents can then be displayed using:

```bash
cat demo.txt
```

---

## Key Takeaways

- `mkdir` creates directories.
- `cd` changes the current working directory.
- `touch` creates an empty file.
- `$(command)` captures command output.
- `>` redirects output into a file.
- `cat` displays file contents.
- Changing directory affects how subsequent relative paths are interpreted.

---

# Challenge 3: File Checker with Permissions

## Requirements

Create a Bash script that:

- Prompts the user for a filename
- Checks whether the file exists
- Checks whether it is readable
- Checks whether it is writable
- Checks whether it is executable
- Displays the appropriate permission information

---

## Final Script

```bash
#!/bin/bash

filescript() {

    read filename

    if [[ -f "$filename" ]]; then

        echo "File $filename exists"

        if [[ -r "$filename" ]]; then
            echo "$filename is readable"
        fi

        if [[ -w "$filename" ]]; then
            echo "$filename is writable"
        fi

        if [[ -x "$filename" ]]; then
            echo "$filename is executable"
        fi

    else
        echo "File doesn't exist"
    fi
}

filescript
```

---

## Testing Whether a File Exists

Bash provides **file test operators** that can be used inside conditional expressions.

For example:

```bash
[[ -f "$filename" ]]
```

tests whether the supplied path exists and is a regular file.

The script therefore begins with:

```bash
if [[ -f "$filename" ]]; then
```

The permission checks are only performed if this condition succeeds.

---

## Independent vs Dependent Conditions

This challenge helped clarify an important difference between `elif` and separate `if` statements.

Consider:

```bash
if condition1; then
    ...
elif condition2; then
    ...
elif condition3; then
    ...
fi
```

Once one condition succeeds, Bash does not continue checking the remaining `elif` conditions.

That behaviour would be unsuitable for file permissions because a file can simultaneously be:

```text
Readable
Writable
Executable
```

The three permission tests therefore need to be **independent of each other**:

```bash
if [[ -r "$filename" ]]; then
    ...
fi

if [[ -w "$filename" ]]; then
    ...
fi

if [[ -x "$filename" ]]; then
    ...
fi
```

However, all three checks should only occur if the file exists.

They are therefore nested inside:

```bash
if [[ -f "$filename" ]]; then
```

The resulting logic is:

```text
Does the file exist?
        |
        +--- No ---> Display error
        |
       Yes
        |
        +--- Is it readable?
        |
        +--- Is it writable?
        |
        +--- Is it executable?
```

This allows the three permission tests to be independent of each other while still being dependent on the original file existence check.

---

## Useful File Test Operators

Bash provides several operators for checking filesystem objects:

| Operator | Meaning |
|---|---|
| `-e` | Path exists |
| `-f` | Path exists and is a regular file |
| `-d` | Path exists and is a directory |
| `-r` | Path is readable |
| `-w` | Path is writable |
| `-x` | Path is executable |
| `-s` | File exists and has a size greater than zero |
| `-L` | Path is a symbolic link |

These tests operate on the **specific path supplied**.

For example:

```bash
[[ -f "$filename" ]]
```

does not search the filesystem for the filename.

It checks whether the exact path represented by `$filename` is a regular file.

---

## Combining File Tests

File test operators cannot be concatenated like some command options.

For example:

```bash
[[ -rwx "$filename" ]]
```

is not the correct way to test all three permissions.

Instead, conditions can be combined explicitly:

```bash
[[ -r "$filename" && -w "$filename" && -x "$filename" ]]
```

Here:

```text
&&
```

means all conditions must succeed.

Alternatively:

```bash
[[ -r "$filename" || -w "$filename" || -x "$filename" ]]
```

uses:

```text
||
```

meaning at least one of the conditions must succeed.

For this challenge, separate `if` statements were more appropriate because each permission needed to be reported independently.

---

## Key Takeaways

- `-f` tests whether a specific path is a regular file.
- `-r` tests readability.
- `-w` tests writability.
- `-x` tests executability.
- `elif` is useful when only one branch should execute.
- Separate `if` statements are useful when every condition needs to be evaluated.
- Nested conditions allow several tests to depend on an initial condition.
- `&&` and `||` can combine conditional expressions.

---

# Challenge 4: Timestamped Backup Script

## Requirements

Create a Bash script that:

1. Prompts the user for a source directory
2. Creates a backup directory if it does not exist
3. Copies all `.txt` files into the backup directory
4. Adds a timestamp to the backup directory name
5. Displays the number of files backed up

---

## Final Script

```bash
#!/bin/bash

back_up() {

    echo "Please enter a directory"
    read directory

    if [[ -d "$directory" ]]; then

        timestamp=$(date +"%Y-%m-%d_%H-%M")

        backup_dir="Backup_${directory}_${timestamp}"

        mkdir "$backup_dir"

        echo "The directory has been backed up. Backup file name: $backup_dir"

        cd "$directory"

        cp *.txt "../$backup_dir"

        ls -l "../$backup_dir"

        file_count=$(ls "../$backup_dir" | wc -l)

        echo "Backup completed! Files backed up: $file_count"

    else

        echo "Couldn't back up directory. Please enter a directory into the field"

    fi
}

back_up
```

---

## Checking the Source Directory

Before attempting the backup, the script checks whether the supplied path is a directory:

```bash
if [[ -d "$directory" ]]; then
```

The `-d` operator evaluates as true when the path exists and is a directory.

This prevents the rest of the backup process from running against an invalid directory.

---

## Creating a Timestamp

The `date` command can produce formatted output using format specifiers.

The following command:

```bash
date +"%Y-%m-%d_%H-%M"
```

produces a timestamp such as:

```text
2026-10-05_16-27
```

The format specifiers used are:

| Format | Meaning |
|---|---|
| `%Y` | Four-digit year |
| `%m` | Month |
| `%d` | Day |
| `%H` | Hour |
| `%M` | Minute |

Command substitution allows this output to be stored inside a variable:

```bash
timestamp=$(date +"%Y-%m-%d_%H-%M")
```

---

## Debugging the `date` Command

One issue I encountered was writing:

```bash
date + "%Y-%m-%d_%H-%M"
```

This produced:

```text
date: extra operand '%Y-%m-%d_%H-%M'
```

The space meant that `+` and the formatting string were passed as separate arguments.

The correct syntax is:

```bash
date +"%Y-%m-%d_%H-%M"
```

Because the original command failed, `$timestamp` was empty and the backup directory was created without the expected timestamp.

This reinforced the importance of reading terminal error messages carefully. A very small syntax difference can completely change how a command is interpreted.

---

## Creating a Reusable Backup Name

Rather than repeatedly constructing the complete backup directory name throughout the script, I stored it in a variable:

```bash
backup_dir="Backup_${directory}_${timestamp}"
```

For example:

```text
directory = Arena
timestamp = 2026-10-05_16-27
```

results in:

```text
Backup_Arena_2026-10-05_16-27
```

The script can then simply use:

```bash
"$backup_dir"
```

wherever the backup path is needed.

For example:

```bash
mkdir "$backup_dir"
```

This improves maintainability because the naming convention only needs to be defined in one place.

If the naming convention changes later, I can modify:

```bash
backup_dir="Backup_${directory}_${timestamp}"
```

without editing every command that uses the directory.

---

## Why `${variable}` Is Useful

The braces in:

```bash
"${directory}"
```

make the boundaries of the variable name explicit.

This becomes particularly useful when variables are directly next to other characters.

For example:

```bash
backup_dir="Backup_${directory}_${timestamp}"
```

clearly separates:

```text
Backup_
${directory}
_
${timestamp}
```

Without braces, Bash can interpret adjacent valid variable name characters as part of the variable name.

---

## Copying `.txt` Files with Globbing

The script copies `.txt` files using:

```bash
cp *.txt "../$backup_dir"
```

The wildcard:

```text
*
```

matches filenames in the current directory.

Therefore:

```bash
*.txt
```

could expand to:

```text
archer.txt mage.txt warrior.txt
```

before `cp` executes.

An important lesson here was understanding the effect of quoting.

This:

```bash
"*.txt"
```

treats `*` literally.

Bash therefore looks for a file actually named:

```text
*.txt
```

Instead:

```bash
*.txt
```

allows Bash to perform **filename expansion**, also known as globbing.

---

## Relative Paths and `cd`

One of the most useful lessons from this challenge involved relative paths.

The backup directory is created first:

```bash
mkdir "$backup_dir"
```

The script then enters the source directory:

```bash
cd "$directory"
```

Suppose the filesystem initially looks like:

```text
/home/user/
├── Arena/
│   ├── archer.txt
│   ├── mage.txt
│   └── warrior.txt
│
└── Backup_Arena_2026-10-05_16-27/
```

After:

```bash
cd Arena
```

the current working directory becomes:

```text
/home/user/Arena/
```

The backup directory is therefore no longer in the current directory.

It is located one level above.

In Linux:

```text
..
```

represents the parent directory.

Therefore:

```bash
../"$backup_dir"
```

points from:

```text
/home/user/Arena/
```

to:

```text
/home/user/Backup_Arena_2026-10-05_16-27/
```

This allows the files to be copied using:

```bash
cp *.txt "../$backup_dir"
```

This challenge reinforced that relative paths are interpreted based on the **current working directory at the moment the command executes**.

---

## Counting the Backed-Up Files

The final requirement was to display how many files had been backed up.

The backup directory can be listed using:

```bash
ls "../$backup_dir"
```

The output can then be passed into another command using a **pipe**:

```bash
|
```

For example:

```bash
ls "../$backup_dir" | wc -l
```

The flow is:

```text
ls "../$backup_dir"
        |
        | output
        v
      wc -l
```

`wc -l` counts the number of lines it receives.

The result is captured using command substitution:

```bash
file_count=$(ls "../$backup_dir" | wc -l)
```

and then displayed:

```bash
echo "Backup completed! Files backed up: $file_count"
```

This introduced an important Bash principle:

> The output of one command can become the input of another command.

---

## Key Takeaways

This challenge combined:

- Functions
- Variables
- `read`
- `if/else`
- Directory tests with `-d`
- `mkdir`
- `cd`
- `cp`
- Wildcard expansion
- Relative paths
- Parent directories with `..`
- Command substitution
- `date` formatting
- Variable interpolation
- Pipes
- `wc -l`

The biggest lesson was that commands can be individually correct but still behave incorrectly if the script's **current directory, paths, quoting, variable expansion, or execution order** are misunderstood.

---

# Overall Lessons

Completing these four challenges helped me move from running individual Linux commands to combining them into Bash scripts.

Several concepts repeatedly appeared across the challenges.

## 1. Understand the Current Working Directory

Commands using relative paths depend on where the script currently is.

Running:

```bash
cd "$directory"
```

changes how every subsequent relative path is interpreted.

Commands such as:

```bash
pwd
```

can therefore be useful while debugging.

---

## 2. Understand When Bash Performs Expansion

Bash performs several forms of expansion before executing commands.

Examples covered in these challenges include:

### Variable Expansion

```bash
"$backup_dir"
```

### Command Substitution

```bash
$(date)
```

### Arithmetic Expansion

```bash
$(( v1 + v2 ))
```

### Filename Expansion

```bash
*.txt
```

Understanding these forms of expansion makes Bash behaviour much easier to predict.

---

## 3. Quote Variables, but Understand Globbing

Variables containing paths should generally be quoted:

```bash
"$filename"
"$directory"
"$backup_dir"
```

This protects values containing spaces or special characters.

However, quoting a wildcard:

```bash
"*.txt"
```

prevents glob expansion.

A useful pattern when combining a variable path with a wildcard is:

```bash
"$directory"/*.txt
```

Here the variable is protected while the wildcard remains available for expansion.

---

## 4. Use Variables to Avoid Repetition

Instead of repeatedly writing the same constructed value:

```text
Backup_Arena_2026-10-05_16-27
```

store it once:

```bash
backup_dir="Backup_${directory}_${timestamp}"
```

and reuse:

```bash
"$backup_dir"
```

This makes scripts easier to maintain and reduces the chance of inconsistent changes.

---

## 5. Structure Conditions According to Their Relationship

Use an `if/elif/else` chain when the branches represent alternatives:

```bash
if condition1; then
    ...
elif condition2; then
    ...
else
    ...
fi
```

Use separate `if` statements when multiple conditions need to be evaluated independently:

```bash
if condition1; then
    ...
fi

if condition2; then
    ...
fi
```

Use nesting when several operations should only occur after another condition succeeds:

```bash
if main_condition; then

    if condition1; then
        ...
    fi

    if condition2; then
        ...
    fi

fi
```

---

## 6. Read the Error Before Changing the Code

One of the most useful debugging habits I developed was reading Bash's error message before attempting another solution.

For example:

```text
date: extra operand '%Y-%m-%d_%H-%M'
```

pointed directly towards a problem with the arguments supplied to `date`.

Rather than randomly changing the script, the error can be broken down to understand what Bash actually received.

---

## 7. Build Scripts Incrementally

Instead of trying to write an entire script at once, each requirement can be tested individually.

For example, the backup script can be broken into:

```text
1. Can I read the directory?
2. Can I verify that it exists?
3. Can I create the backup directory?
4. Can I copy the files?
5. Can I generate the timestamp?
6. Can I include it in the directory name?
7. Can I count the copied files?
```

Once each component works, they can be combined into the final script.

This makes debugging easier because when something breaks, there are fewer possible causes.

---

# Conclusion

These challenges helped reinforce that Bash scripting is largely about combining relatively simple Linux commands with:

- Variables
- Expansion
- Conditional logic
- User input
- Paths
- Redirection
- Pipelines

The most valuable part of the exercises was debugging the scripts when they did not initially behave as expected.

Understanding **why** something failed, whether because of quoting, paths, variable expansion, conditional structure, or command syntax, made the underlying Bash concepts much clearer than simply memorising the final solution.
