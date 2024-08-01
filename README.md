# Nginx-website
This is a repo that is used to create a nginx server and host a website.

##There are 2 folders I have created here, one for Ansible and the other for Terraform.

I am using the modules for the Terraform.
The Terraform folder structure is divided into 2:
1. Environments
2. Modules

The modules consist of Terraform configurations for different resources we want to create on our AWS account.
## The resources we are creating are:
1. ECR 
2. EC2
3. Application load balancer
4. Autoscalling group
5. Security group

For this project, we are just creating an ecr, ec2 instance, and security group. But I have commented on the code for the autoscalling group, application load balancer, and r53.

If we want to use the autoscalling group for launching the EC2 instance, we will need to change the EC2 configuration to have webconfiguration and use launch_configuration instead of the current aws_instacen resource. This will allow us to create a laucnh configuration using the autoscalling group, and the commented autoscalling group code can be used. I have commented it because I wanted to check the instance ID and IP for the instance with Terraform, which is currently not possible when using an autoscalling group.

The other limitation I had was that I do not have a registered domain name there; I was not able to use the application load balancer to check the traffic. If you have a registered domain name, you can uncomment the code for the application load balancer, substitute the correct variables for it, and also check if the autoscalling group is targeting the correct target group.



#### Actual Working:

We need an ECR repo first to hold the image we have created for a webserver running on nginx; therefore, we will need to create an ECR repo:

For this, you can go in the terraform environment folder, then select the region. Currently, I have only a single region that is AP-southeast-2. Inside the region, there are different environments; currently, we have only the dev environment.

Once we are inside the dev folder, run the following command:

``terraform init``

Since we only need to deploy ecr repo first, we need to use only the ecr modules:
To check what's going to be deployed, we first do the plan:
``terraform plan -target=module.ecr``

After checking the state, we can decide whether to apply; if we are satisfied, we use the below command to apply:

``terraform apply -target=module.ecr```

#### Ansible Playbook
Now that we have the ECRO repo, we need to have a Docker image with Nginx and some website content.

We are using a Dockerfile for creating an image, and we are using Ansible Playbook to push the image to the ECRO repo. [We can do it manually, but we are using Ansible so that we can later configure our playbook with our CI/CD to push the image.]

In ansible folder, you can check there are 3 folders:
1. Inventories
2. Playbook
3. Variables

The inventories consist of the environment files and the details regarding the host used for the particular environment [we can use host variables and group variables as well].
The Playbook consists of playbooks to be deployed with their respective configurations and references for the variables and environment.
The variables consist of variables for playbooks. [We can use host variables and group variables as well].

for running the Ansible playbook to push our image to ECRO repo.

Command to run the ansible playbook:

``ansible-playbook -i /ansible/inventories/development.ini /ansible/playbook/push_ecr.yml`` 
The path to the file is very important, as is checking if the path for Dockerfile is correct or not.


#### Dockerfile

We are creating a simple Docker with an Nginx server, some HTML and CSS content, and exposing ports 80 and 443 for http and https. I do not have an SSL certificate, so https will not work, but if we get SSL, we can put it in the Dockerfile and make it work on https as well.

Before moving to the ansible, we need to verify if the image is built correctly or not and the container is working correctly. For this, we can run Docker build on local:

command to build image in local:
``docker build -t nginxweb.``

command to run container on local:
``docker run -d -p 80:80 nginxweb``


#### Deploying ec2

For creating an Ec2 instance, we need to apply Terraform.

Steps to be followed:
1. Go in folder path terraform/environment/ap-southeast-2/dev
2. Run command ``terraform init``
3. Run the command ``terraform plan. This will give you all the resources that are going to be applied in our AWS account. Check if everything looks correct; if there is an issue, then resolve the Terraform issue.
4. If we are satisfied with the result, then we can run the command ``terraform apply'' This will apply changes to AWS.
5. I am storing the tf.state in the S3 bucket using the backend. tf

Once the changes are applied, we can check the EC2 in the AWS console or access it via the AWS cli.

#### Troubleshooting:

We are using userdata for installing packages and pulling the Docker image from the ECRO repository. There can be a case where our user data did not completely run. To check the logs of the userdata, you can ssh on the running EC2 instance and go to path /var/log and cat cloud-init-output.log.

***note we can use other method as well for running the docker on EC2, similar to above we can use cloud-init or the simple method will be putting dockerfile on s3 and the fetching docker file via s3 and buidling docker image on EC2 instance and running it.

Once the deployment is successful and we can verify from cloud-init-output.log that the container is running, we can view the website on http://ip_of instance. We can redirect it to a particular domain name using the application load balancer and r53. As mentioned above, I do not currently have a domain name register; I am not able to do it currently, but the code for the process is in this repo.


#### Limitations
The above deployment has limitations since I don't have a domain name register; they are as follows:

1. If we add more content to the website and create a new image, we will have to restart the EC2 instance to pickup the new image. If we had a domain name, though the EC2 instance has been restarted, we will get the new content at the same location on the internet because of routing.
2. We can have an ansible playbook to deploy a new image on a running EC2 instance as well, but the above method is preferred.

