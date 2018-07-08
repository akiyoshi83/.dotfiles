oldname=$1
num=$2
git filter-branch --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "$oldname" ];
        then
                GIT_COMMITTER_NAME="akiyoshi83";
                GIT_AUTHOR_NAME="akiyoshi83";
                GIT_COMMITTER_EMAIL="mail@akiyoshi.info";
                GIT_AUTHOR_EMAIL="mail@akiyoshi.info";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD~$num..HEAD
