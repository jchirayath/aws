# Create the CloudFormation Stack
#
# Define the Template file 
CFFile="file://12-Create-VPC.json"

# Define the Changeable Variables
VPCName="VPC-Lab-10.11.0.0"
PrivateSubnetAZ1="Lab1-Private-az1-10.11.1.0"
PrivateSubnetAZ2="Lab1-Private-az2-10.11.2.0"
PublicSubnetAZ1="Lab1-Public-az1-10.11.128.0"
PublicSubnetAZ2="Lab1-Public-az2-10.11.129.0"

# Due to CIDR notation and "." in the string pleas update the section below for
# Will fix when I have a chance
VPCCIDR="10.11.0.0/16"
PrivateCidrBlock1="10.11.1.0/24"
PrivateCidrBlock2="10.11.2.0/24"
PublicCidrBlock1="10.11.128.0/24"
PublicCidrBlock2="10.11.129.0/24"

# Define or Extract the Available AZ's for this Region
#AZ1="us-west-1b"
#AZ2="us-west-1c"
AZ1=`aws ec2 describe-availability-zones --output text | awk 'NR==1{print $4}'`
AZ2=`aws ec2 describe-availability-zones --output text | awk 'NR==2{print $4}'`

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
ParameterKey=TagValue1,ParameterValue=MyVPC \
ParameterKey=TagValue2,ParameterValue=DEV \
ParameterKey=VPCName,ParameterValue=$VPCName \
ParameterKey=CIDR,ParameterValue=$VPCCIDR \
ParameterKey=PrivateSubnet1AZName,ParameterValue=$PrivateSubnetAZ1 \
ParameterKey=PrivateSubnet2AZName,ParameterValue=$PrivateSubnetAZ2 \
ParameterKey=PrivateCidrBlock1,ParameterValue=$PrivateCidrBlock1 \
ParameterKey=PrivateCidrBlock2,ParameterValue=$PrivateCidrBlock2 \
ParameterKey=PrivateSubnet1AZ,ParameterValue=$AZ1 \
ParameterKey=PrivateSubnet2AZ,ParameterValue=$AZ2 \
ParameterKey=PublicSubnet1AZName,ParameterValue=$PublicSubnetAZ1 \
ParameterKey=PublicSubnet2AZName,ParameterValue=$PublicSubnetAZ2 \
ParameterKey=PublicCidrBlock1,ParameterValue=$PublicCidrBlock1 \
ParameterKey=PublicCidrBlock2,ParameterValue=$PublicCidrBlock2 \
ParameterKey=PublicSubnet1AZ,ParameterValue=$AZ1 \
ParameterKey=PublicSubnet2AZ,ParameterValue=$AZ2 
