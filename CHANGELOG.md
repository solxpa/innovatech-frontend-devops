# Changelog - Evaluación ISY1101

Documento que registra todos los cambios realizados para la evaluación.

---

## v1.1 - Implementación Completa CI/CD (25 Mayo 2025)

### Cambios en Frontend (`innovatech-frontend/`)

#### `dockerfile` - Reescrito completamente
**Antes:**
- Single-stage para build, sin multi-stage
- Usuario root
- Sin HEALTHCHECK
- `npm install` (no determinístico)

**Después:**
- Multi-stage build (builder → production)
- Usuario no-root `nginx`
- HEALTHCHECK configurado
- `npm ci` (determinístico)
- `npm cache clean --force`
- Permisos de archivos configurados

#### `nginx.conf` - NUEVO
- Configuración de caché para assets estáticos (1 año)
- SPA routing (todas las rutas a index.html)
- Headers de seguridad (X-Frame-Options, X-Content-Type-Options, X-XSS-Protection)

#### `.dockerignore` - NUEVO
- Excluye .git, node_modules, dist, logs, archivos IDE
- Reduce tamaño del build context

#### `.github/workflows/deploy.yml` - NUEVO
- Pipeline CI/CD completo
- Trigger en rama `deploy`
- Build → Push a ECR → Deploy a EC2
- Autenticación AWS con secrets

#### `README.md` - Reescrito completamente
- Arquitectura del sistema (diagram ASCII)
- Instrucciones de desarrollo local
- Instrucciones de despliegue
- Documentación del pipeline CI/CD
- Justificación de decisiones técnicas

---

### Cambios en Backend (`innovatech-backend/`)

#### `dockerfile` - Reescrito completamente
**Antes:**
- Single-stage
- Usuario root
- Sin HEALTHCHECK
- `npm install`

**Después:**
- Multi-stage build (builder → production)
- Usuario no-root `innovatech` (creado específicamente)
- HEALTHCHECK configurado
- `npm ci --only=production` (solo producción, sin devDependencies)
- `npm cache clean --force`
- Permisos de archivos configurados

#### `.dockerignore` - NUEVO
- Excluye .git, node_modules, logs, archivos IDE
- Reduce tamaño del build context

#### `.github/workflows/deploy.yml` - NUEVO
- Pipeline CI/CD completo
- Trigger en rama `deploy`
- Build → Push a ECR → Deploy a EC2
- Autenticación AWS con secrets

#### `README.md` - Reescrito completamente
- Arquitectura del sistema
- Documentación de endpoints
- Instrucciones de desarrollo local
- Instrucciones de despliegue
- Justificación de decisiones técnicas

---

### Nuevo archivo en Raíz (`/`)

#### `docker-compose.yml` - NUEVO
- Servicio frontend (puerto 3000:80)
- Servicio backend (puerto 3001:3000)
- Redes separadas (frontend-network, backend-network)
- Healthchecks configurados
- Restart policy `unless-stopped`

---

## Checklist de Implementación

| Componente | Estado | Descripción |
|------------|--------|-------------|
| Dockerfile Frontend | ✅ Listo | Multi-stage, non-root, healthcheck |
| nginx.conf | ✅ Listo | SPA routing, headers seguridad, caché |
| .dockerignore Frontend | ✅ Listo | Build context optimizado |
| Dockerfile Backend | ✅ Listo | Multi-stage, non-root, prod-only deps |
| .dockerignore Backend | ✅ Listo | Build context optimizado |
| docker-compose.yml | ✅ Listo | Ambos servicios, redes, healthcheck |
| GitHub Actions Frontend | ✅ Listo | Pipeline completo |
| GitHub Actions Backend | ✅ Listo | Pipeline completo |
| README Frontend | ✅ Listo | Documentación completa |
| README Backend | ✅ Listo | Documentación completa |

---

##_pending de Configuración (Por hacer en AWS/GitHub)

### AWS
- [ ] Crear repositorios ECR (frontend y backend)
- [ ] Obtener Access Key + Secret Key IAM
- [ ] Configurar Security Groups en EC2
- [ ] Ejecutar user data para instalar Docker + AWS CLI

### GitHub
- [ ] Crear repository variables: `AWS_ECR_REGISTRY`
- [ ] Crear secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- [ ] Crear secrets: `EC2_FRONTEND_HOST`, `EC2_BACKEND_HOST`
- [ ] Crear secret: `EC2_SSH_KEY`
- [ ] Crear rama `deploy` y hacer push inicial

---

## Justificación de Decisiones Técnicas

### 1. Multi-Stage Build
**Por qué:** Reduce el tamaño de la imagen final al descartas herramientas de build. La imagen de producción solo contiene nginx + archivos estáticos.

### 2. Usuario No-Root
**Por qué:** Principio de mínimo privilegio. Si hay una vulnerabilidad, el atacante no tiene permisos de root.

### 3. npm ci en vez de npm install
**Por qué:** Instalación determinística basada en package-lock.json. Más rápido, reproduce exactamente las mismas versiones.

### 4. --only=production en backend
**Por qué:** No incluye devDependencies (eslint, jest, etc.) en producción. Reduce tamaño y superficie de ataque.

### 5. HEALTHCHECK
**Por qué:** AWS y Docker pueden verificar si el contenedor está sano. Permite restart automático.

### 6. ECR en vez de Docker Hub
**Por qué:** Integración nativa con AWS, IAM para permisos, sin tokens externos.

### 7. Pipeline con SSH a EC2
**Por qué:** Automatiza completamente el despliegue. No hay intervención manual después del push.

---

## Comandos Útiles

### Probar docker-compose localmente
```bash
docker-compose up --build
docker-compose down
```

### Ver logs de ambos servicios
```bash
docker-compose logs -f
```

### Build manual sin compose
```bash
docker build -t innovatech-frontend ./innovatech-frontend
docker build -t innovatech-backend ./innovatech-backend
```

### Ver imágenes Docker
```bash
docker images | grep innovatech
```

---

*Documento creado para la Evaluación Parcial N°2 - ISY1101 - Duoc UC*
*Fecha: 25 de Mayo 2025*
