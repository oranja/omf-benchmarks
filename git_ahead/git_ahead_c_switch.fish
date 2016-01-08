function git_ahead -a ahead behind diverged none
  not git_is_repo; and return

  test -z "$ahead"; and set ahead "+"
  test -z "$behind"; and set behind "-"
  test -z "$diverged"; and set diverged "±"
  test -z "$none"; and set none ""

  set -l commit_count (command git rev-list --count --left-right "@{upstream}...HEAD" ^/dev/null)

  switch "$commit_count"
  case ""
      # no upstream
  case "0"\t"0"
      echo "$none"
  case "*"\t"0"
      echo "$behind"
  case "0"\t"*"
      echo "$ahead"
  case "*"
      echo "$diverged"
  end
end
