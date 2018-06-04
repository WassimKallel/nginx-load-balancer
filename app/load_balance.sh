if [ "$#" -lt 1 ]; then
    echo "You should specify a host at minimum"
	exit 1
fi

echo "\
server {\n\
	listen 80 default_server;\n\
	listen [::]:80 default_server;\n\
	server_name _;\n\
	location / {\n\
		proxy_pass http://backend;\n\
	}\n\
}\n\
\n\
upstream backend  {" > /etc/nginx/conf.d/default.conf

for arg; do
	ping -c 1 $arg > /dev/null 2>&1
	if [ $? -ne 0 ]; then
        echo "Unreachable host: $arg \n Load balancer could not start"
		exit 1
    fi 
    echo "  server $arg;" >> /etc/nginx/conf.d/default.conf
done

echo "}" >> /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"