## Learn Github

* [Github bootcamp](https://help.github.com/categories/54/articles)
* [Got 15 minutes and want to learn Git?](http://try.github.io/levels/1/challenges/1) Very good!
* [Git in 5 minutes](http://classic.scottr.org/presentations/git-in-5-minutes)


## Create a new repository on the command line
Create a new repository online: [https://github.com/andriesfilmer](https://github.com/andriesfilmer) -> Repositories -> New

    touch README.md # And make some notes about the app.
    git init
    git add .
    git commit -m "first commit"
    git remote add origin https://github.com/andriesfilmer/someApp.git
    git push --force origin master # This wil overwrite the server files!

## Clone
Clone or copy a repository (which already exists).

    git clone https://github.com/andriesfilmer/someApp

## Push
    git pull orgin master

## Tips

### Which files need to push
    git status

Check with find

    find . -not -iwholename '*node_modules*' -not -iwholename '*.git*' -not -iwholename '*.sass-cache*' -ls

### Change name and email, remember password 
    git config --global user.name "Your Name"
    git config --global user.email you@example.com
    git config --global credential.helper 'cache --timeout=3600'

## Show last commits

    git diff HEAD^..HEAD

## Git undo
To reset a specific file to the last-committed state (to discard uncommitted changes in a specific file):

    git checkout thefiletoreset.txt

To reset last commit. This leaves your working tree (the state of your files on disk) unchanged and you'll need to add them again before committing.

    git reset HEAD~

Delete all files in the working copy (but not the .git/ folder!) which leaves it with only committed files.

    git reset --hard

Remove untracked files, including directories (-d) and files ignored by git (-x). Replace the -f argument with -n to perform a dry-run and it will tell you what will be removed.

    git clean -d -x -f

More tips: <https://stackoverflow.com/questions/927358/how-do-i-undo-the-last-commits-in-git>

## Ignoring files

    git rm --cached filename

    * [help.github.com/articles/ignoring-files](https://help.github.com/articles/ignoring-files)

## git delete - Mark as deleted files
Added the --no-run-if-empty option to xargs so that it doesn't throw an error when there are no deleted files:

    git ls-files -z -d | xargs -0 --no-run-if-empty git rm
    git commit -m 'delete files marked as deleted'

## git checkout delete files
If you have lots of files to restore you can use this which will re-checkout all the deleted files.

    git diff --name-status | sed -n '/^D/ s/^D\s*//gp' | xargs git checkout origin/master

## Submodules
With the error: 'projectfolder' already exists in the index". You need to remove your submodule git repository (projectfolder in this case) first for git path.

    rm -rf projectfolder
    git rm -r projectfolder

and then add submodule

git submodule add <git_submodule_repository> projectfolder

* [Git Tools - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

## Live preview from github
* [htmlpreview.github.io](http://htmlpreview.github.io/)
