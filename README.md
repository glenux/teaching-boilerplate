:rotating_light: The project has moved to a self-hosted git instance!<br/>
:rotating_light: Please use the new URL for an up-to-date version: https://code.apps.glenux.net/glenux/docmachine

# Teaching-Boilerplate

## Prerequisites :

Make sure you have docker installed

## Usage

### Create your directory tree

```
.           # project directory
|- docs     # where website documents go
|  `- *.md
|- slides   # where presentation documents go
|  `- *.md
|- images/  # where images go
|- ...
```

### Write content for docs


### Write content for slides


### Watch mode

This mode allows you the result on-the-fly as you makea changes in the content.

To use watch mode, type:

    make watch

To use watch mode for slides only type:

    make watch-slides

To use watch mode for docs only type:

    make watch-docs


### Build mode

This mode builds final content for delivery (website, PDF files)

To use build mode:

    make build
