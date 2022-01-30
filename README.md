# Teaching-Boilerplate

## Prerequisites :

Make sure you have python and node installed

    git remote rename origin boilerplate
    git remote add origin git@...
    git checkout -b upstream/boilerplate/master --track


Install python packages

    pip install -U pipenv
    pipenv install

Install node packages

    npm install


## Usage

### First steps

Clean this repository

Change the remote


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
