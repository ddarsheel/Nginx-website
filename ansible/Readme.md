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
