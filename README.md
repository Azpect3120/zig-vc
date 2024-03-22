# How is this project gonna work 2.0

## File Structure
```bash
.something
    info/  
        path/

    objects/
        ...
    refs/
        TRACKED
```

## What Everything Means
- `info`: Various info
    - `path`: Stores the path of the objects relative to the project, the name of
    the related object (hash of the file name).

- `refs`: Various references
    - `TRACKED`: Stores a list of tracked object names

- `objects`: Object data
    - `...`: Stores the data of the file, the name will be the hash of 
    the actual file path relative to the project


## Developer Notes
- When tracking files, the `refs/TRACKED` should all be written to from the main thread
but the `objects/...` can be written to from their own thread. I think?
