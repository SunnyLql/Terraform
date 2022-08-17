# switch user in github
To change locally for just one repository, enter in terminal, from within the repository

git config credential.username "new_username"

To change globally use

git config --global credential.username "new_username"

# create personal access token in github
 Account Settings --developer settings --Personal access tokens

# create new repo in github, including .gitingnore 
# go to local terminal 
 git clone repo-url   # local have a folder with same name as repo name

# step-iterate
 git branch -a 
 git branch newbranchname
 git checkout newbranchname
 git add .
 git commit -m "message"
 git push   # git push --set-upstream origin newbranchname
 
 # Create PR in github, PR need approval ,then mergy to main. 
 # Local terminal : git checkout main , git pull

# step-iterate
 
 


