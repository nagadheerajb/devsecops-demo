# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
# Upgrade affected packages in the base image
RUN apk update && apk upgrade --no-cache
# OR explicitly upgrade only the vulnerable packages
# RUN apk add --no-cache --upgrade libexpat libxml2 libxslt
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]