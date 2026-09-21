## Bandit Level 0 → Level 1

**Challenge:** Read the contents of the file containing the password.

**Solution:**

```bash
cat readme
```

**Explanation:**

* `cat` displays the contents of a file in the terminal.
* If you know the filename and it has no unusual characters, you can simply provide the filename as an argument to `cat`.

**Password:** `6y2kwnwK6grgvwvpvLaa2T1cpFEKOhNR`

**What I learned:** `cat` can be used to quickly display the contents of a text file.

---

## Bandit Level 1 → Level 2

**Challenge:** Read a file whose filename begins with `-`.

**Solution:**

```bash
cat ./-
```

**Explanation:**

* A filename beginning with `-` can be interpreted by a command as an option.
* `./` explicitly gives the path to the file in the current directory.
* This allows the filename to be treated as a file rather than as a command-line option.

**Password:** `PK8fYLZg2hnHSz83plBL1iEPKdD3QToB`

**What I learned:** Use `./` when working with filenames beginning with `-` so they are not interpreted as command options.

---

## Bandit Level 2 → Level 3

**Challenge:** Read a file whose filename contains spaces and begins with `-`.

**Solution:**

```bash
cat ./'--spaces in this filename--'
```

**Explanation:**
There are two problems with this type of filename:

1. It begins with `-`, so the command may interpret it as an option.
2. It contains spaces, so without quotes the shell would split the filename into several separate arguments.

Using `./` deals with the leading `-`, while quotation marks keep the entire filename together as one argument.

If I did not know where a particular file was stored, I could use `find` to search for it.

**Password:** `7ZZ2LFrykP2zEyvBl4m3clcL7tGYJPME`

**What I learned:** Quotes protect filenames containing spaces, while `./` helps safely reference filenames beginning with `-`.

---

## Bandit Level 3 → Level 4

**Challenge:** Locate and read a hidden file.

**Solution:**

```bash
ls -la
```

Then read the relevant hidden file using `cat`.

**Explanation:**

* Linux hidden files begin with `.`.
* Normal `ls` does not display hidden files.
* `ls -a` displays all files, including hidden ones.
* `ls -la` additionally gives the long-format details of those files.

**Password:** `xzTXq1rDJQVVAzdv5cHq1TQytTWufAMq`

**What I learned:** Hidden files begin with `.` and can be displayed using `ls -a` or `ls -la`.

---

## Bandit Level 4 → Level 5

**Challenge:** Determine which file contains human-readable data.

**Solution:**

```bash
file ./*
```

**Explanation:**

* `file` examines a file and reports what type of data it contains.
* `./*` expands to the files in the current directory.
* This allows `file` to examine multiple files at once.
* A file identified as text can then be read using `cat`.

**Password:** `6C7h9GD8M6ai5nr7wo1RonrzFjj9yIrG`

**What I learned:** The `file` command is useful when file extensions or filenames do not tell me what kind of data a file contains.

---

## Bandit Level 5 → Level 6

**Challenge:** Find a file with specific properties such as its type, size and permissions.

**Solution:**

```bash
find . -type f -size 1033c ! -executable
```

**Explanation:**
The `find` command can combine several search conditions.

Useful examples include:

```bash
-type f
```

Search for regular files.

```bash
-writable
```

Search for writable files.

```bash
-size 1000c
```

Search for files exactly 1000 bytes in size.

```bash
-size +1000c
```

Search for files greater than 1000 bytes.

```bash
-executable
```

Search for executable files.

```bash
! -executable
```

Search for files that are not executable.

The `c` suffix means bytes.

**Password:** `pXa26xhMWaC2SvDotA4r9EgZkulOeSBW`

**What I learned:** `find` is extremely powerful because multiple conditions can be combined to narrow down a search.
Reflecting on this level, the challenge was extremely useful, as I researched the various use cases of the `find` command and that immediately benefited me in the later levels. Please refer back to the above explanation to understand some of these use cases.

---

## Bandit Level 6 → Level 7

**Challenge:** Search the filesystem for a file based on its owner, group and size while dealing with permission errors.

**Solution:**

```bash
find / -type f -group bandit6 -user bandit7 -size 33c 2> /dev/null -exec cat {} \;
```

**Explanation:**

