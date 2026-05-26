# ============================================
# ETAPA 1: BUILD - Compilar la aplicación React
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar primero solo package*.json para optimizar caché de Docker
# Si solo cambian package*.json, no necesita reconstruir node_modules
COPY package*.json ./

# Instalar dependencias de forma determinística (npm ci)
# --only=production no se usa aquí porque necesitamos devDependencies para build
RUN npm ci && npm cache clean --force

# Copiar código fuente
COPY . .

# Compilar la aplicación Vite (genera /app/dist)
RUN npm run build

# ============================================
# ETAPA 2: PRODUCCIÓN - Servir con nginx
# ============================================
FROM nginx:alpine AS production

# Copiar configuración nginx personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar archivos estáticos del build (artefacto de la etapa builder)
COPY --from=builder /app/dist /usr/share/nginx/html

# Configurar permisos de forma segura
# nginx:nginx es el usuario por defecto de la imagen nginx:alpine
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Cambiar a usuario no-root (principio de mínimo privilegio)
# No usamos USER root en producción
USER nginx

EXPOSE 80

# Healthcheck: permite a Docker/AWS verificar si el contenedor está sano
# wget usa el servidor interno, no depende de herramientas externas
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Ejecutar nginx en foreground (requerido para contenedores Docker)
CMD ["nginx", "-g", "daemon off;"]
