# Create the CloudFormation Stack
#
# Define the Template file 
CFFile="file://3-EC2-template.json"
# Define AZ
AZ1="us-west-1b"
AZ2="us-west-1c"
# Define SSH Key
KeyID="azure_id"
IAMInstanceProfile="ec2LaunchGroupRole"
#
# Test the configuration file
aws cloudformation validate-template --template-body $CFFile
if [ "$?" = "1" ]; then
	echo "Cloud Formation Template Validation failed!" 1>&2
	exit 1
fi
# Get the Active VPC ID from AWS
VpcID=`aws ec2 describe-vpcs --filter 'Name=tag:Name,Values=MyVPC' --query 'Vpcs[*].{id:VpcId}' --output text`
#VpcID="vpc-5f3db23b"
# Get Default Security Group for AZ
DefaultVPCSecurityGroup=`aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$VpcID" --output text | awk 'NR==1{print $6}'`
# Get the Active Subnet ID based on Names form AWS
PrivateSubnetAZ1=`aws ec2 describe-subnets --filter 'Name=tag:Name,Values=PrivateSubnetAZ1' --query 'Subnets[*].{id:SubnetId}' --output text`
PrivateSubnetAZ2=`aws ec2 describe-subnets --filter 'Name=tag:Name,Values=PrivateSubnetAZ2' --query 'Subnets[*].{id:SubnetId}' --output text`
PublicSubnetAZ1=`aws ec2 describe-subnets --filter 'Name=tag:Name,Values=PublicSubnetAZ1' --query 'Subnets[*].{id:SubnetId}' --output text`
PublicSubnetAZ2=`aws ec2 describe-subnets --filter 'Name=tag:Name,Values=PublicSubnetAZ2' --query 'Subnets[*].{id:SubnetId}' --output text`
# Print the above values
echo "VPC ID: $VpcID"
echo "VPC Default Security Group: $VPCSecurityGroup"
echo "PrivateSubnetAZ1: $PrivateSubnetAZ1"
echo "PrivateSubnetAZ2: $PrivateSubnetAZ2"
echo "PublicSubnetAZ1: $PublicSubnetAZ1"
echo "PublicSubnetAZ2: $PublicSubnetAZ2"
# Check if the above variable are blank
if [ -z $VpcID ] || [ -z $DefaultVPCSecurityGroup ] || [ -z PrivateSubnetAZ1 ] || [ -z PrivateSubnetAZ2 ] || [ -z PublicSubnetAZ1 ] || [ -z PublicSubnetAZ2 ]; then
	echo "\nSomething is wrong with the VPC or the SubNets !!!!"
	echo "Exiting !!!!"
	exit 1
else
	echo "Creating the Stack ....... "
	# Create the Cloud Formation Stack
	aws cloudformation create-stack \
	--stack-name ELB-WP-EC2-Stack \
	--template-body $CFFile \
	--parameters \
	ParameterKey=VpcId,ParameterValue=$VpcID \
	ParameterKey=DefaultVPCSecurityGroup,ParameterValue=$DefaultVPCSecurityGroup \
	ParameterKey=IAMInstanceProfile,ParameterValue=$IAMInstanceProfile \
	ParameterKey=PrivateSubnets,ParameterValue=\"$PrivateSubnetAZ1,$PrivateSubnetAZ2\" \
	ParameterKey=PublicSubnets,ParameterValue=\"$PublicSubnetAZ1,$PublicSubnetAZ2\" \
	ParameterKey=KeyName,ParameterValue=$KeyID \
	ParameterKey=DBName,ParameterValue=MySQLDB \
	ParameterKey=DBUser,ParameterValue=admin \
	ParameterKey=DBPassword,ParameterValue=MySQL264 \
	ParameterKey=DBAllocatedStorage,ParameterValue=5 \
	ParameterKey=MultiAZDatabase,ParameterValue=false \
	ParameterKey=WebServerCapacity,ParameterValue=2 
fi
