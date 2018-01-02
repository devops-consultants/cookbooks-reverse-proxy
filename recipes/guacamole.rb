haproxy_backend 'guacamole' do
    server ['container0 127.0.0.1:8081 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'guacamole_host hdr(host) -i desktop.devops-consultants.com'
node.default['proxy']['backends'] << 'guacamole if guacamole_host'
