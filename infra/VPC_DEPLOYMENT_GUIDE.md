# VPC Deployment Guide - EN-PAIRED Project

## 💰 Cost: $0.00/month (100% FREE!)

All VPC resources created by this configuration are **completely FREE**:
- ✅ VPC: Free
- ✅ Subnets: Free  
- ✅ Internet Gateway: Free
- ✅ Route Tables: Free
- ✅ Security Groups: Free
- ✅ S3 Bucket: Free (only pay for storage if you use it)
- ✅ S3 Encryption (AES256): Free
- ✅ S3 Versioning: Free (only pay for storage)

**Note**: You only pay for resources you actually use (like EC2 instances, RDS databases, etc.) which are NOT part of this Phase 1 setup.

---

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured, OR
3. **AWS credentials** set as environment variables

### Option A: Configure AWS CLI (Recommended)
```powershell
aws configure
# Enter your:
# - AWS Access Key ID
# - AWS Secret Access Key  
# - Default region (e.g., eu-west-1)
# - Default output format (json)
```

### Option B: Set Environment Variables
```powershell
$env:AWS_ACCESS_KEY_ID = "your-access-key"
$env:AWS_SECRET_ACCESS_KEY = "your-secret-key"
$env:AWS_DEFAULT_REGION = "eu-west-1"
```

---

## 🚀 Deployment Steps

### Step 1: Navigate to Infrastructure Directory
```powershell
cd infra
```

### Step 2: Initialize Terraform
This downloads the required providers and sets up Terraform.

**Option A: Using Terraform directly** (if installed)
```powershell
terraform init
```

**Option B: Using Docker** (recommended for consistency)
```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest init
```

**Expected Output:**
```
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
```

### Step 3: Review What Will Be Created
Always review the plan before applying changes.

**Option A: Using Terraform directly**
```powershell
terraform plan
```

**Option B: Using Docker**
```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest plan
```

**What you should see:**
- 1 VPC
- 2 Public Subnets
- 1 Internet Gateway
- 1 Route Table
- 2 Route Table Associations
- 2 Security Groups (Web + Database)
- 1 S3 Bucket (with security settings)

### Step 4: Apply Changes
This will create all the infrastructure.

**Option A: Using Terraform directly**
```powershell
terraform apply
```
Type `yes` when prompted.

**Option B: Using Docker (auto-approve)**
```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest apply -auto-approve
```

**Expected Output:**
```
Apply complete! Resources: X added, 0 changed, 0 destroyed.

Outputs:

vpc_id = "vpc-xxxxxxxxx"
vpc_cidr = "10.0.0.0/16"
public_subnet_1_id = "subnet-xxxxxxxxx"
public_subnet_2_id = "subnet-xxxxxxxxx"
internet_gateway_id = "igw-xxxxxxxxx"
web_security_group_id = "sg-xxxxxxxxx"
database_security_group_id = "sg-xxxxxxxxx"
bucket_name = "fastapi-app-xxxxx"
```

### Step 5: Verify Deployment

#### Option A: Check via AWS Console
1. Go to [AWS VPC Console](https://console.aws.amazon.com/vpc/)
2. You should see a VPC named "en-paired-vpc"
3. Check Subnets, Internet Gateways, and Security Groups

#### Option B: Check via AWS CLI
```powershell
# List VPCs
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=en-paired"

# List Subnets
aws ec2 describe-subnets --filters "Name=tag:Project,Values=en-paired"

# List Security Groups
aws ec2 describe-security-groups --filters "Name=tag:Project,Values=en-paired"
```

---

## 📊 What Gets Created

### VPC Network
- **VPC CIDR**: `10.0.0.0/16`
- **DNS Support**: Enabled
- **DNS Hostnames**: Enabled

### Public Subnets (2 Availability Zones)
- **Subnet 1**: `10.0.1.0/24` (AZ 1)
- **Subnet 2**: `10.0.2.0/24` (AZ 2)
- Both have internet access via Internet Gateway

### Internet Gateway
- Connected to VPC
- Allows public internet access

### Security Groups
1. **Web Security Group** (`en-paired-web-sg`)
   - Allows: HTTP (80), HTTPS (443), FastAPI (8000)
   - For future EC2/ECS instances

2. **Database Security Group** (`en-paired-db-sg`)
   - Allows: PostgreSQL (5432) from Web SG only
   - For future RDS instances

### S3 Bucket
- Random unique name: `fastapi-app-xxxxx`
- Public access: **BLOCKED** (secure)
- Versioning: **ENABLED**
- Encryption: **AES256** (free)

---

## 🔧 Troubleshooting

### Error: "No valid credential sources found"
**Solution**: Configure AWS credentials (see Prerequisites)

### Error: "Bucket name already exists"
**Solution**: S3 bucket names are globally unique. The random suffix should prevent this, but if it happens, just run `terraform apply` again.

### Error: "Insufficient permissions"
**Solution**: Ensure your AWS user/role has these permissions:
- `ec2:*` (for VPC resources)
- `s3:*` (for S3 bucket)

### Error: "Region not available"
**Solution**: Change the region in `main.tf`:
```hcl
variable "aws_region" {
  default = "us-east-1"  # or another region
}
```

---

## 🗑️ Cleanup (Destroy Infrastructure)

**⚠️ WARNING**: This will delete ALL resources created by Terraform!

```powershell
# Option A: Using Terraform
terraform destroy

# Option B: Using Docker
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest destroy -auto-approve
```

**Note**: If the S3 bucket contains files, you'll need to empty it first:
```powershell
aws s3 rm s3://<bucket-name> --recursive
```

---

## 📝 Next Steps

After successful deployment:

1. ✅ **Phase 1 Complete**: VPC requirement fulfilled
2. **Phase 2**: Deploy RDS PostgreSQL in the VPC (will use `database_security_group_id`)
3. **Phase 3**: Deploy EC2/ECS in public subnets (will use `web_security_group_id`)

---

## 📚 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)

---

## ✅ Verification Checklist

After deployment, verify:
- [ ] VPC created in AWS Console
- [ ] 2 public subnets visible
- [ ] Internet Gateway attached to VPC
- [ ] 2 security groups created
- [ ] S3 bucket exists and is secure
- [ ] Terraform outputs show all resource IDs

**Phase 1 VPC Requirement: ✅ COMPLETE**

