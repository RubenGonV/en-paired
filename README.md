# EN-PAIRED Project Overview

EN-PAIRED is a chess tournament service for creating and managing tournaments with custom pairing and scoring rules.

> ### Project Goal
> Build a system for:
> * Creating and managing tournaments
> * Registering players with ELO ratings
> * Customizing pairing and scoring systems
> * Providing a front-end interface
> * Searching and joining tournaments

> ### Target Technology Stack
> **Backend**: FastAPI (Python) — note: README mentions Node.js, but the code uses FastAPI
>
> **Database**: PostgreSQL (planned)
>
> **Infrastructure**: AWS
> * S3 (currently deployed)
> * RDS + EC2 (planned)
>
> **DevOps**:
> * Docker for containerization
> * Terraform for Infrastructure as Code (IaC)
> * GitHub Actions for CI/CD** (required practice): DevOps, CI/CD, Git, PostgreSQL, AWS.

## Current Implementation Status 

### Phase 1: DevOps Setup - Progress Evaluation

#### ✅ **Completed Requirements**

1. **✅ Repositorio Git con estructura modular**
   - Well-organized project structure with separate directories for app, infra, database
   - Proper `.gitignore` file in place

2. **✅ Dockerfile para la aplicación (FastAPI)**
   - Multi-stage build implemented
   - Security best practices: non-root user, minimal base image
   - Properly configured for FastAPI with uvicorn
   - Note: Located in `app/` directory (correct structure)

3. **✅ S3 Bucket (Partial Infrastructure)**
   - Terraform configuration creates S3 bucket with random suffix
   - Basic output for bucket name
   - Infrastructure test validates bucket creation

4. **✅ Pipeline CI/CD básico (GitHub Actions)**
   - Complete workflow with all essential steps:
     * Code checkout
     * Python setup and dependency installation
     * Test execution
     * Docker image build
     * Terraform deployment
     * Infrastructure validation

#### ⚠️ **Missing Requirements**

1. **✅ VPC básica - CONFIGURATION READY** 
   - **Status**: ✅ Configuration files created, ready to deploy
   - **Requirement**: "VPC básica: una red virtual aislada en AWS donde se colocan todos los recursos" (line 94)
   - **Cost**: **$0.00/month** (100% FREE - all VPC resources are free)
   - **Files Created**: 
     * `infra/vpc.tf` - VPC infrastructure definition (VPC, subnets, IGW, security groups)
     * `infra/outputs.tf` - Output values for VPC resources
     * `infra/VPC_DEPLOYMENT_GUIDE.md` - Step-by-step deployment instructions
     * `infra/main.tf` - Updated with S3 security hardening
   - **Next Step**: Follow instructions in `infra/VPC_DEPLOYMENT_GUIDE.md` to deploy

