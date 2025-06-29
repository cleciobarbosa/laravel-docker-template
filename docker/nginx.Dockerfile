# my-laravel-app/docker/nginx.Dockerfile
FROM nginx:stable-alpine

# Copia o seu arquivo de configuração do Nginx para dentro do diretório de configurações do Nginx
# dentro do contêiner. O Nginx irá carregá-lo automaticamente.
COPY nginx.conf /etc/nginx/conf.d/app.conf

# O comando padrão da imagem Nginx já inicia o servidor, então não precisamos de CMD aqui.