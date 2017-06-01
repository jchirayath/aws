# Create the CloudFormation Stack
#
# Define the Template file 
CFFile="file://3-EC2-template.json"
#
# Test the configuration file
aws cloudformation validate-template --template-body $CFFile
if [ "$?" = "1" ]; then
	echo "Cloud Formation Template Validation failed!" 1>&2
	exit 1
fi
# Get the Active VPC ID from AWS
VpcID=`aws ec2 describe-vpcs --filter 'Name=tag:Name,Values=us-west-2-vpc' --query 'Vpcs[*].{id:VpcId}' --output text`
VpcID="vpc-5f3db23b"
# Get the Active Subnet ID based on Names form AWS
#SUBNETS=
#
echo $VpcID
#echo $SUBNETS
#
# Create the Cloud Formation Stack
aws cloudformation create-stack \
--stack-name WordPressPlus-Stack4444 \
--template-body $CFFile \
--parameters \
ParameterKey=VpcId,ParameterValue=$VpcID \
ParameterKey=Subnets,ParameterValue=\"subnet-07eb9d5f,subnet-39d68c5d\" \
ParameterKey=KeyName,ParameterValue=azured_id \
ParameterKey=DBName,ParameterValue=MySQLDB \
ParameterKey=DBUser,ParameterValue=admin \
ParameterKey=DBPassword,ParameterValue=MySQL264 \
ParameterKey=DBAllocatedStorage,ParameterValue=5 \
ParameterKey=MultiAZDatabase,ParameterValue=false \
ParameterKey=WebServerCapacity,ParameterValue=1 
