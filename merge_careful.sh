USAGE="Usage: merge_careful <feature_branch_name> <master_branch_name>"

#Validate parameters

if [ -z "$1" ]; then
	echo "Need feature branch"
	echo "$USAGE"
	exit
fi

if [ -z "$2" ]; then
	echo "Need master branch"
	echo "$USAGE"
	exit
fi

if [ ! -z "$3" ]; then
	echo "Too much parameters"
	echo "$USAGE"
	exit
fi

#Validate current changes

echo "Checking current changes"

STATUS=`git status --porcelain`
if [ ! -z "$STATUS" ]; then
	echo "Current branch is not clean. Commit your current changes"
	echo "Aborted"
	exit
fi

echo "Ok"

FEATURE_BRANCH_NAME="$1"
MASTER_BRANCH_NAME="$2"

#Validate branch existance

echo "Checking branches"

STATUS=`git checkout -q $FEATURE_BRANCH_NAME`
if [ ! -z "$STATUS" ]; then
	echo "Cannot checkout branch $FEATURE_BRANCH_NAME. Possibly, it doesn't exist"
	echo "Aborted"
	exit
fi

STATUS=`git checkout -q $MASTER_BRANCH_NAME`
if [ ! -z "$STATUS" ]; then
	echo "Cannot checkout branch $MASTER_BRANCH_NAME. Possibly, it doesn't exist"
	echo "Aborted"
	exit
fi

echo "Ok"


echo "Pulling master from remote server"

git pull

STATUS=`git status --porcelain`
if [ ! -z "$STATUS" ]; then
	echo "Pull $FEATURE_BRANCH_NAME from remote server failed. Check for conflicts and try again"
	echo "Aborted"
	exit
fi

echo "Ok"

echo "**********************************"
echo "Master branch is"
echo `git show $MASTER_BRANCH_NAME`

echo ""
echo "Feature branch is"
echo `git show $FEATURE_BRANCH_NAME`

echo ""
echo "Do you really want merge feature branch into master? (y/n)"

read ANSWER

if [ ! "$ANSWER" == "y" ]; then
	echo "Aborted"
	exit
fi


MASTER_BRANCH_COMMIT=`git show --pretty=%H $MASTER_BRANCH_NAME`
FEATURE_BRANCH_COMMIT=`git show --pretty=%H $FEATURE_BRANCH_NAME`


echo $MASTER_BRANCH_COMMIT
echo $FEATURE_BRANCH_COMMIT

echo "Ok!"