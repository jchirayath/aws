# Create Stack for DEMO Platform

# Define SSH Key
KeyID="jacob_azure_id"
IAMInstanceProfile="ec2LaunchGroupRole"

# Assuming the VPC is Already Defined we need to get the VPC information
# Ask ADMIN for the VPC Name that is being used for DEMO
VpcName="VPC-Lab-10.11.0.0"

# Define the Template file 
CFFile="file://20-Create-EC2-instances.json"
# Test the configuration file
aws cloudformation validate-template --template-body $CFFile
if [ "$?" = "1" ]; then
	echo "Cloud Formation Template Validation failed!" 1>&2
	exit 1
fi

# Get the Default VPC ID from AWS
VpcID=`aws ec2 describe-vpcs --filter Name=tag:Name,Values=\$VpcName --query 'Vpcs[*].{id:VpcId}' --output text`
echo VpcName=$VpcName
echo VpcID=$VpcID

# Code Update - We need to define the security group
# Get Default Security Group for AZ - Picking the 1st one for now
DefaultVPCSecurityGroup=`aws ec2 describe-security-groups --filter "Name=group-name,Values=default" --query 'SecurityGroups[*].{Name:GroupId}' --output text | awk 'NR==1{print $1}'`

# Get the  Subnet IDs based on the above Defined VPC (Assuming 2 Subnets)
# Getting the 1st Subnet 
PrivateSubnetAZ1=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID" --filter "Name=tag:Name,Values=*Private*"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==1{print $1}'`
# Getting the 2nd Subnet
PrivateSubnetAZ2=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID" --filter "Name=tag:Name,Values=*Private*"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==2{print $1}'`
PublicSubnetAZ1=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID" --filter "Name=tag:Name,Values=*Public*"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==1{print $1}'`
# Getting the 2nd Subnet
PublicSubnetAZ2=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID" --filter "Name=tag:Name,Values=*Public*"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==2{print $1}'`

# Print all the Parameters we have $DEBUG
Echo "##### Defined Variables #####"
echo "VPC ID: $VpcID"
echo "VPC Default Security Group: $DefaultVPCSecurityGroup"
echo "PrivateSubnetAZ1: $PrivateSubnetAZ1"
echo "PrivateSubnetAZ2: $PrivateSubnetAZ2"
echo "PublicSubnetAZ1: $PublicSubnetAZ1"
echo "PublicSubnetAZ2: $PublicSubnetAZ2"

# Check if the above variable are blank
# Checking for only the Variable we require for the CloudFormation Script
if [ -z $VpcID ] || [ -z $DefaultVPCSecurityGroup ] || [ -z PrivateSubnetAZ1 ] || [ -z PrivateSubnetAZ2 ] ; then
	echo "\nSomething is wrong with the VPC or the SubNets !!!!"
	echo "Exiting !!!!"
	exit 1
else
	echo "Creating the Stack ....... "
	# Create the Cloud Formation Stack
	aws cloudformation create-stack \
	--stack-name EDP-EC2-Stack2 \
	--template-body $CFFile \
	--parameters \
	ParameterKey=VpcId,ParameterValue=$VpcID \
	ParameterKey=DefaultVPCSecurityGroup,ParameterValue=$DefaultVPCSecurityGroup \
	ParameterKey=IAMInstanceProfile,ParameterValue=$IAMInstanceProfile \
	ParameterKey=TargetSubnets,ParameterValue=\"$PrivateSubnetAZ1,$PrivateSubnetAZ2\" \
	ParameterKey=KeyName,ParameterValue=$KeyID \
	ParameterKey=DBName,ParameterValue=MySQLDB \
	ParameterKey=DBUser,ParameterValue=admin \
	ParameterKey=DBPassword,ParameterValue=MySQL1234 \
	ParameterKey=DBAllocatedStorage,ParameterValue=5 \
	ParameterKey=MultiAZDatabase,ParameterValue=false 
fi
