# Server

Resources

- Gauss wiki https://wiki.cse.ucdavis.edu/support/systems/gauss
- Paul Baines introduction to Gauss slides https://wiki.cse.ucdavis.edu/_media/support/systems/intro_to_gauss_slides.pdf

## moving files between machines

We don't like to move large data sets because it takes a long time.
But sometimes we have to do it.
`scp` (secure copy) and `sftp` (secure file transfer program) are two popular command line tools to do this.
Consider `rsync` if you need to move files more regularly.

Here's an example of how to use `scp`:

```
$ scp data.txt clarkf@poisson.ucdavis.edu:/home/clarkf/data.txt
data.txt                                                100%  742     0.7KB/s   00:00
```

This logs in to the host `poisson.ucdavis.edu` with the username `clarkf`, and copies the local file `data.txt` to the remote file `/home/clarkf/data.txt`.
To make sure this worked I can log in to the server and verify that the file exists on the server.

If something goes wrong then I can use verbose mode by writing `scp -v` rather than `scp`.
I can learn about this flag by running `man scp`, which states:

```
     -v      Verbose mode.  Causes scp and ssh(1) to print debugging messages about their
             progress.  This is helpful in debugging connection, authentication, and con‐
             figuration problems.
```


