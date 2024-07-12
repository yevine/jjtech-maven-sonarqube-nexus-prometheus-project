# (Using SSH)

## Pre-requisites:

- Jenkins Master is already setup and running
- Create a new EC2 instance for Slave

Steps involved:
1. Setup new EC2 instance for slave
2. Create SSH keys in jenkins master and upload public keys from master to slave node.
3. verify ssh connection from master to slave
4. Register slave node in Jenkins master
5. Run build jobs in Jenkins slave

############################################################################################

## in the Jenkins Agent

- Install Java
```yum update -y ```

and then 

## Install amazon linux extras
```amazon-linux-extras install java-openjdk11 -y```


## Navigate to jenkins Master servers and Create SSH keys by executing below commands:
<span style="color:red;">Note:</span> Press enter key  on keyboard for all the prompts until you regain control of your terminal

##### Switch user to root
```bash
sudo su root
```
and then run

```ssh-keygen -t rsa -m PEM```

## Copy private and public keys from jenkins master node created in previous step and save in notepad for future use

```cat ~/.ssh/id_rsa```

```cat ~/.ssh/id_rsa.pub```

# Navigate to Jenkins app online:

- once logged in, click on manage jenkins, manage nodes.

- Click on new node. give it a **name** and check **permanent agent**.
- provide name and number of executors as 1. enter **/home/jenkins** as remote directory.
- provide name to label e.g **agent1**
- select launch method as **Launch slaves nodes via SSH**.
- enter Slave node ip address as Host (preferably private IP).

- for credentials. click on the drop down symbol on add, then jenkins 
- select kind as **SSH username with private key**. enter **any name** for **ID**. Provide description, enter username as **root** , check section for **Private Key**, click on **Add** and provide private key copied from agent node in previous step.
- under **Host Key Verification Strategy**, Select **Non verification strategy**
  
- **Navigate back to the agent server via ssh and update the **authorizationkey** file by adding the public key copied earlier just right under the existing config**
  
  ```
  vi ~/.ssh/authorized_keys
  ```

###############################################################################################################

ENABLE GITHUB WEBHOOK

- Sing in to your gu=ithub account
- Navigate to the repository that contains your source code
- Go to settings >> Webhooks >> add webhook
- In Payload URL section, enter http://JENKINS_IP:8080/github-webhook/
- content type should be "application/json"
- ensure "just push event" is checked
- Add webhook
- Verify connection is established by agreen tick







