# Tar Symlinks
*Small script to use tar -h option with dirs with cyclic symlinks*

If you try to use tar with -h option (in order to follow symlinks and archive the files they point to) with a directory containing cyclic symlinks, tar keeps running forever (at least until disk space ends...) because it gets trapped in a filesystem loop.

This simple script finds possible filesystem loops and excludes them from archive when launching tar command with -h option, in order to avoid the problem, and then adds them to tar archive as symlinks.

**Tested with tar(GNU tar) 1.29, find (GNU findutils) 4.7.0-git, GNU bash 4.4.12(1)-release**
