# WARNING: git filter-branch is deprecated. Use git-filter-repo instead:
#   pip install git-filter-repo
#   git filter-repo --commit-callback '
#     if commit.committer_name == b"OLD_NAME":
#       commit.committer_name = b"NEW_NAME"
#       commit.author_name = b"NEW_NAME"
#       commit.committer_email = b"new@example.com"
#       commit.author_email = b"new@example.com"
#   ' --refs HEAD~N..HEAD
#
# USAGE: change_commit_author.sh OLD_NAME NUM_COMMITS
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
