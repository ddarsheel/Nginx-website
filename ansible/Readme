Now we have the ecr repo we need to have a dockerimage image with Nginx and some website content.

we are using a Dockerfile for creating an image and we are using ansible playbook to push the image to ecr repo. [we can do the manually, but we are using ansible so that we can later configure our playbook with our ci/cd to push the image]

In ansible folder you can check there are 3 folder:

Inventories
Playbook
Variables
The Inventories consist of the environement files and the details regarding the host used for the particular environemnt[ we can use host vars and group vars as well] The Playbook consist of playbooks to be deployed with their respective configuations and reference for the vars and environment. The Variables consist of variable for playbooks.[ we can use host vars and group vars as well]

for running the Ansible playbook to push our image to ecr repo.

Command to run the ansible playbook:

``ansible-playbook -i /ansible/inventories/development.ini /ansible/playbook/push_ecr.yml`` [path to the file is very important, also checking if the path for dockerfile is correct or not
