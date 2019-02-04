haproxy_backend 'horizon' do
    server ['container0 127.0.0.1:8080 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'horizon_host hdr(host) -i horizon.devops-consultants.com'
node.default['proxy']['backends'] << 'horizon if horizon_host'

docker_service 'default' do
    action [:create, :start]
end
  
docker_image 'alvaroaleman/openstack-horizon' do
    tag 'latest'
    action :pull
    notifies :redeploy, 'docker_container[horizon]'
end
  
directory '/var/log/horizon' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

docker_container 'horizon' do
    repo 'alvaroaleman/openstack-horizon'
    port '8080:80'
    volumes ['/var/log/horizon:/var/log/apache2:rw']
    env ['KEYSTONE_URL=https://controller.cloud.devops-consultants.com:5000/v2.0']
    # command "nc -ll -p 1234 -e /bin/cat"
    action :run
    not_if { node['virtualization']['system'] == 'docker' }
end
