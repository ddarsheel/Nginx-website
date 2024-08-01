# Nginx-website
This is repo which is used to create a nginx server and host a website

##There are 2 folders I have created here one is for ansible and other is for terraform.

I am using the modules for the Terraform.
The Terraform folder structure is divided into 2:
1. Environments
2. Modules

The Modules consist of terraform configuration for different resources we want to Create on our AWS account.
##The resource we are creating are:
1. ECR 
2. EC2
3. Application load balancer
4. Autoscalling group
5. Security group

For this Project we are just creating a ecr, ec2 instance and security group. But I have commented the code for autoscalling group, application load balancer and r53.

If we want to use autoscalling group for launching the ec2 instance we will need to change the ec2 configuration to have webconfiguration and use launch_configuration instead of the current aws_instacen resource. This will allow us to create a laucnh configuration using autoscalling group and the commented autoscalling group code can be used. I have commented it because i wanted to check instance id and ip for the instance with terraform, which is currently not possible when using autoscalling group.

The other limiation I had was I am not having a register domain name there, i was not able to use application load balancer to check the traffice, if you have a domain name register you can un comment the code for application load balancer, substiute correct variables for the it and also check if the autoscalling group is targeting correct targetGroup.



###Actual Working:

we need a ecr first to hold the image we have created for a webserver running on nginx, therefore we will need to create a a ecr repo:

For this you can go in the terraform environment folder, then select the region, currently i have only a single region that is ap-southeast-2, inside the region there are different environemnt, currently we have only the dev environment.

Once we are inside the dev folder run the following command:

``terraform init``

Since we only need to deploy ecr repo first we need to use only the ecr modules:
To check whats going to be deployed we first do plan:
``terraform plan -target=module.ecr``

After checking the state we can decide it to apply, if we are satisfied we use the below command to apply:

``terraform apply -target=module.ecr```

####
Now we have the ecr repo we need to have a dockerimage image with Nginx and some website content.

we are using a Dockerfile for creating an image and we are using ansible playbook to push the image to ecr repo. [we can do the manually, but we are using ansible so that we can later configure our playbook with our ci/cd to push the image]

In ansible folder you can check there are 3 folder:
1. Inventories
2. Playbook
3. Variables

The Inventories consist of the environement files and the details regarding the host used for the particular environemnt[ we can use host vars and group vars as well]
The Playbook consist of playbooks to be deployed with their respective configuations and reference for the vars and environment.
The Variables consist of variable for playbooks.[ we can use host vars and group vars as well]

for running the Ansible playbook to push our image to ecr repo.

Command to run the ansible playbook:

``ansible-playbook -i /ansible/inventories/development.ini /ansible/playbook/push_ecr.yml`` 
[path to the file is very important, also checking if the path for dockerfile is correct or not


#### Dockerfile

we are creating a simple docker with nginx server, some html and css content and exposing port 80 and 443 for http and https, i dont have ssl certificate so https will not work but if we get ssl we can put it in dockerfile and make it work on https as well.

Before moving to the ansible we need to verify if image is built correctly on not, and container is working correct for this we can run docker build on local:

command to build image in local:
``docker build -t nginxweb .``

command to run container on local:
``docker run -d -p 80:80 nginxweb``


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

once the deployment is succefull and we can verify from cloud-init-output.log that container is running we can view the website on http://ip_of instance. we can redirect it to a particular domain name using application load balancer and r53 as refered above i dont current have a domain name register i am not able to do it currently but the code for the process is in this repo.


#### Limitations
The above deployment have limitation since i dont have a domain name register they are as follows:

1. If we add more content to the website and create a new image we will have to restart the ec2 instance to pickup the new image, if we had domain name though the ec2 instance has been restarted we will get the new content at same location on internet because of routing.
2. we can have a ansible playbook to deploy new image on a running ec2 instance as well, but the above method is prefered

