# aws-deep-racer-for-cloud
AWS Deep Racer for Cloud Set-up using Sport Instance

## Pre-reqs

- Install Hashicorp Terraform on your device
- An AWS account
- Sufficient Quota request fulfilled for your desire Spot instance (this can take several days for AWS to fulfill a GPU instance so may be worth selecting c5.2xlarge as a good CPU based instance to train with)

## Instructions for Use

### Set-up and start training

- Download repo
- Upload your desired configuration files ('hyperparameters.json', 'model_metadata.json' and 'reward_function.py' to the 'deep-racer-model' folder within the repo - note you'll need to overwrite the existing files, or alternatively use the existing files for demo purposes)
- cd to terraform folder
- run 'terrform init'
- run 'terraform apply'
- Type 'yes' at the prompt
- After completion of the Terraform apply command you should get 'Apply complete!' message along with a summary of the number of created resources.  At this point you should wait for around 10 minutes whilst the EC2 instance boots up and the relevant software defined in the userdata.tpl file is installed.
- Navigate in the AWS Console to the instance that's been created and chose to connect to it (and then select Session Manager option)
- Type 'sudo su' at the prompt
- Type 'cd /' at the prompt
- Type 'ls deepracer-for-cloud/' - if you see a file called 'DONE' in the list then you're ready for the next steps, if not wait a while longer and repeat the ls command until the file exists
- Type 'source ./deepracer-for-cloud/bin/activate.sh'
- Type 'dr-update'
- Type 'dr-start-training'
- At this point the containers to run Sagemaker and Robomaker should initiate.  You may see some errors, these typically relate to it being a first training run and being unable to find previous checkpoints, eventually it should settle at 'DoorMan: installing SIGINT, SIGTERM' on the terminal
- You training should now have begun and within a few minutes you should see references to episodes, reward, steps etc - e.g. 'Training> Name=main_level/agent, Worker=0, Episode=1, Total reward=40.55, Steps=65, Training iteration=0', which means the training is working.  If no output is seen after 'DoorMan: installing SIGINT, SIGTERM' then there is a problem.
- After a while your Session Manager session may be terminated - don't worry if this occurs your training is still running in the containers on the instance

### End training and upload model

- Type 'dr-stop-training -f'
- Navigate to the AWS Deep Racer Console and select 'Import Model' from the 'Your Models' part of the console
- Note you need to select the s3 bucket and prefix - e.g. 's3://deepracer-for-cloud-upload-20221219141805240700000001/rl-deepracer-sagemaker/' as the location