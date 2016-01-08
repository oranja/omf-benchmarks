#!/bin/fish

function run -a path
    set -l iterations 10000
    set -l original_wd (pwd)
    set -l methods (ls git_ahead*.fish)
    set -l legend ahead behind diverged same

    #source $OMF_PATH/lib/git/git_ahead.fish  # has a bug
    source git_ahead_c_switch.fish

    echo "Entering $path"
    pushd $path
    git_is_repo; or begin; echo "... not a repo"; return; end

    echo "iterations: $iterations"
    set -l repo_state (git_ahead $legend)
    echo "repo state: $repo_state"
    echo

    for method in $methods
        echo "Testing $original_wd/$method"
        source "$original_wd/$method"
        set -l suggested_repo_state (git_ahead $legend)
        test $suggested_repo_state = $repo_state; or begin; echo "... wrong state reported"; continue; end
        time -p fish -c "source \"$original_wd/$method\"; for i in (seq $iterations); git_ahead >/dev/null; end"
        echo
    end

    prevd
end

run $argv[1]
