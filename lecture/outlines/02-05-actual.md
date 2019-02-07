Announcements:

- Next class meeting please bring your laptop for the mid quarter evaluation
- We're emailing you login credentials to the cluster. Don't try to change or customize them, because the configuration settings will just change them back.
- The next data set for the homework and final project is here: http://anson.ucdavis.edu/~clarkf/sta141c/ You can start thinking about what kind of questions and data analysis you would like to do.
- I'm working on the next homework- Next class meeting we'll learn about some more powerful ideas in bash that you'll apply to do it.

Cluster Resources:

- [SLURM documentation](https://slurm.schedmd.com/)
- [Gauss wiki](https://wiki.cse.ucdavis.edu/support/systems/gauss)
- [Introduction to Gauss slides](https://wiki.cse.ucdavis.edu/_media/support/systems/intro_to_gauss_slides.pdf) Paul Baines
- [Cluster monitoring](http://stats.cse.ucdavis.edu/ganglia/)
- email help@cse.ucdavis.edu to install software and get access if you're not in this class.


Vocabulary:
- client: your laptop or desktop or cell phone
- server / node: any single computer not right in front of you 
- head node: the computer that everyone logs into that submits the jobs
- hostname: the DNS name of the server

hostname: gauss.cse.ucdavis.edu

nslookup gauss.cse.ucdavis.edu

Let's login to gauss with username s141c-76

ssh s141c-76@gauss.cse.ucdavis.edu

No backups, so use version control.

Verify that I'm actually on the remote computer

whoami

hostname

`exit` to close the connection and return to your local machine.

What software is available?

module avail

module load R/3.3.2

git clone https://github.com/clarkfitzg/slurm-example.git

# run batch jobs

sbatch ./submit.sh

check status of the job:

squeue
