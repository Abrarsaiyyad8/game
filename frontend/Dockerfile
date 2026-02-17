FROM nginx

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy ONLY frontend content into nginx root
COPY . /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

