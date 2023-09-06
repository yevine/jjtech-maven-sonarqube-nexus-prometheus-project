## Install Nexus Repository Manager
- create ec2 intsnace, select linux2 OS, intance type: t2.medium and get userdata from link below. 
- open port 8081 on secuirty group
- https://github.com/awanmbandi/maven-nexus-project-eagles-batch/blob/maven-nexus-install/nexus-install.sh
- access nexus on browser with PUBLIC_IP:8081
- click on sign in on top right corner
- username is "admin" : 
- ssh into nexus server and navigate to path from step above to get password: cat /opt/nexus/sonatype-work/nexus3/admin.password
- copy default password and paste in password section on nexus and sign in
- when prompted to customise new password, use: "admin", 
- Click on disable anonymous access and then Finish.
- 
 

## Install Apache Maven
- Create a linux2 instance (ensure to not select the 2023 linux ami) with t2.micro type. 
- ssh into the instance and follow the link below for installation setup.
- install tree with command: sudo yum install tree -y
- https://github.com/awanmbandi/maven-nexus-project-eagles-batch/blob/maven-nexus-install/maven-install.md

## Maven commands
1. clone the source code from repository where it is stored.
2. cd into the cloned folder
3. cd in the javawebapp folder where the source code for the app is found prior to start running maven commands.
4. Run the following `maven`/`mvn` commands to validate/package/deploy your app artifacts remotely
   - `mvn validate`   (validate the project is correct and all necessary information is available.)
   - `mvn compile`    (compile the source code of the project and craetes a target directory)
   - `mvn test`       (run tests using a suitable unit testing framework. These tests should not require the code be packaged or deployed.)
   - `mvn package`    (take the compiled code and package it in its distributable format, such as a WAR/JAR/EAR.)
   - `mvn verify`     (run any checks to verify the package is valid and meets quality criteria.)
   - `mvn install`    (install the package into the local repository, for use as a dependency in other projects locally.)

## Install SonarQube
- Launch ec2-instance with OS: ubuntu 20.04, type:t2.medium
- Security group should allow port 9000 for inbound traffic
- https://github.com/awanmbandi/eagles-batch-devops-projects/blob/maven-nexus-sonarqube-jenkins-install/sonarqube-install.sh
- Access sonarqube on port PUBLIC_IP:9000
- click login and user username:admin and password:admin
- create new project and provide any random name. Then click setup
- Proivde name for token and generate token, select Java and then Maven.
- Copy generated command and save ina secure location.
- Navigate back to maven server and paste the command copied in previous step in the directory with pom.xml file

## Configure Nexus Repository 

Series of tutorial code snippets for use
#Maven publish tutorial steps
Publishing artifact to Nexus snapshot and release repo using maven.

1. Create a snapshot repo using nexus, or use default coming in out of the box. DEFAULT 
2. Create a release repo using nexus, or use default coming out of the box. DEFAULT
3. Create a group repo having both release, snapshot and other third party repos. or use default coming out of the box.
4. Navigate to vsCode and in the settings.cml file,
- check to ensure your username and paswword for nexus is admin:admin on line 32 & 33.
- update nexus repository urls with the current IP of nexus server on line 63 and 74 of settings.xml
- update url for sonarqube on line 86  in the settings.xml file.
- update nexus url in pom.xml file on line 57 and 61
- commit changes and push to repo
- pull chamges from within maven server
5. copy settings.xml from within maven server into .m2 directory 
- mv settings.xml ~/.m2

6. Run the following `maven`/`mvn` command to deploy jar package to a remote repo.
   - `mvn deploy`     (done in an integration or release environment, copies the final package to the remote/SNAPSHOT repository 
                      for sharing with other developers and projects.)

11. Change the version from 1.0-Snapshot to 1.1
12. Run `mvn deploy` to deploy to Snapshot Repo or `mvn clean deploy -P release`, to deploy it to Release Repo

## Maven Lifecycle Phases
- https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#a-build-lifecycle-is-made-up-of-phases


##############################

mvn clean sonar:sonar deploy \
  -Dsonar.projectKey=test-project \
  -Dsonar.host.url=http://3.145.133.93:9000 \
  -Dsonar.login=e53fbdbc2cb430e2005819e9c403aab4a192e10d


######################################
Jenkins pipeline project for jenkins-Maven-SOnarqube-Nexus-Slack
#######################################

# install docker and git in jenkins server
- sudo yum install git -y
- sudo yum install docker -y
- sudo systemctl start docker
- sudo systemctl enable docker
- sudo systemctl status docker
- sudo usermod -aG docker jenkins

# Plugin installations:
- Click on "Manage Jenkins"
- Click on "Plugin Manager"
- Click "Available"
- Search and Install the following Plugings "Install Without Restart"
   - SonarQube Scanner
   - maven integration
   - docker pipeline
   - Slack Notification
   - Prometheus metrics
   
