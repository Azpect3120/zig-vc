# Version Control

## [How Does It Work](https://www.kodeco.com/books/advanced-git/v1.0/chapters/1-how-does-git-actually-work)
Everything is a hash

Well, not everything is a hash, to be honest. But it’s a useful point to start when you want to know how Git works.

Git refers to all commits by their SHA-1 hashes. You’ve seen that many times over, both in this book and in your personal and professional work with Git. The hash is the key that points to a particular commit in the repository, and it’s pretty clear to see that it’s just a type of unique ID. One ID references one commit. There’s no ambiguity there.

But if you dig down a little bit, the commit hash doesn’t reference everything that has to do with a commit. In fact, a lot of what Git does is create references to references in a tree-like structure to store and retrieve your data, and its metadata, as quickly and efficiently as possible.

To see this in action, you’ll dissect the “secret” files underneath the .git directory and see what’s inside of each.

### My Take 
Basically, files and directories are stored in some way somehow (not sure yet). 
References to those files and directories are stored as hashed values to the *thing*.


## [The Inner Workings of Git](https://www.kodeco.com/books/advanced-git/v1.0/chapters/1-how-does-git-actually-work)
Change to your terminal program and navigate to the main directory of your repository. Once you’re there, navigate into the .git directory of your repository:

Now, pull up a directory listing of what’s in the .git directory, and have a look at the directories there. You should, at a minimum, see the following directories:

```bash
info/
objects/
hooks/
logs/
refs/
```

The directory you’re interested in is the objects directory. In Git, the most common objects are:

- **Commits:** Structures that hold metadata about your commit, as well as the pointers to the parent commit and the files underneath.
- **Trees:** Tree structures of all the files contained in a commit.
- **Blobs:** Compressed collections of files in the tree.

### The Git object repository structure

When Git stores objects, instead of dumping them all into a single directory, which would get unwieldy in rather short order, it structures them neatly into a tree. Git takes the first two characters of your object’s hash, uses that as the directory name, and then uses the remaining 38 characters as the object identifier.

Here’s an example of the Git object directory structure, from my repository, that shows this hierarchy:

```bash
objects
├── 02
│   ├── 1f10a861cb8a8b904aac751226c67e42fadbf5
│   └── 8f2d5e0a0f99902638039794149dfa0126bede
├── 05
│   └── 66b505b18787bbc710aeef2c8981b0e13810f9
├── 06
│   └── f468e662b25687de078df86cbc9b67654d938b
├── 0a
│   └── 795bccdec0f85ebd9411e176a90b1b4dfe2002
├── 0b
│   └── 2d0890591a57393dc40e2155bff8901acafbb6
├── 0c
│   └── 66fedfeb176b467885ccd1a1ec70849299eeac
├── 0d
│   └── dfac290832b19d1cf78284226179a596bf5825
├── 0e
│   └── 066e61ce93bf5dfaa9a6eba812aa62038d7875
├── 0f
│   └── a80ee6442e459c501c6da30bf99a07c0f5624e
├── 11
│   ├── 06774ed5ad653594a848631f1f2786a76a776f
│   ├── 92339da7c0831ba4448cb46d40e1b8c2bed12c
│   └── c1a7373df5a0fbea20fa8611f41b4a032b846f
.
.
.
```

To find the object associated with a commit, simply take the commit hash you found above:

```bash
d83ab2b104e4addd03947ed3b1ca57b2e68dfc85
```

Decompose that into a directory name and an object identifier:
```bash
Directory: d8
Object identifier: 3ab2b104e4addd03947ed3b1ca57b2e68dfc85
```
