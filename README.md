# Chess Tournament Service

## DECONSTRUCT (intent and requirements)

**Objective**: System for pairing and scoring chess tournaments with custom rules.

> **Target technologies** (required practice): DevOps, CI/CD, Git, PostgreSQL, AWS.

## DEFINE Functionality


- Users can create and manage tournaments
- Users can register players with ELO
- Users can customize pairing and point counting system
- Users can use a front-end interface
- Users can search and join tournaments

> *Note to self: I should improve this*

## Stack
- Backend: Node.js + Express
- DB: PostgreSQL
- Infra: AWS (RDS + EC2)
- CI/CD: GitHub Actions

## Roadmap de Implementación
### Fase 1: Setup DevOps

- 1️⃣ Repositorio Git con estructura modular
- 2️⃣ Dockerfile para la aplicación (FastAPI)
- 3️⃣ Terraform (IaC) para infraestructura AWS
    > **Objetivo**: Tener un stack mínimo funcional en AWS.
    > - VPC básica: una red virtual aislada en AWS donde se colocan todos los recursos.
    > - S3 Bucket: almacenamiento de objetos en AWS.
- 4️⃣ Pipeline CI/CD básico (GitHub Actions)

### Inicializar y aplicar Terraform desde Docker
Desde PowerShell en la carpeta `infra/`:
```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest init
```
```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v $env:USERPROFILE\.aws:/root/.aws `
  -w /workspace `
  hashicorp/terraform:latest apply -auto-approve
```
Esto crea un bucket S3 mínimo.

### Probar pipeline mínimo localmente
Ejecutar tests Python:
```powershell
python -m pip install --upgrade pip
pip install -r app/requirements.txt
pytest app/tests
```

---
```
en-paired/
├── .github/
│   └── workflows/          # Aquí irán los pipelines
├── backend/
│   ├── src/                # Código fuente
│   └── tests/              # Tests unitarios
├── database/
│   └── migrations/         # Schemas SQL
├── .gitignore
└── README.md
```

### Fase 2: Base de Datos

- Diseño del esquema SQL
- Stored procedures para emparejamiento Swiss
- Funciones para cálculo de tie-breaks
- Triggers para validación de reglas

### Fase 3: API & Lógica

- Endpoints CRUD para torneos/jugadores
- Motor de emparejamiento
- Sistema de puntuación con reglas personalizables
- Generación de tablas y rankings

### Fase 4: Automatización

- Tests automatizados
- Deploy automático a staging
- Scripts de backup de BD
- Monitoreo con CloudWatch

