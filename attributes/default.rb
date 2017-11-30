default['proxy']['fqdn'] = 'gateway.devops-consultants.com'
default['proxy']['cert']['ssl_cert']['subject_alternate_names'] = [ node['fqdn'], "IP:#{node['cloud'].nil? ? node['ipaddress'] : node['cloud']['public_ipv4']}"  ]
default['proxy']['cert']['common_name'] = node['proxy']['fqdn']
default['proxy']['cert']['ssl_cert']['source'] = 'self-signed'
default['proxy']['cert']['ssl_cert']['secret_file'] = "/etc/pki/tls/certs/#{node['proxy']['fqdn']}.pem"
default['proxy']['cert']['ssl_key']['source'] = 'self-signed'
default['proxy']['cert']['ssl_key']['secret_file'] = "/etc/pki/tls/private/#{node['proxy']['fqdn']}.key"

default['proxy']['acls'] = []
default['proxy']['backends'] = []