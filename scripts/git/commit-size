#!/usr/bin/perl

# <path_to_script>/commit-size | awk '/\s80973c0/ {print $1 " bytes"}'  80973c0

foreach my $rev (`git rev-list --all --pretty=oneline`) {
  my $tot = 0;
  ($sha = $rev) =~ s/\s.*$//;
  foreach my $blob (`git diff-tree -r -c -M -C --no-commit-id $sha`) {
    $blob = (split /\s/, $blob)[3];
    next if $blob == "0000000000000000000000000000000000000000"; # Deleted
    my $size = `echo $blob | git cat-file --batch-check`;
    $size = (split /\s/, $size)[2];
    $tot += int($size);
  }
  my $revn = substr($rev, 0, 40);
#  if ($tot > 1000000) {
    print "$tot $revn " . `git show --pretty="format:" --name-only $revn | wc -l`  ;
#  }
}