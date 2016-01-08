function git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  test -z "$ahead"; and set ahead "+"
  test -z "$behind"; and set behind "-"
  test -z "$diverged"; and set diverged "±"
  test -z "$none"; and set none ""

  set -l commits (command git rev-list --left-right "@{upstream}...HEAD" ^/dev/null)
  set -l remote_count (count (for commit in $commits; echo $commit; end | grep '^<'))
  set -l local_count (count (for commit in $commits; echo $commit; end | grep -v '^<'))

  if test $local_count -gt 0 -a $remote_count -gt 0; echo "$diverged"
  else if test $local_count -gt 0; echo "$ahead"
  else if test $remote_count -gt 0; echo "$behind"
  else; echo "$none"
  end
end
