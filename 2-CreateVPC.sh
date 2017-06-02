# Create the CloudFormation Stack
#
# Define the Template file 
CFFile="file://2-VPC-template.json"
#
# Test the configuration file
aws cloudformation validate-template --template-body $CFFile
if [ "$?" = "1" ]; then
	echo "Cloud Formation Template Validation failed!" 1>&2
	exit 1
fi
# Create the Cloud Formation Stack
aws cloudformation create-stack \
--stack-name us-west-2-stack \
--template-body $CFFile \
--parameters \
ParameterKey=TagValue1,ParameterValue=MyProject \
ParameterKey=TagValue2,ParameterValue=DEV \
ParameterKey=KeyName,ParameterValue=azure_id \
ParameterKey=VPCName,ParameterValue=us-west-2-vpc \
ParameterKey=CIDR,ParameterValue=10.0.0.0/16 \
ParameterKey=PrivateSubnet1AZName,ParameterValue=Private-us-west-1b \
ParameterKey=PrivateSubnet2AZName,ParameterValue=Private-us-west-1c \
ParameterKey=PrivateCidrBlock1,ParameterValue=10.0.1.0/24 \
ParameterKey=PrivateCidrBlock2,ParameterValue=10.0.2.0/24 \
ParameterKey=PrivateSubnet1AZ,ParameterValue=us-west-1b \
ParameterKey=PrivateSubnet2AZ,ParameterValue=us-west-1c \
ParameterKey=PublicSubnet1AZName,ParameterValue=Public-us-west-1b \
ParameterKey=PublicSubnet2AZName,ParameterValue=Public-us-west-1c \
ParameterKey=PublicCidrBlock1,ParameterValue=10.0.3.0/24 \
ParameterKey=PublicCidrBlock2,ParameterValue=10.0.4.0/24 \
ParameterKey=PublicSubnet1AZ,ParameterValue=us-west-1b \
ParameterKey=PublicSubnet2AZ,ParameterValue=us-west-1c 