Once all plugins are installed, select Restart Jenkins when installation is complete and no jobs are running

# Slack integration

- Create a slack channel
  - Navigate to slace > create channel > open channel and click on the drop-down next to slack name > select integration > click "add app" > 

# Global tools configuration:
Click on Manage Jenkins --> Global Tool Configuration

JDK --> Add JDK --> Make sure Install automatically is enabled

JDKSetup!

- Click on Add installer
- Select Extract .zip/.tar.gz --> Fill the below values
  - Name: localJdk
  - Download URL for binary archive: https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
  - Subdirectory of extracted archive: jdk-11.0.1

- Maven --> Add Maven --> Make sure Install automatically is enabled --> Install from Apache --> Fill the below values

  - Name: localMaven
  - Version: Keep the default version as it is

# Credentials setup(SonarQube, Nexus, Ansible, Slack):
Click on Manage Jenkins --> Manage Credentials --> Global credentials (unrestricted) --> Add Credentials

## SonarQube secret token (sonarqube-token)
- Kind: Secret text : Generating SonarQube secret token. Login to your SonarQube server (http://sonarserver-public-ip:9000, with the credentials username: admin & password: admin) - Click on profile --> My Account --> Security --> Tokens - Generate Tokens: Fill jenkins-token - Click on Generate - Copy the token
- Secret: Fill the secret token value that we have created on the SonarQube server
- ID: sonarqube-token
- Description: sonarqube-token
- Click on Create

## Nexus username & password (nexus-credentials)
- Kind: Username with password
- Username: admin
- Enable Treat username as secret
- Password: admin
- ID: nexus-credentials
- Description: nexus-credentials
- Click on Create

## Ansible deployment server username & password (ansible-deploy-server-credentials)
- Kind: Username with password
- Username: ansadmin
- Enable Treat username as secret
- Password: ansadmin
- ID: ansible-deploy-server-credentials
- Description: ansible-deploy-server-credentials
- Click on Create

## Slack secret token (slack-token)
- Kind: Secret text
- Secret: Place the Integration Token Credential ID (Note: Generated from slack setup)
- ID: slack-token
- Description: slack-token
- Click on Create

## Configure system:
1)  - Click on Manage Jenkins --> Systems Configuration
    - Go to section SonarQube servers --> **Add SonarQube **
    - Name: **SonarQube**
    - Server URL: http://REPLACE-WITH-SONARQUBE-SERVER-PRIVATE-IP:9000          (replace SonarQube privat IP here)
    - Server authentication token > select sonarqube credential configured in previous step
    - Click on Save    

2)  - Click on Manage Jenkins --> Configure System
    - Go to section Prometheus
    - Collecting metrics period in seconds: **15**
    - Click on Save

3)  - Click on Manage Jenkins --> Configure System
    - Go to section Slack
    - Use new team subdomain & integration token credentials created in the above slack joining step
    - Workspace: **Replace with Team Subdomain value** (created above)
    - Credentials: select the slack-token credentials (created above) 
    - Default channel / member id: #general
    - Test connection: success
    - Click on Save  

# SonarQube setup
Copy your SonarQube Public IP Address and paste on the browser = ExternalIP:9000

1. Jenkins webhook in SonarQube:
- Login into SonarQube
- Go to Administration --> Configuration --> Webhooks --> Click on Create
Name: Jenkins-Webhook
URL: http://REPLACE-WITH-JENKINS-PRIVATE-IP:8080/sonarqube-webhook/ (replace Jenkins private IP here)
- Click on Create

# Nexus setup
Copy your Nexus Public IP Address and paste on the browser = http:://NexusServerExternalIP:8081

1. Setting up password:
- SSH into Nexus server
- Execute sudo cat /opt/nexus/sonatype-work/nexus3/admin.password
- Copy the default password
- Now login into Nexus console with the username: admin & password (copied from the SSH above)
- Once signed in fill the below details in the setup wizard
- New password: admin
- Confirm password: admin
- Configure anonymus access: Select Disable anonymus access
- Click on Finish

2. Creating a new maven repository for project:
- Once login to the Nexus server, click on Settings icon --> Repository --> Repositories
- Click on Create repository
- Select maven2(group)
- Name: maven_project
- Scroll-down to Group section & select all the available repositories (maven-snapshots, maven-public, maven-releases, maven-central) as members Hint: You can select one repo at a time and click on > symbol to add the repo as group member.
- Once all the repositories are added to the group, click on Create repository

# Integration with ansible, node exporter and deployment to dev, stage and prod stages
1. install ansible on jenkins master node. Get script from here **https://github.com/cvamsikrishna11/devops-fully-automated/blob/installations/jenkins-maven-ansible-setup.sh**

2. EC2 (Dev/Stage/Prod)

