# Tar Symlinks
*Small script to use tar -h option with dirs with cyclic symlinks*

If you try to use tar with -h option (in order to follow symlinks and archive the files they point to) with a directory containing cyclic symlinks, tar keeps running forever (at least until disk space ends...) because it gets trapped in a filesystem loop.

This simple script finds possible filesystem loops and excludes them from archive when launching tar command, in order to avoid the problem.
