haproxy_backend 'kibana' do
    server ['mediaserver 10.0.0.57:80 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'kibana_host hdr(host) -i kibana.cloud.devops-consultants.com'
node.default['proxy']['backends'] << 'kibana if kibana_host'
