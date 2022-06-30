server {
	listen 80;
	listen [::]:80;

	server_name code-${nginx_ip}.nip.io;

	location / {
		proxy_pass http://localhost:8080/;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection upgrade;
		proxy_set_header Accept-Encoding gzip;
	}
}
