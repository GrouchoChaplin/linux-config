#!/bin/env bash 

#alias gitBranchsByDate="git for-each-ref --sort=committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'"
#alias gitBranchsByDate="git for-each-ref --sort=committerdate refs/heads/ --format='%(color: red)%(committerdate:short) %(color: cyan)%(refname:short)'"
alias gitBranchsByDate="git for-each-ref --sort=committerdate refs/heads/ --format='%(color: red)%(committerdate:short) %(color: cyan)%(refname:short)'"

git_clone_SSL_NO_VERIFY()
{
	GIT_SSL_NO_VERIFY=false git $1 $2
}

git_branch() 
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

findLatestRemoteBranch()
{
	for k in `git branch -r | perl -pe 's/^..(.*?)( ->.*)?$/\1/'`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r
}

findLatestLocalBranchDesc()
{
	for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r	
}

findLatestLocalBranchAsc()
{
	for k in `git branch | sed s/^..//`; do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k --`\\t"$k";done | sort
}

