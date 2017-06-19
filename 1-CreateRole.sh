# Create the IAM Role for the EC2 Launch group
#
# Define the Template file 
RoleName="ec2LaunchGroupRole"
RolePolicy="file://1-RoleNamePolicy.json"
RoleDesc="RolewithEC2S3RDSandRoute53Access"
CFFile="file://1-CustomPolicy.json"
#
# Create the Role
aws iam create-role --role-name $RoleName --assume-role-policy-document $RolePolicy --description $RoleDesc
# Attach a custom policy to that role
aws iam put-role-policy --role-name $RoleName --policy-name CustomPolicy --policy-document $CFFile
# Attach the standard AWS policies
aws iam attach-role-policy \
	--policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess \
	--role-name $RoleName
#	
aws iam attach-role-policy \
	--policy-arn arn:aws:iam::aws:policy/AmazonSSMFullAccess \
	--role-name $RoleName
#	
aws iam attach-role-policy \
	--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess \
	--role-name $RoleName
#	
aws iam attach-role-policy \
	--policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess \
	--role-name $RoleName