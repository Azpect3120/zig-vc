# Version Control Structure

```bash
.version-control/
    branches/       # Stores branch information (for implimentation later)
        ...
    info/           # Other information (not sure what this is for)
        ...
    objects/        # Stores objects/blobs
        ...
    refs/           # Pointers to commits
        tags/       # Pointers to tags? (I think I will leave this out)
        heads/      # Pointers to branches
        remotes/    # Pointers to remote connections
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

