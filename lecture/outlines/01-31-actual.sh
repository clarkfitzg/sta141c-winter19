# Bash
#
# - read the help pages
# - how the shell finds programs
# - Write our own little programs

# We like it because:
# 
# - stable, there's a POSIX standard
# - powerful
# - easy to automate tasks

# Other shells: fish, zsh, csh, tsh
# in Windows: git-bash, wsl Linux subsystem, virtual machine, Cygwin
# Not Powershell

# Better yet, just connect to a server.

# pwd: print working directory
# ls: list files

# To find help:

man ls

ls -a

file .Rhistory

head .Rhistory

# Some special symbols:
# ~ Home directory
# . for the current directory
# .. for the parent directory
# Navigating directory:
cd

# How to find all keyboard shortcuts for the file pager? (less)

# WHere do all these commands come from?

which less

# Point:
# Commands are just executable files for the most part.

# How do we find these programs?

# The PATH variable

echo $PATH


# How do you change the path?


# export it, see .bashrc

# How do we run an R script?

Rscript hello.R

# How about as an executable:

./hello.R

# Let's make it executable by changing file permissions

chmod +x hello.R

bash hello.R

# removing files is for reals
