#aws ec2 import-key-pair --key-name azure_id --public-key-material AAAAB3NzaC1yc2EAAAADAQABAAABAQCrpGMtBwF/BJ5XjBrNm2DR0sl/rvJ4YbjAIFl3GtW67VELv6sIALnmEmdTwrWB1euNlOBl/rUgI9GdXh1NwiIvYqiZACxwC58pUIjB8yQItt6RhmhRFtSTsM6FkWiPCdCpbrxheAYnj0+7j/rvc+ljouOk+XVwHCx2KWzF5vQTjPK2bcPTQJg4JkQlmUAwHHqhRKXyp+mHcC8T5fYTYZaoAs1o5yc9JCHe4TynHyTFisNaHMlOzagy76XCYmU1sMaIH5yuXxlzbmaECfGPsKkhDtuIxxiRZhggQomYZ/YGuoDCS41I4agB7pdqZqrF4FkHMOYdv+yi4vqdeM45VrNB
#aws ec2 import-key-pair --key-name azure_id --public-key-material ~/.ssh/azure_id.pub
# This worked 
aws ec2 import-key-pair --key-name azure_id --public-key-material file://~/.ssh/azure_id.pub