2. **⚠️ Terraform State Management**
   - No backend configuration (state stored locally)
   - `terraform.tfstate` should not be committed (it's in `.gitignore` but file exists)
   - **Recommendation**: Use S3 backend with DynamoDB locking for state management

3. **✅ S3 Bucket Security - IMPROVED**
   - ✅ Public access block configured
   - ✅ Versioning enabled
   - ✅ Encryption enabled (AES256 - FREE)
   - ⚠️ No lifecycle policies (optional for Phase 1)
   - **Status**: Security hardening completed in `infra/main.tf`

#### 📋 **Additional Observations**

1. **Testing Coverage**
   - ✅ Infrastructure test (S3 bucket existence)
   - ⚠️ No FastAPI application tests (only infrastructure tests)
   - **Recommendation**: Add unit tests for FastAPI endpoints

2. **Terraform Best Practices**
   - ✅ Variables for region configuration
   - ⚠️ No `terraform.tfvars` for environment-specific values
   - ⚠️ No separate environments (dev/staging/prod)
   - **Recommendation**: Implement environment-specific configurations

3. **CI/CD Improvements Needed**
   - ✅ Basic pipeline functional
   - ⚠️ No Docker image push to registry (Docker Hub/ECR)
   - ⚠️ No deployment of application to EC2/ECS
   - ⚠️ No rollback mechanism
   - **Recommendation**: Add container registry and deployment steps

#### 📊 **Phase 1 Completion Status: ~85%**

**Summary:**
- Core functionality: ✅ Working
- Infrastructure: ✅ Ready (VPC config complete, needs deployment)
- CI/CD: ✅ Functional (could be enhanced)
- Security: ✅ Improved (S3 hardening complete)
- Testing: ⚠️ Minimal coverage

**Priority Actions to Complete Phase 1:**
1. **HIGH**: Deploy VPC infrastructure (configuration ready - see `infra/VPC_DEPLOYMENT_GUIDE.md`)
2. **MEDIUM**: Add Terraform backend (S3 + DynamoDB) for state management
3. ~~**MEDIUM**: Harden S3 bucket security~~ ✅ **COMPLETED**
4. **LOW**: Add FastAPI application tests
5. **LOW**: Create environment-specific Terraform configs+

## Planned Roadmap

> ### Phase 2: Database design
> * SQL schema design
> * Swiss pairing stored procedures
> * Tie-break calculation functions
> * Validation triggers

> ### Phase 3: API & Logic
> * CRUD endpoints for tournaments/players
> * Pairing engine
> * Customizable scoring system
> * Ranking tables

> ### Phase 4: Automation
> * Automated tests
> * Automatic staging deployments
> * Database backup scripts
> * CloudWatch monitoring

## Project Structure
```
en-paired/
├── app/                    # FastAPI application
│   ├── src/main.py        # Main FastAPI app
│   ├── tests/             # Test files
│   ├── Dockerfile         # Container configuration
│   └── requirements.txt   # Python dependencies
├── infra/                 # Infrastructure as Code
│   └── main.tf           # Terraform configuration
├── database/              # Database migrations (planned)
│   └── migrations/
└── .github/workflows/     # CI/CD pipelines
    └── ci-cd.yml
```

## DEFINE Functionality


- Users can create and manage tournaments
- Users can register players with ELO
- Users can customize pairing and point counting system
- Users can use a front-end interface
- Users can search and join tournaments

> *Note to self: I should improve this*

## Roadmap de Implementación
### Fase 1: Setup DevOps

- 1️⃣ Repositorio Git con estructura modular
- 2️⃣ Dockerfile para la aplicación (FastAPI)
- 3️⃣ Terraform (IaC) para infraestructura AWS
    > **Objetivo**: Tener un stack mínimo funcional en AWS.
    > - VPC básica: una red virtual aislada en AWS donde se colocan todos los recursos.
    > - S3 Bucket: almacenamiento de objetos en AWS.
- 4️⃣ Pipeline CI/CD básico (GitHub Actions)

### 🚀 Quick Start: Deploy VPC + S3 Infrastructure

**💰 Cost: $0.00/month** (All VPC resources are FREE!)

**Prerequisites**: AWS credentials configured (via AWS CLI or environment variables)

From the `infra/` directory:

**Option 1: Using Terraform directly**
```powershell
cd infra
terraform init
terraform plan    # Review what will be created
terraform apply   # Deploy VPC + S3 bucket
```

**Option 2: Using Docker (recommended for consistency)**
```powershell
cd infra
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest init

docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest plan

docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest apply -auto-approve
```

**📖 Detailed Instructions**: See `infra/VPC_DEPLOYMENT_GUIDE.md` for complete step-by-step guide with troubleshooting.

**What gets created:**
- ✅ VPC with CIDR 10.0.0.0/16
- ✅ 2 Public Subnets (in 2 availability zones)
- ✅ Internet Gateway
- ✅ Route Tables
- ✅ Security Groups (Web + Database)
- ✅ S3 Bucket (with encryption, versioning, and security)

### Probar pipeline mínimo localmente
Ejecutar tests Python:
```powershell
python -m pip install --upgrade pip
pip install -r app/requirements.txt
pytest app/tests
```

---


