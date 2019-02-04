haproxy_backend 'McMyAdmin' do
    server ['mediaserver 10.0.0.57:8080 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'mcmyadmin_host hdr(host) -i mcadmin.coward-family.net'
node.default['proxy']['backends'] << 'McMyAdmin if mcmyadmin_host'
