function git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  test -z "$ahead"; and set ahead "+"
  test -z "$behind"; and set behind "-"
  test -z "$diverged"; and set diverged "±"
  test -z "$none"; and set none ""

  set -l commits (command git rev-list --left-right "@{upstream}...HEAD" ^/dev/null)
  set -l remote_count (count (for commit in $commits; echo $commit; end | grep '^<'))
  set -l local_count (count (for commit in $commits; echo $commit; end | grep -v '^<'))

  switch "$remote_count $local_count"
  case ""
      # no upstream
  case "0 0"
      echo "$none"
  case "* 0"
      echo "$behind"
  case "0 *"
      echo "$ahead"
  case "*"
      echo "$diverged"
  end
end
