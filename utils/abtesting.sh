#killall nginx

rm *temp -rf

nginx -p `pwd` -c conf/nginx.conf  
nginx -p `pwd` -c conf/stable.conf 
nginx -p `pwd` -c conf/beta1.conf  
nginx -p `pwd` -c conf/beta2.conf  
nginx -p `pwd` -c conf/beta3.conf  
nginx -p `pwd` -c conf/beta4.conf  
