
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

## Branches
    git branch           # Show branches
    git branch issue53   # Create branch 'issue53'
    git checkout issue53 # Work with branch 'issue53'

Fix issue53 and commit the fix.
    git commit -am 'Fixed issue53'
    git push -u origin issue53 # Push to remote

Back to master branch
    git checkout master  # Switched to branch 'master'

Diff between branches
    git diff HEAD..origin/master [path]

Merge a branch
    git checkout master
    git merge issue53

Remove branch
    git branch --delete issue53        # Remove local branch
    git push origin --delete issue49   # Delete old (stale) branch on remote.

Get rid of remote branches that no longer exist on the remote
    git fetch --prune

## Stash
Save some work for later

    git stash push -m "my_temp_changes"
    git stash apply stash@{0}  # Apply the most recent stash

**Revert to master**
Make sure your working directory is clean (no uncommitted changes), then:

    git checkout master
    git pull origin master  # Optional: update your local master

Now you’re on master with no trace of your previous changes.

Reapply Your Saved Changes Later

    git stash list  # See all your stashes
    git stash apply stash@{0}  # Apply the most recent stash

Or, if you want to remove the stash after applying:

    git stash pop stash@{0}

## Tips

See recent changes of a specific file.
    git blame /path/to/file
    git reflog /path/to/file
    git log /path/to/file

Check with find

    find . -not -iwholename '*node_modules*' -not -iwholename '*.git*' -not -iwholename '*.sass-cache*' -ls

### Change name and email, remember password

    git config --global user.name "Your Name"
    git config --global user.email you@example.com
    git config --global credential.helper 'cache --timeout=3600'

## Show last commits

    git diff HEAD^..HEAD
    git difftool --tool=vimdiff


## Stage only deleted

    git ls-files --deleted -- lib/foo | xargs git add

## Git revert vs. reset

Use revert if you already pushed, other wise use reset or checkout.

## Git undo

To reset a specific file to the last-committed state (to discard uncommitted changes in a specific file):

    git checkout thefiletoreset.txt

To reset to a commit state. Run `git reflog` to jump back and forwards in time, for example:

    get reset dfd69a56

Delete all files in the working copy (but not the .git/ folder!) which leaves it with only committed files.

    git reset --hard

Remove untracked files, including directories (-d) and files ignored by git (-x).
Replace the -f argument with -n to perform a dry-run and it will tell you what will be removed.

    git clean -d -x -n     # dry-run
    git clean -d -x -f

Nice overview: [Resetting, checking out & reverting](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting) | Atlassian

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

Working on one project, you need to use another project from within it.

git submodule add -f https://github.com/google/vim-searchindex.git ~/gtd/dotfiles/.vim/pack/bundle/start/vim-searchindex

* [Git Tools - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

## Live preview from github
* [htmlpreview.github.io](http://htmlpreview.github.io/)

## Learn Github

* [Github bootcamp](https://help.github.com/categories/54/articles)
* [Got 15 minutes and want to learn Git?](http://try.github.io/levels/1/challenges/1) Very good!
* [Git in 5 minutes](http://classic.scottr.org/presentations/git-in-5-minutes)
* [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
* [How to undo almost anything with git](https://github.blog/2015-06-08-how-to-undo-almost-anything-with-git/)
