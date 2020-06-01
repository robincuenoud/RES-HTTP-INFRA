<?php
	$static_app = getenv('STATIC_APP');
	$dynamic_app = getenv('DYNAMIC_APP');
?>
<VirtualHost *:80>
	ServerName demo.res.ch
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# https://httpd.apache.org/docs/2.4/en/mod/mod_proxy.html
	ProxyPass '/api/animals/' 'http://<?php print $dynamic_app ?>/'
	ProxyPassReverse '/api/animals/' 'http://<?php print $dynamic_app ?>/'
	
	ProxyPass '/' 'http://<?php print $static_app ?>/'
	ProxyPassReverse '/' 'http://<?php print $static_app ?>/'
</VirtualHost>