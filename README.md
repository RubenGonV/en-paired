# Chess Tournament Service

## Requisitos locales
- Docker
- Python 3.11
- Terraform
- AWS CLI (configurado)

## Ejecutar local (desarrollo)
1. Levantar Postgres en docker:
   docker run --name chess-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=chessdb -p 5432:5432 -d postgres:15
2. Exportar env:
   export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/chessdb
3. Instalar deps:
   pip install -r api/requirements.txt
4. Correr el servicio:
   uvicorn app.main:app --reload --port 8000
5. Ejecutar tests:
   pytest -q api/app/tests

## Despliegue en AWS (staging)
1. Configurar secrets en AWS Secrets Manager (DB credentials, JWT_SECRET).
2. Ajustar `infra/variables.tf` y ejecutar:
   cd infra
   terraform init
   terraform plan
   terraform apply
3. GitHub Actions desplegará imagen a ECR y actualizará ECS.

