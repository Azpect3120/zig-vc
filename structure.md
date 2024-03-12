# Version Control Structure

```bash
.version-control/
    branches/       # Stores branch information (for implimentation later)
        ...
    info/           # Other information (not sure what this is for)
        ...
    objects/        # Stores objects/blobs
        ...
    refs/
        heads/      # Pointers to branches
        remotes/    # Pointers to remote connections
        commits/    # Pointers to commits
        TRACKED     # Pointers to tracked files
        ...
    logs/           # Version control logs (might not be necessary)
        ...
    HEAD           # Pointer to current branch (might point to the /ref/heads/<branch> file)
```

# Command List

- `init`: Initialize a new version control repository

- `distroy`: Remove the version control system from the current directory

- `track`: Add a file/directory to the version control system (might just keep this as add)

- `commit`: Commit changes to the version control system

- `status`: Show the status of the version control system, tracked files, untracked files, etc.

- `history`: Show the history of the version control system


# How this shit works
When I add a file, I need to hash the name of the file and store it in the objects directory, in its own directory 
which is named by the first byte of the hash. The contents are the contents of the file being added as a hash or something.

# Commits
When I commit, I need to take all the objects (or something) and then create a ref file in the `refs/commits/` directory 
which is a pointer to a file created in the `objects/` directory. That file is going to store the name (path) and the 
reference to the blob/object.

# Tracking
When a file is tracked an object/blob is created and a reference to that blob in the `refs/TRACKED` file. Somewhere 
we need to store the name of the object/blob/file (not sure where yet). When a commit happens, this file will be used
to determine which files to include in the commit.
