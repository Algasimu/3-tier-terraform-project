

=============== Git Command =====================
Commands			        Description
git init			        Initializes a new Git repository in your current directory.
git clone <repo-url>		Clones an existing remote repository to your local machine.
git status			        Displays the state of the working directory and staging area.
git add <file>			    Stages a file to be committed.
git add .			        Stages all changes (new, modified, deleted) in the current directory.
git commit -m "message"		Commits staged changes with a descriptive message.
git push			        Pushes local commits to the remote repository.
git push origin <branch>	Pushes a specific branch to the remote repository.
git pull			        Fetches and merges changes from the remote repository to your local branch.
Git pull origin main		To compare the local codes with the remote Main branch
git fetch			        Retrieves changes from the remote without merging them.
git merge <branch>		    Merges a branch into your current branch.
git branch			        Lists all local branches.
Git branch -M <Main>		To change the branch to Main
git branch <branch-name>	Creates a new branch.
git checkout <branch-name>	Switches to the specified branch.
git checkout -b <new-branch>	Creates and switches to a new branch.
git log				        Shows the commit history for the current branch.
git diff			        Shows the differences between files before committing.
git reset <file>		    Unstages a file while keeping changes.
git reset --hard		    Resets the working directory and index to the last commit (all changes lost).
git rm <file>			    Removes a file from the working directory and stages the deletion.
git stash			        Temporarily saves uncommitted changes.
git stash pop			    Restores the last stashed changes.
git remote -v			    Shows remote connections associated with the repository.
git tag <tag-name>		    Creates a tag for marking a point in history (like a release).

#### Terraform commands
terraform plan -out="build.tfplan"
terraform show 
terraform state list
terraform state show -state="terraform.tfstate" aws_instance.web_server
terraform state mv -state="terraform.tfstate" aws_instance.web_server aws_instance.web_application_server #rename the resource from statefile
terraform state rm -state="terraform.tfstate" aws_instance.web_application_server  #remove resource from statefile