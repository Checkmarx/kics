# Running KICS in Bamboo

You can easily integrate KICS into Bamboo. The example below demonstrates how you can run KICS in a build plan linked to a GitHub repository.


After you create a project with a build plan linked to a Github repository, you need to create a task to run KICS.
The script body should contain `docker run -v ${PWD}:/path checkmarx/kics:latest scan -p /path -o /path/results --ci --ignore-on-exit results`.


![creatingTask](https://user-images.githubusercontent.com/74001161/152352791-9aa161b9-5d57-456b-a0a8-990930bf7960.gif)


For example, to turn on this task every time a commit is merged in the Github repository, you need to create a plan branch that enables that.



![createPlanBranch](https://user-images.githubusercontent.com/74001161/152361840-94768245-0bbe-43cd-adaa-9afb9289e381.gif)


The build will run every time a commit is merged in the Github repository.


![commits](https://user-images.githubusercontent.com/74001161/152364388-fa37aede-a299-47bf-a3d1-45985614481c.gif)
