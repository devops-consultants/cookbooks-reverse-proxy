haproxy_backend 'drupal' do
    server ['container0 127.0.0.1:8082 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'drupal_host hdr(host) -i lovegiraffes.blog'
node.default['proxy']['acls'] << 'drupal_host hdr(host) -i lovegiraffes.info'
node.default['proxy']['backends'] << 'drupal if drupal_host'

include_recipe 'docker_compose::installation'

# Provision Compose file
cookbook_file '/etc/docker-compose_drupal.yml' do
  source 'docker-compose_drupal.yml'
  owner 'root'
  group 'root'
  mode 0640
  notifies :up, 'docker_compose_application[drupal]', :delayed
end

# Provision Compose application
docker_compose_application 'drupal' do
  action :up
  compose_files [ '/etc/docker-compose_drupal.yml' ]
end