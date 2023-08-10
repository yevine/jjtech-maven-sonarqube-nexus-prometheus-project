** Install Prometheus
- Create an ec2 instance with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9090
- Create two ec2 instance  for app servers with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9100
- ssh into prometheus server 
- install git by running sudo <apt install git -y>
- clone prometheus repo from within server git clone https://github.com/anselmenumbisia/maven-sonarqube-nexus-project.git
- cd /home/ubuntu/maven-sonarqube-nexus-project/prometheus/installationsls
- install prometheus by running <sh install-prometheus>
- check that prometheus service is running <sudo systemctl status prometheus.service>

- ssh into app server 
- Instal git and clone the github repo with source code
- install node exporter <sh install-node-exporter>

- navigate to prometheus server\
- cd /etc/prometheus/
- sudo nano prometheus.yml
- add private ip address of app server with node exporter installed and paste in - targets section like this <private_ip:9100>
- use ctrl x y enter to save and exit the nano editor
- restart prometheus service <sudo systemctl restart prometheus.service>
- 



