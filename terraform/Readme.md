We need an ECR repo first to hold the image we have created for a webserver running on nginx; therefore, we will need to create an ECR repo:

For this, you can go in the terraform environment folder, then select the region. Currently, I have only a single region that is AP-southeast-2. Inside the region, there are different environments; currently, we have only the dev environment.

Once we are inside the dev folder, run the following command:

``terraform init``

Since we only need to deploy ecr repo first, we need to use only the ecr modules:
To check what's going to be deployed, we first do the plan:
``terraform plan -target=module.ecr``

After checking the state, we can decide whether to apply; if we are satisfied, we use the below command to apply:

``terraform apply -target=module.ecr``

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
