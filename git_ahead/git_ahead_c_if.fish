function git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  test -z "$ahead"; and set ahead "+"
  test -z "$behind"; and set behind "-"
  test -z "$diverged"; and set diverged "±"
  test -z "$none"; and set none ""

  set -l commit_count (command git rev-list --count --left-right "@{upstream}...HEAD" ^/dev/null)
  set -l remote_count (echo $commit_count | cut -d\t -f1)
  set -l local_count (echo $commit_count | cut -d\t -f2)

  if test \( $local_count -gt 0 \) -a \( $remote_count -gt 0 \); echo "$diverged"
  else if test $local_count -gt 0; echo "$ahead"
  else if test $remote_count -gt 0; echo "$behind"
  else; echo "$none"
  end
end