* `find /` searches from the root of the filesystem.
* `-type f` searches only for regular files.
* `-group bandit6` searches for files belonging to that group.
* `-user bandit7` searches for files owned by that user.
* `-size 33c` searches for files exactly 33 bytes in size.
* `2>` redirects standard error.
* `/dev/null` discards anything sent to it.
* Therefore, `2> /dev/null` hides permission-denied and other error messages.
* `-exec` runs another command on each result found by `find`.
* `{}` represents the file found by `find`.
* `\;` marks the end of the `-exec` command.

**Password:** `Bmnnvf82KzQlfxgAI2d1zYbr1u9pr3E3`

**What I learned:** `find` can search by ownership and group, while `2> /dev/null` can hide unwanted error output. `-exec` lets me perform another command directly on the files that `find` discovers.

---

## Bandit Level 7 → Level 8

**Challenge:** Find a particular piece of text inside a file.

**Solution:**

```bash
grep "millionth" data.txt
```

A broader search could use:

```bash
find / -name "*.txt" 2> /dev/null -exec grep "millionth" {} \;
```

**Explanation:**

* `grep` searches text for a particular word or pattern.
* `-name "*.txt"` tells `find` to search for filenames ending in `.txt`.
* `*` is a wildcard meaning any sequence of characters.
* `2> /dev/null` hides standard-error messages.
* `-exec grep ... {} \;` runs `grep` against files returned by `find`.
* `grep -H` can be useful when I also want `grep` to display the filename containing the match.

**Password:** `VR1ljMayciFxbnUokuQmJFw6QC9VKtub`

**What I learned:** `grep` searches inside files, while `find` searches for files. They can be combined when I need to locate files and then search their contents.

---

## Bandit Level 8 → Level 9

**Challenge:** Find the line that occurs only once in a file.

**Solution:**

```bash
sort data.txt | uniq -u
```

**Explanation:**

* `sort` arranges the lines so identical lines are next to each other.
* `|` sends the output of `sort` into the next command.
* `uniq` detects adjacent duplicate lines.
* `uniq -u` displays only lines that occur once.

`uniq` works best here after `sort` because duplicate lines need to be adjacent for `uniq` to recognise them.

**Password:** `[password here]`

**What I learned:** `sort` and `uniq` are often used together when analysing duplicate or unique lines in text.

---

## Bandit Level 9 → Level 10

**Challenge:** Extract human-readable strings from a file containing binary/non-readable data and locate the relevant pattern.

**Solution:**

```bash
strings data.txt | grep "=="
```

**Explanation:**

* `strings` extracts sequences of printable, human-readable characters from a file.
* `|` passes those strings to `grep`.
* `grep "=="` filters the output to lines containing `==`.

**Password:** `B0s2khmbT9u0geKuOoVGW3JZKhndE3BG`

**What I learned:** `strings` is useful for finding readable text hidden inside files that otherwise contain binary or non-readable data. To add a personal reflection, this was one of those levels where the solution was a lot simpler than expected. 
It taught me that finding a solution that works doesn't have to be complicated - rather, it just needs to work. 
It's the difference between "appearing intelligent" and being "effective".

---

## Bandit Level 10 → Level 11

**Challenge:** Decode Base64-encoded data.

**Solution:**

```bash
base64 -d data.txt
```

**Explanation:**

* `base64` can encode and decode Base64 data.
* `-d` means decode.
* `data.txt` is supplied as the input file.

**Password:** `pYfOY6HwUsDj5rL9UvyhU7MCmv8vN5Ro`

**What I learned:** Base64 is an encoding format rather than encryption. The `base64 -d` command converts encoded Base64 data back into its original form.

---

## Bandit Level 11 → Level 12

**Challenge:** Decode text that has been transformed using ROT13.

**Solution:**

```bash
alias rot13="tr '[a-z][A-Z]' '[n-za-m][N-ZA-M]'"
cat data.txt | rot13
```

**Explanation:**

* ROT13 replaces each letter with the letter 13 positions later in the alphabet.
* `tr` translates one set of characters into another.
* The alias gives the longer `tr` command the convenient name `rot13`.
* `cat data.txt | rot13` sends the contents of the file through the ROT13 transformation.

Because ROT13 shifts by exactly half of the 26-letter alphabet, applying ROT13 again reverses the transformation.

