# rundeck
Maintenance Scripts for Rundeck

## Delete Rundeck job output history  

1. Set the retention time for the job. Example: 7 days, 10 days or more.

> These vars is supported as argument, and is required by the script.

2. Put the arguments in your [Script](https://github.com/viniciustbitencourt/rundeck/blob/master/deletehistory.sh)

```bash
bash deletehistory.sh 7 Your_Token Your_Rundeck_Node
bash import-job-rundeck.sh Project_Name Your_Token Your_Hostname 
```

## Import Rundeck job output history  

1. Put the yaml files in the same import-job-rundech.sh [Script](https://github.com/viniciustbitencourt/rundeck/blob/master/deletehistory.sh) directory. Example: file1.yml, file2.yml, file3.yml

> These vars is supported as argument, and is required by the script.

2. Put the arguments in your script to import job.

```bash
bash import-job-rundeck.sh Project_Name Your_Token Your_Hostname 
```
