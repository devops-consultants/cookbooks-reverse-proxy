haproxy_install 'package'

directory '/etc/haproxy/certs' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

# Creating the certificate
ssl_certificate 'proxy_cert' do
    namespace node['proxy']['cert']
    action :create
    notifies :run, 'execute[haproxy_cert]', :immediately
end

execute 'haproxy_cert' do
    command "cat /etc/pki/tls/certs/proxy_cert.pem /etc/pki/tls/private/proxy_cert.key > /etc/haproxy/certs/#{node['proxy']['fqdn']}.pem"
    action :nothing
end

directory '/etc/haproxy/errors' do
    user 'haproxy'
    group 'haproxy'
end
  
file '/etc/haproxy/errors/403.http' do
    content '<h1>Error: 403</h1>'
end

haproxy_config_global '' do
    chroot '/var/lib/haproxy'
    daemon true
    maxconn 256
    log '/dev/log local0'
    log_tag 'BASTION'
    pidfile '/var/run/haproxy.pid'
    stats socket: '/var/lib/haproxy/stats level admin'
    tuning 'bufsize' => '262144'
    extra_options 'tune.ssl.default-dh-param' => 2048
end
  
haproxy_config_defaults 'defaults' do
    mode 'http'
    timeout connect: '15000ms',
            client: '15000ms',
            server: '15000ms'
    haproxy_retries 5
end
  
haproxy_frontend 'http-in' do
    mode 'http'
    bind '*:80'
    extra_options redirect: 'scheme https code 301 if !{ ssl_fc }'
end

haproxy_frontend 'https' do
    mode 'http'
    bind "*:443 ssl crt /etc/haproxy/certs/#{node['proxy']['fqdn']}.pem crt /etc/haproxy/certs/ ciphers EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH"
    default_backend 'abuser'
    stats uri: '/haproxy?stats'
    maxconn 2000
    option %w(httplog dontlognull forwardfor)
    
    # use_backend ['gina if gina_host',
    #              'rrhost if rrhost_host',
    #              'abuser if source_is_abuser',
    #              'tiles_public if tile_host']
    use_backend lazy { node['proxy']['backends'] }
    # acl ['kml_request path_reg -i /kml/',
    #      'bbox_request path_reg -i /bbox/',
    #      'gina_host hdr(host) -i foo.bar.com',
    #      'rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com',
    #      'source_is_abuser src_get_gpc0(http) gt 0',
    #      'tile_host hdr(host) -i dough.foo.bar.com',
    # ]
    acl lazy { node['proxy']['acls'] }
end

haproxy_backend 'abuser' do
    extra_options 'errorfile' => '403 /etc/haproxy/errors/403.http'
end