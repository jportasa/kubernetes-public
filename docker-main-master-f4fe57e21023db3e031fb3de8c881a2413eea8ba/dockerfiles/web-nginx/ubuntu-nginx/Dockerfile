#                                                                                                          
# Nginx Dockerfile                                                                                         
#                                                                                                          
# https://github.com/dockerfile/nginx                                                                      
#                                                                                                          
                                                                                                           
# Pull base image.                                                                                         
FROM registry.wtransnet.local:5000/sistemas/ubuntu16.04:2                                                  
                                                                                                           
ENV NGINX_VERSION 1.10.0-0ubuntu0.16.04.4                                                                  
                                                                                                           
# Install Nginx.                                                                                           
RUN \                                                                                                      
  apt-get update && \                                                                                      
  apt-get install -y software-properties-common && \                                                       
  apt-get install --no-install-recommends --no-install-suggests -y \                                       
             nginx=${NGINX_VERSION} \                                                                      
             ca-certificates gettext-base && \                                                 
  rm -rf /var/lib/apt/lists/* && \                                                                         
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \                                                       
  chown -R www-data:www-data /var/lib/nginx                                                                
                                                                                                           
COPY conf.d/* /etc/nginx/conf.d/                                                                         
COPY html/*   /var/www/html/                                                                             
COPY nginx.conf /etc/nginx/nginx.conf                                                                      
COPY global  /etc/nginx/global                                                                             
COPY conf.d  /etc/nginx/conf.d   
                                                                                                       
# Define working directory.                                                                                
WORKDIR /etc/nginx                                                                                         
                                                                                                           
# forward request and error logs to docker log collector                                                   
RUN ln -sf /dev/stdout /var/log/nginx/access.log \                                                         
        && ln -sf /dev/stderr /var/log/nginx/error.log                                                     
                                                                                                           
# Define default command.                                                                                  
CMD ["nginx"]                                                                                              
#CMD ["nginx", "-g", "daemon off;"]                                                                        