** Install Prometheus
- Create an ec2 instance with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9090
- Create two ec2 instance  for app servers with Ubuntu 20.04 ami and t2.micro instance-type, allow inbond traffic on 9091
- ssh into prometheus server 
- install git by running sudo <apt install git -y>
- clone prometheus repo from within server git clone https://github.com/anselmenumbisia/maven-sonarqube-nexus-project.git
- cd /home/ubuntu/maven-sonarqube-nexus-project/prometheus/installationsls
- install prometheus by running <sh install-prometheus>



