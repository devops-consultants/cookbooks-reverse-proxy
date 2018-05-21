haproxy_backend 'gateone' do
    server ['container0 127.0.0.1:8443 check ssl verify none weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'console_host hdr(host) -i console.devops-consultants.com'
node.default['proxy']['backends'] << 'gateone if console_host'

docker_service 'default' do
    action [:create, :start]
end
  
docker_image 'liftoff/gateone' do
    tag 'latest'
    action :pull
    notifies :redeploy, 'docker_container[gateone]'
end
  
docker_container 'gateone' do
    repo 'liftoff/gateone'
    port '8443:8000'
    action :run
    not_if { node['virtualization']['system'] == 'docker' }
end
