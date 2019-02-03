Cluster Resources:

- [Gauss wiki](https://wiki.cse.ucdavis.edu/support/systems/gauss)
- [Introduction to Gauss slides](https://wiki.cse.ucdavis.edu/_media/support/systems/intro_to_gauss_slides.pdf) Paul Baines
- email help@cse.ucdavis.edu

Draw picture of architecture.
Mention the 10 or so clusters on campus.

Vocabulary:

- client: your laptop or desktop
- server: a computer that is not right in front of you
- node: a single computer
- head node: the computer that everyone logs into.
- hostname: a name that resolves to an IP address part of domain naming system, like `google.com`

Points:

1. head node manages a queue of jobs
2. this class has a reserved partition
3. interactive versus batch jobs
4. run your jobs on the worker nodes


I open up a terminal and login to the cluster Gauss with `s141c-76` as follows:

```{bash}
$ ssh s141c-76@gauss.cse.ucdavis.edu
```

`ssh` means 'secure shell'.
It prompts me for my password, but no letters appear as I type.
This is normal (otherwise you would see how long my password is! GASP!)
I type it in and press enter, and then I see this:

```{bash}
$ ssh s141c-76@gauss.cse.ucdavis.edu
s141c-76@gauss.cse.ucdavis.edu's password:

No backups of home directories are available for this cluster. Copy important files to another location.

NOTICE! Biannual generator test is scheduled for Friday April 5th 5am. The gauss cluser will shut down Thursday for system maintenance.

Last login: Sun Feb  3 09:16:27 2019 from resnet-122-161.ucdavis.edu
Module slurm/2.6.2 loaded
s141c-76@gauss:~$
```

Now I have a terminal in front of me that looks similar my local one, but I'm using a remote machine.
I can verify this:

```{bash}
s141c-76@gauss:~$ whoami
s141c-76
s141c-76@gauss:~$ hostname
gauss.cse.ucdavis.edu
```

This says, I am the user `s141c-76` on the machine `gauss.cse.ucdavis.edu`.