- Create 3 Amazon Linux 2 VM instances
- Instance type: t2.micro
- Security Group (Open): 8080, 9100 and 22 to 0.0.0.0/0
- Key pair: Select or create a new keypair
- User data (Copy the following user data): https://github.com/cvamsikrishna11/devops-fully-automated/blob/- installations/deployment-servers-setup.sh
- Launch Instance
- After launching these servers, attach a tag as Key=Environment, value=dev/stage/prod ( out of 3, each 1 instance could be tagged as one env)

2. Configure ansible hosts
- navigate to jenkis server where ansible master is installed
- cd /etc/ansible
- sudo nano hosts
- add config for [dev] [stage] and [prod] and paste private of servers respectively
e.g 
[dev]
172.x.x.x ansible_user=ansadmin ansible_password=ansadmin

[stage]
172.x.x.x ansible_user=ansadmin ansible_password=ansadmin

[prod]
172.x.x.x ansible_user=ansadmin ansible_password=ansadmin

3. Prometheus
- Create Amazon Linux 2 VM instance and call it "Prometheus"
- Instance type: t2.micro
- Security Group (Open): 9090 and 22 to 0.0.0.0/0
- Key pair: Select or create a new keypair
- Attach Jenkins server with IAM role having "AmazonEC2ReadOnlyAccess"
- User data (Copy the following user data): https://github.com/cvamsikrishna11/devops-fully-automated/blob/installations/prometheus-setup.sh
- Launch Instance

4. Grafana
- Create an Ubuntu 20.04 VM instance and call it "Grafana"
- Instance type: t2.micro
- Security Group (Open): 3000 and 22 to 0.0.0.0/0
- Key pair: Select or create a new keypair
- User data (Copy the following user data): https://github.com/cvamsikrishna11/devops-fully-automated/blob/installations/grafana-setup.sh
- Launch Instance

5. Slack
- Join the slack channel https://join.slack.com/t/devopsfullyau-r0x2686/shared_invite/- zt-1nzxt7e9z-ChDASWBOysUpa3tH5gi95A
- Join into the channel "#team-devops"
- Generate Team Subdomain & Integration Token Credential ID (workspace --> channel --> drop-down --> - integrations --> Add an App --> Jenkins CI --> Click on Install/View --> Configuration --> Add to Slack --> Select Channel #team-devops --> Store Team subdomain & Integration Token Credential ID which can be - used later on)

# Prometheus setup
Copy your Prometheus Public IP Address and paste on the browser = http:://PrometheusServerExternalIP:9090

Note: Prometheus setup is also full automated, so just verifying the health of servers are required

Checking targets health:
- Once prometheus accessed --> Status --> Targets (for the health checkup)
- Once prometheus accessed --> Status --> Configuration (for the config file verification)

# Grafana setup
Copy your Grafana Public IP Address and paste on the browser = http:://GrafanaServerExternalIP:3000

1. Setting up username & password:
- Once the UI Opens pass the following username and password
   - Username: admin
   - Password: admin
   - New Username: admin
   - New Password: admin
   - Save and Continue

2. Adding Datasource as Prometheus:
- Once you get into Grafana, follow the below steps to Import a Dashboard into Grafana to visualize your Infrastructure/App Metrics
    - Click on "Configuration/Settings" on your left
    - Click on "Data Sources"
    - Click on "Add Data Source"
    - Select Prometheus
    - Underneath HTTP URL: http://PrometheusPrivateIPaddress:9090
    - Click on "SAVE and TEST"

3. Create NodeExporter Dashboard:
- Navigate to "Create" on your left (the + sign)
      - Click on "Import"
      - Download the required NodeExporter dashboard JSON in the link https://grafana.com/api/dashboards/1860/revisions/27/download ( #Ref: https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
      - Click on Upload JSON file and upload the file downloaded in the above step -
      - Scrol down to "Prometheus" and select the "Data Source" you defined ealier which is "Prometheus"
      - CLICK on "Import"
      - Save
- Refresh your Grafana Dashbaord
    - Click on the "Drop Down" for "Host" and select any of the "Instances(IP)"

4. Create Jenkins Performance and Health Overview Dashboard:
- Navigate to "Create" on your left (the + sign)
     - Click on "Import"
     - Copy the following link: https://grafana.com/grafana/dashboards/9964 ( #Ref: https://grafana.com/grafana/dashboards/9964-jenkins-performance-and-health-overview/)
     - Paste the above link where you have "Import Via Grafana.com"
     - Click on Load (The one right beside the link you just pasted)
     - Scrol down to "Prometheus" and select the "Data Source" you defined ealier which is "Prometheus"
     - CLICK on "Import"
     - Save
Refresh your Grafana Dashbaord
Click on the "Drop Down" for "Host" and select any of the "Instances(IP)"