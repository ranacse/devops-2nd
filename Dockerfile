#FROM nginx:alpine
#COPY . /usr/share/nginx/html

FROM nginx:alpine

# Copy index.html to nginx default directory
COPY index.html /usr/share/nginx/html/

# Copy nginx config (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
