name 'reverse_proxy'
maintainer 'Rob Coward'
maintainer_email 'rob.coward@devops-consultants.co.uk'
license 'Apache-2.0'
description 'Installs/Configures reverse_proxy'
long_description 'Installs/Configures reverse_proxy'
version '0.0.5'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'redhat'

issues_url 'https://github.com/devops-consultants/cookbooks-reverse-proxy/issues'
source_url 'https://github.com/devops-consultants/cookbooks-reverse-proxy'

depends 'haproxy'
depends 'docker'
depends 'ssl_certificate'
depends 'selinux_policy'
