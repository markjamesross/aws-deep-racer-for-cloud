#! /bin/bash
#Metadata Variables
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
echo Instance ID $INSTANCE_ID
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo Region $AZ
#Fixup Host/Domain
DOMAIN=$(cat /etc/resolv.conf | grep search | awk '{print $2}')
echo $DOMAIN
IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4)
echo "$IP $INSTANCE_ID.$DOMAIN  $INSTANCE_ID" | sudo tee --append /etc/hosts
sudo hostnamectl set-hostname --static $INSTANCE_ID
echo "preserve_hostname: true" | sudo tee --append /etc/cloud/cloud.cfg
#Install apps
sudo apt-get install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
#download and run deep racer for cloud code
git clone https://github.com/aws-deepracer-community/deepracer-for-cloud.git
sed -i 's/DR_UPLOAD_S3_BUCKET=<AWS_DR_BUCKET>/DR_UPLOAD_S3_BUCKET=${s3_bucket_upload}/' deepracer-for-cloud/defaults/template-system.env
sed -i 's/DR_LOCAL_S3_BUCKET=bucket/DR_LOCAL_S3_BUCKET=${s3_bucket_local}/' deepracer-for-cloud/defaults/template-system.env
cd deepracer-for-cloud && ./bin/prepare.sh
