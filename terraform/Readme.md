we need a ecr first to hold the image we have created for a webserver running on nginx, therefore we will need to create a a ecr repo:

For this you can go in the terraform environment folder, then select the region, currently i have only a single region that is ap-southeast-2, inside the region there are different environemnt, currently we have only the dev environment.

Once we are inside the dev folder run the following command:

``terraform init``

Since we only need to deploy ecr repo first we need to use only the ecr modules:
To check whats going to be deployed we first do plan:
``terraform plan -target=module.ecr``

After checking the state we can decide it to apply, if we are satisfied we use the below command to apply:

``terraform apply -target=module.ecr```

#### Deploying ec2

For Creating a Ec2 instance we need to apply terraform,

Steps to be followed:
1. Go in folder path terraform/environment/ap-southeast-2/dev
2. Run command ``terraform init``
3. Run command ``terraform plan``, This will give you all the resources which are going to be applied in our aws account, check if everything looks correct if there is issue then resolve the terraform issue.
4. If we are satisfied with the result then we can run command ``terraform apply`` This will apply changes to AWS.
5. I am storing the tf.state in s3 bucket using the backend.tf

Once the changes are applied we can check the ec2 in aws console or access via aws cli.

#### Troubleshooting:

we are using userdata for installing packages and pulling the docker image from ecr repo, there can be case that our userdata did not completly run to check the logs of the userdata you can ssh on the running ec2 instace and go to path /var/log and cat cloud-init-output.log

***note we can use other method as well for running the docker on ec2, similar to above we can use cloud-init or the simple method will be putting dockerfile on s3 and the fetching docker file via s3 and buidling docker image on ec2 instance and running it.

once the deployment is succesfull and we can verify from cloud-init-output.log that container is running we can view the website on http://ip_of instance. we can redirect it to a particular domain name using application load balancer and r53 as refered above i dont current have a domain name register i am not able to do it currently but the code for the process is in this repo.


#### Limitations
The above deployment have limitation since i dont have a domain name register they are as follows:

1. If we add more content to the website and create a new image we will have to restart the ec2 instance to pickup the new image, if we had domain name though the ec2 instance has been restarted we will get the new content at same location on internet because of routing.
2. we can have a ansible playbook to deploy new image on a running ec2 instance as well, but the above method is prefered