**Password:** `GROozWPO8QyN0mGrjUkID0WCYkZiQxrN`

**What I learned:** `tr` can perform character-by-character substitutions, and aliases can give longer commands shorter names.

---

## Bandit Level 12 → Level 13

**Challenge:** Recover data that has gone through multiple layers of compression and is represented as a hexdump.

**Solution process:**

First, convert the hexdump back into binary data.

Then repeatedly determine the current file type:

```bash
file filename
```

Depending on the result, use the appropriate decompression/extraction tool, such as:

```bash
gunzip filename
bunzip2 filename
tar -xf filename
```

After each layer is removed, run `file` again to determine what the new file actually contains.

**Explanation:**

* A hexdump is a textual representation of binary data.
* It must first be converted back into its original binary form.
* `file` is useful because filenames and extensions cannot always be trusted to identify the compression format.
* `gzip`, `bzip2` and `tar` are different formats and require different tools.
* Some files may contain another compressed file, meaning the process has to be repeated several times.
* `tar` is primarily an archive format rather than a compression algorithm itself.

**Password:** `qQYQiHOBPR8zR61qxYqX45quvihF2uzk`

**What I learned:** When dealing with multiple layers of compressed data, I should not guess based on the filename. I can repeatedly use `file` to identify the current format and then use the appropriate extraction or decompression command. It also taught me what a hexdump is. 
To add another personal reflection - this was the task that made me appreciate the importance of automation. 
The amount of times I had to repeat the above commands, it became clear to me that a simple script could've given me the password in seconds.

---

## Bandit Level 13 → Level 14

**Challenge:** Authenticate to another SSH account using a private SSH key instead of a password.

**Solution process:**

The private key was located in the home directory.

I created a copy of the key in `/tmp` and stored it inside a `.ssh` directory.

I then restricted its permissions:

```bash
chmod 600 copyprivate_key
```

Because connecting through `localhost` was not suitable in my environment, I opened another terminal and transferred the key to my own machine using `scp`:

```bash
scp -P 2220 bandit13@bandit.labs.overthewire.org:/tmp/.ssh/copyprivate_key .
```

The file initially ended up under `/mnt/c`, so I copied it into my Linux home directory and restricted its permissions again.

I then authenticated using the private key:

```bash
ssh -p 2220 -i /home/akguest/.ssh/copyprivate_key bandit14@bandit.labs.overthewire.org
```

**Explanation:**

* SSH can authenticate using a private key instead of a password.
* `chmod 600` gives the owner read/write permissions while removing permissions for everyone else.
* SSH rejects private keys when their permissions are too open.
* `scp` securely copies files between machines over SSH.
* In `scp`, `-P 2220` specifies the remote SSH port.
* In `ssh`, `-p 2220` specifies the SSH port.
* `ssh -i` tells SSH which identity/private-key file to use.

**Password:** SSH private key used for authentication.

**What I learned:** SSH does not always require password authentication. Private keys can be used instead, but the key must be stored securely with appropriately restrictive permissions. 
Adding in another personal reflection - this was the challenge I enjoyed the most because it significantly improved my problem-solving and troubleshooting skills. Previous challenges had accustomed me to searching for a password, whereas this task required me to find something unfamiliar - therefore I had to think differently. 
It forced me to break the solution down into individual steps and understand how each one connected to the next. Working through that analytical process and eventually reaching the solution was extremely satisfying and rewarding.

---

## Bandit Level 14 → Level 15

**Challenge:** Send the current password to a service listening on a specific network port.

First, I retrieved the Level 14 password:

```text
aaWecNkG4FhxJQxz07uiwzVP6bJiYS65
```

Then I connected to the service using Netcat:

```bash
nc bandit.labs.overthewire.org 30000
```

I entered the Level 14 password into the connection and received the next password.

**Explanation:**

* `nc` stands for Netcat.
* Netcat can create basic TCP or UDP network connections.
* `bandit.labs.overthewire.org` specifies the host.
* `30000` specifies the port.
* Once connected, text entered into the terminal is sent to the remote service.

**Password:** `pbLYuZtTg4MgaqfJx8jbA9gKKGqM68A7`

**What I learned:** Netcat is a simple but powerful networking tool that can connect directly to a host and port, allowing me to send and receive data over a network connection.
