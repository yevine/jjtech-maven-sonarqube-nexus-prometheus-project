# Create system-user for alertmanager
sudo useradd -M -r -s /bin/false alertmanager

# Create the /etc/alertmanager directory
sudo mkdir /etc/alertmanager

# Download the alertmanager bnary from prometheus website <https://prometheus.io/download/#alertmanager>

wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz

# Extract the archive file
tar -xvf alertmanager-0.25.0.linux-amd64.tar.gz

# move binaries
# cd alertmanager-0.25.0.linux-amd64
sudo mv alertmanager-0.25.0.linux-amd64/alertmanager /usr/local/bin/
sudo mv alertmanager-0.25.0.linux-amd64/amtool /usr/local/bin/

# Remove alertmanaget archive file
sudo rm -rf alertmanager-0.25.0.linux-amd64 alertmanager-0.25.0.linux-amd64.tar.gz

# set ownership of the binaries
sudo chown -R alertmanager:alertmanager /etc/alertmanager/
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

# Move alertmanahger configuration file into /etc/alertmanager directory
sudo cp alertmanager.yml /etc/alertmanager/alertmanager.yml
sudo cp alertmanager-rules.yml /etc/prometheus/alertmanager-rules.yml

# Copy alertmanager system file to /etc/systemd directory
sudo cp alertmanager.service /etc/systemd/system/alertmanager.service

# Reload systemd, and start alertmanager service
sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager