# Install Prometheus
- Create an ec2 instance with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9090
- Create two ec2 instance  for app servers with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9100
- ssh into prometheus server 
- install git by running sudo <apt install git -y>
- clone prometheus repo from within server git clone https://github.com/anselmenumbisia/maven-sonarqube-nexus-project.git
- cd /home/ubuntu/maven-sonarqube-nexus-project/prometheus
- install prometheus by running < sh install-prometheus.sh >
- check that prometheus service is running < sudo systemctl status prometheus.service>

- ssh into app server 
- Instal git and clone the github repo with source code
- install node exporter <sh install-node-exporter.sh>

- navigate to prometheus server\
- cd /etc/prometheus/
- sudo nano prometheus.yml
- add private ip address of app server with node exporter installed and paste in - targets section like this <private_ip:9100>
- use ctrl x y enter to save and exit the nano editor
- restart prometheus service <sudo systemctl restart prometheus.service>

# Configure Service discovery for Prometheus
- create two new ec2-instance for prometheus service discovery, OS=Ubuntu, instance_type=t2.nano
- Associate IAM role for ec2 to the prometheus server 
- run < sudo nano /etc/prometheus/prometheus.yml >
- Update file with config from prometheus_serviveDiscovery.yml from clone folder
- restart prometheus service < sudo systemctl restart prometheus.service >
- verify targets in prometheus to confirm that prometheus can now discover the newly added servers

# Install Grafana
- Edit inbound security group rule for prometheus to allow traffic on port 3000
- ssh into prometheus server 
- cd /home/ubuntu/maven-sonarqube-nexus-project/prometheus
- install prometheus by running < sh install-grafana.sh >
- check that grafana service is running < sudo systemctl status grafana-server.service >
- opena  new tab on browser and enter < public_ip:3000 > to access grafana
- default username and password is < admin >
- Add a data source for grafana and point to prometheus server url

##
- Grab grafana dashboards from here https://grafana.com/grafana/dashboards/ 
- grab this dashboard id < https://grafana.com/grafana/dashboards/11074-node-exporter-for-prometheus-dashboard-en-v20201010/ >  **ID: 11074**

# Install prometheus alertmanager
- ssh into prometheus server
- edit inbound sg to allow traffic on port 9093
- install alertmanager < sh install-alertmanager.sh >
- access alertmanager on the browser using < public_ip:9093 >
- Navigate to < https://myaccount.google.com/ > 
- https://myaccount.google.com/
- configure 2 step verification for your google account? 
- search for < app password >
- Create an app password and paste the password to  ** auth_password ** section in your alertmanager file
- update alertmanager file in /etc/alertmanager/ with your own configuration for email sender and   recipient by running < sudo nano /etc/alertmanager/alertmanager.yml >
- restart the alermanager service < sudo systemctl restart alertmanager >


## Test alert rules
- ssh into any apps server
- install stress < sudo apt-get install stress >
- The run < stress --cpu 4 --timeout 300s >


