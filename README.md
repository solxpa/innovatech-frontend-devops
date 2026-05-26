# Innovatech Chile - Frontend

Frontend de la aplicación Innovatech Chile, desarrollado con React + Vite y desplegado como contenedor Docker en AWS EC2.

## Arquitectura

```
┌──────────────────────────────────────────────────────────────────┐
│                        AWS Cloud                                 │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    EC2 Frontend (t3.micro)                  │ │
│  │                                                             │ │
│  │  ┌─────────────┐       ┌─────────────┐                      │ │
│  │  │    nginx    │       │   Docker    │                      │ │
│  │  │   :80       │ <──── │  Container  │                      │ │
│  │  │  (Puerto)   │       │             │                      │ │
│  │  └─────────────┘       └─────────────┘                      │ │
│  │                                                             │ │
│  │  Security Group: Puerto 80 (HTTP), 443 (HTTPS)              │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                              │                                   │
│                              │ HTTP :3000                        │
│                              ▼                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    EC2 Backend (t3.micro)                   │ │
│  │                                                             │ │
│  │  ┌─────────────┐       ┌─────────────┐                      │ │
│  │  │   Express   │       │   Docker    │                      │ │
│  │  │   :3000     │ <──── │  Container  │                      │ │
│  │  └─────────────┘       └─────────────┘                      │ │
│  │                                                             │ │
│  │  Security Group: Puerto 3000 (solo desde Frontend SG)   v   │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Tecnologías

- **Frontend**: React 19 + Vite 8
- **Servidor Web**: nginx:alpine
- **Contenedor**: Docker con multi-stage build
- **Despliegue**: AWS EC2 + Amazon ECR
- **CI/CD**: GitHub Actions

## Requisitos

- Docker Desktop (para desarrollo local)
- Node.js 20+ (para desarrollo local sin Docker)

## Desarrollo Local

### Con Docker Compose (Recomendado)

```bash
# Desde la raíz del proyecto (donde está docker-compose.yml)
docker-compose up --build

# La aplicación estará disponible en http://localhost:3000
```

### Sin Docker

```bash
cd innovatech-frontend
npm install
npm run dev
```

## Docker

### Build Manual

```bash
docker build -t innovatech-frontend ./innovatech-frontend
```

### Run Manual

```bash
docker run -d --name innovatech-frontend -p 80:80 innovatech-frontend
```

### Ver Logs

```bash
docker logs innovatech-frontend
docker logs -f innovatech-frontend
```

## Despliegue en AWS EC2

El despliegue se realiza automáticamente mediante GitHub Actions cuando se hace push a la rama `deploy`.

### Despliegue Manual (solo si es necesario)

```bash
# 1. Construir imagen
docker build -t innovatech-frontend ./innovatech-frontend

# 2. Taggear para ECR
docker tag innovatech-frontend TU_CUENTA.dkr.ecr.us-east-1.amazonaws.com/innovatech-frontend:latest

# 3. Subir a ECR
docker push TU_CUENTA.dkr.ecr.us-east-1.amazonaws.com/innovatech-frontend:latest

# 4. En EC2, ejecutar:
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin TU_CUENTA.dkr.ecr.us-east-1.amazonaws.com

docker stop innovatech-frontend || true
docker rm innovatech-frontend || true
docker run -d --name innovatech-frontend -p 80:80 \
  TU_CUENTA.dkr.ecr.us-east-1.amazonaws.com/innovatech-frontend:latest
```

## Pipeline CI/CD

El pipeline de GitHub Actions realiza los siguientes pasos:

1. **Checkout**: Obtiene el código del repositorio
2. **Configure AWS credentials**: Configura credenciales de AWS
3. **Login to ECR**: Autenticación con Amazon ECR
4. **Build Docker image**: Construye la imagen Docker
5. **Tag image**: Etiqueta la imagen con el commit SHA
6. **Push to ECR**: Sube la imagen al registro
7. **Deploy to EC2**: Se conecta por SSH y despliega la nueva versión

### Variables de Entorno Requeridas (GitHub Secrets)

| Secret | Descripción |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Access Key de IAM |
| `AWS_SECRET_ACCESS_KEY` | Secret Key de IAM |
| `EC2_FRONTEND_HOST` | DNS público o IP del EC2 frontend |
| `EC2_SSH_KEY` | Private key SSH para conexión |

### Variables de Repositorio (GitHub Variables)

| Variable | Descripción |
|----------|-------------|
| `AWS_ECR_REGISTRY` | URL del registro ECR (ej: 123456789.dkr.ecr.us-east-1.amazonaws.com) |

## Decisiones de Diseño

### Multi-Stage Build

Utilizamos multi-stage build por dos razones:
1. **Tamaño de imagen reducido**: La imagen final solo contiene nginx + archivos estáticos
2. **Seguridad**: Las herramientas de build no están en producción

### Usuario No-Root

Ejecutamos con el usuario `nginx` (no root) siguiendo el principio de mínimo privilegio.

### Healthcheck

Incluimos healthcheck para que AWS pueda monitorear la salud del contenedor.

## Seguridad

- Usuario no-root en el contenedor
- Headers de seguridad en nginx (X-Frame-Options, X-Content-Type-Options, etc.)
- Credenciales manejadas via GitHub Secrets
- Security Groups con puertos mínimos abiertos

## Mantenimiento

### Verificar Contenedor Activo

```bash
docker ps | grep innovatech-frontend
```

### Reiniciar Contenedor

```bash
docker restart innovatech-frontend
```

### Actualizar Después de Cambio

```bash
git checkout deploy
git pull origin deploy
docker-compose up --build -d
```

---

**Institución:** Duoc UC  
**Asignatura:** ISY1101 - Introducción a Herramientas DevOps
