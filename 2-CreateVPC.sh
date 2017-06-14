# Create the CloudFormation Stack
#
# Define the Template file 
CFFile="file://2-VPC-template.json"
# Define AZ
#AZ1="us-west-1b"
#AZ2="us-west-1c"
AZ1=`aws ec2 describe-availability-zones --output text | awk 'NR==1{print $4}'`
AZ2=`aws ec2 describe-availability-zones --output text | awk 'NR==2{print $4}'`
#
# Test the configuration file
aws cloudformation validate-template --template-body $CFFile
if [ "$?" = "1" ]; then
	echo "Cloud Formation Template Validation failed!" 1>&2
	exit 1
fi
# Create the Cloud Formation Stack
aws cloudformation create-stack \
--stack-name MyVPC-Stack \
--template-body $CFFile \
--parameters \
ParameterKey=TagValue1,ParameterValue=MyProject \
ParameterKey=TagValue2,ParameterValue=DEV \
ParameterKey=VPCName,ParameterValue=MyVPC \
ParameterKey=CIDR,ParameterValue=10.0.0.0/16 \
ParameterKey=PrivateSubnet1AZName,ParameterValue=PrivateSubnetAZ1 \
ParameterKey=PrivateSubnet2AZName,ParameterValue=PrivateSubnetAZ2 \
ParameterKey=PrivateCidrBlock1,ParameterValue=10.0.1.0/24 \
ParameterKey=PrivateCidrBlock2,ParameterValue=10.0.2.0/24 \
ParameterKey=PrivateSubnet1AZ,ParameterValue=$AZ1 \
ParameterKey=PrivateSubnet2AZ,ParameterValue=$AZ2 \
ParameterKey=PublicSubnet1AZName,ParameterValue=PublicSubnetAZ1 \
ParameterKey=PublicSubnet2AZName,ParameterValue=PublicSubnetAZ2 \
ParameterKey=PublicCidrBlock1,ParameterValue=10.0.3.0/24 \
ParameterKey=PublicCidrBlock2,ParameterValue=10.0.4.0/24 \
ParameterKey=PublicSubnet1AZ,ParameterValue=$AZ1 \
ParameterKey=PublicSubnet2AZ,ParameterValue=$AZ2 
