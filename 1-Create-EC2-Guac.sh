# Create Stack for AWS, Wordpress, Guacamole
#
# Define the Template file 
CFFile="file://1-Create-EC2-Guac.json"
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
# Get the Default VPC ID from AWS
VpcID=`aws ec2 describe-vpcs --filter 'Name=isDefault,Values=true' --query 'Vpcs[*].{id:VpcId}' --output text`
# Get Default Security Group for AZ
DefaultVPCSecurityGroup=`aws ec2 describe-security-groups --filter "Name=group-name,Values=default" --query 'SecurityGroups[*].{Name:GroupId}' --output text`
# Get the  Subnet ID based on the above Default VPC
PublicSubnetAZ1=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==1{print $1}'`
PublicSubnetAZ2=`aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcID"  --query "Subnets[*].{id:SubnetId}" --output text | awk 'NR==2{print $1}'`
echo "VPC ID: $VpcID"
echo "VPC Default Security Group: $DefaultVPCSecurityGroup"
echo "PublicSubnetAZ: $PublicSubnetAZ"
# Check if the above variable are blank
if [ -z $VpcID ] || [ -z $DefaultVPCSecurityGroup ] || [ -z PrivateSubnetAZ1 ] || [ -z PrivateSubnetAZ2 ] ; then
	echo "\nSomething is wrong with the VPC or the SubNets !!!!"
	echo "Exiting !!!!"
	exit 1
else
	echo "Creating the Stack ....... "
	# Create the Cloud Formation Stack
	aws cloudformation create-stack \
	--stack-name Default-WP-Guac-Stack \
	--template-body $CFFile \
	--parameters \
	ParameterKey=VpcId,ParameterValue=$VpcID \
	ParameterKey=DefaultVPCSecurityGroup,ParameterValue=$DefaultVPCSecurityGroup \
	ParameterKey=IAMInstanceProfile,ParameterValue=$IAMInstanceProfile \
	ParameterKey=PublicSubnets,ParameterValue=\"$PublicSubnetAZ1,$PublicSubnetAZ2\" \
	ParameterKey=KeyName,ParameterValue=$KeyID \
	ParameterKey=DBName,ParameterValue=MySQLDB \
	ParameterKey=DBUser,ParameterValue=admin \
	ParameterKey=DBPassword,ParameterValue=MySQL264 \
	ParameterKey=DBAllocatedStorage,ParameterValue=5 \
	ParameterKey=MultiAZDatabase,ParameterValue=false 
fi
