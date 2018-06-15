haproxy_backend 'drupal' do
    server ['container0 127.0.0.1:8082 check weight 1 maxconn 100']
end

node.default['proxy']['acls'] << 'drupal_host hdr(host) -i lovegiraffes.blog'
node.default['proxy']['acls'] << 'drupal_host hdr(host) -i lovegiraffes.info'
node.default['proxy']['backends'] << 'drupal if drupal_host'

include_recipe 'docker_compose::installation'

# Provision Compose file
cookbook_file '/etc/drupal/docker-compose.yml' do
  source 'docker-compose_drupal.yml'
  owner 'root'
  group 'root'
  mode 0640
  notifies :up, 'docker_compose_application[drupal]', :delayed
end

docker_volume 'drupal-sites' do
  action :create
  notifies :run, 'docker_container[drupal_seed_sites]', :immediately
end

docker_container 'drupal_seed_sites' do
  repo 'drupal'
  tag '8.5'
  command "cp -aRT /var/www/html/sites /temporary/sites"
  volumes 'drupal-sites:/temporary/sites'
  action :nothing
end

# Provision Compose application
docker_compose_application 'drupal' do
  action :up
  compose_files [ '/etc/drupal/docker-compose.yml' ]
end
