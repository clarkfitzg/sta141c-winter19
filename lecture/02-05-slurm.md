Cluster Resources:

- [SLURM documentation](https://slurm.schedmd.com/)
- [Gauss wiki](https://wiki.cse.ucdavis.edu/support/systems/gauss)
- [Introduction to Gauss slides](https://wiki.cse.ucdavis.edu/_media/support/systems/intro_to_gauss_slides.pdf) Paul Baines
- email help@cse.ucdavis.edu

Draw picture of architecture.
Mention the 10 or so clusters on campus.
This applies to all of them, notably peloton which statistics now has access to.

I'm going to try to convey the concept, because this will make it much easier if you're reading the documentation later.

Vocabulary:

- client: your laptop or desktop
- server: a computer that is not right in front of you
- node: a single computer
- head node: the computer that everyone logs into.
- hostname: a name that resolves to an IP address part of domain naming system, like `google.com`

Points:

1. head node manages a queue of jobs and contention for resources
2. this class has a reserved partition
3. interactive versus batch jobs
4. run your jobs on the worker nodes
5. job can either be in the queue, running, or finished
6. network file system is an abstraction that makes all the files seem like they're on the same computer


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


## partitions

The partition `staclass` consists of two nodes, `c0-10` and `c0-19`.
We own these nodes for the duration of the quarter, so nobody else can use them.

The `sta141c-XX` student accounts have access to the __entire__ cluster resources.
It's possible for you to request a job that uses the entire cluster for 3 months.
Do not do this.
Use the `staclass` partition.

We have two nodes, each with 32 processors, so we should all be able to run jobs simultaneously if we use one core.


## moving your code and data

We're logged into the cluster, and now we need to put our code on the cluster so that we can run it.
I have some example code in a git repository that I will pull from Github.

```{bash}
git clone https://github.com/clarkfitzg/slurm-example.git
```

Typically you'll write some file `fancy_analysis.R` on your laptop, and get it working so that you can call `Rscript fancy_analysis.R` locally.

Let's see what open source software is available and ready to use.

```{bash}
module avail
```

## interactive mode

Interactive mode is useful for developing and experimenting.
It is not useful for running a large job that takes hours, because when you close your laptop your interactive job will be killed.

Lets get on a worker node.

```{bash}
srun --partition staclass --pty bash -i
```

- `srun` is the SLURM command
- `--partition staclass` specifies that we are running a job on the partition assigned to this class
- `--pty` is a flag for 'pseudo terminal mode'
- `bash` is the main argument, an executable to run
- `-i`, and anything else following the main argument `bash`, are arguments to the `bash` executable. `-i` means interactive mode.

Now I have an interactive terminal on a worker node, and I can enter whatever commands I like.

```{bash}
s141c-76@c0-10:~$ hostname
c0-10
```

With the defaults on this system I get 1 core and unlimited memory on this machine.

## queue

Let's look at the queue and see who is running what:

```{bash}
$ squeue
```

It shows the job that I'm currently running:

```
     JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
   2065075  staclass     bash s141c-76  R       6:15      1 c0-10
```

L
