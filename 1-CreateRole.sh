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
aws iam create-role --role-name LabEC2Role --description "RolewithEC2S3RDSandRoute53Access" --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"ec2.amazonaws.com\"]},\"Action\":[\"sts:AssumeRole\"]}]}"
# Now we have to create an Instance Profile for this role (match the RoleName)
aws iam create-instance-profile --instance-profile-name $RoleName
aws iam create-instance-profile --instance-profile-name LabEC2InstanceProfile
# Now we have to attach the Instance-profile to the Role
aws iam add-role-to-instance-profile --role-name $RoleName --instance-profile-name $RoleName
aws iam add-role-to-instance-profile --role-name LabEC2InstanceProfile --instance-profile-name $RoleName

aws iam put-role-policy --role-name $RoleName --policy-name CustomPolicy --policy-document $CFFile
# Attach the standard AWS policies
aws iam attach-role-policy \
	--policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess \
	--role-name $RoleName
	aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess --role-name LabEC2Role

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
