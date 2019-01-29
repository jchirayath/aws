# Create the IAM Role for the EC2 Launch group
#
# Define the Template file 
RoleName="ec2LaunchGroupRole"
RolePolicy="file://10-RoleNamePolicy.json"
RoleDesc="RolewithEC2S3RDSandRoute53Access"
#
# Create the Role
aws iam create-role --role-name $RoleName --assume-role-policy-document $RolePolicy --description $RoleDesc
# Now we have to create an Instance Profile for this role (match the RoleName)
aws iam create-instance-profile --instance-profile-name $RoleName
# Now we have to attach the Instance-profile to the Role
aws iam add-role-to-instance-profile --role-name $RoleName --instance-profile-name $RoleName
# Attach a custom policy to that role
aws iam put-role-policy --role-name $RoleName --policy-name CustomPolicy --policy-document $RolePolicy
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
