---
- name: Upgrade all packages on servers
  dnf:
    name: '*'
    state: latest
  tags: [packageupdates]

- name: create test123 group
  group:
    name: test123
    state: present
  tags: [testgroup]

- name: Install packages
  dnf:
    name:
      - psacct
      - git
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
      - vim
    state: present
  tags: [packageinstalls]

- name: Update sshd_config AllowAgentForwarding
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#AllowAgentForwarding yes'
    line: 'AllowAgentForwarding yes'
  tags: [sshd_config]

- name: Update sshd_config AllowTcpForwarding
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#AllowTcpForwarding yes'
    line: 'AllowTcpForwarding yes'
  tags: [sshd_config]

- name: Update sshd_config GatewayPorts
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^#GatewayPorts no'
    line: 'GatewayPorts yes'
  tags: [sshd_config]

- name: check bridge networking is allowed
  shell: modprobe br_netfilter
  tags: [bridge]

- name: check bridge networking is allowed bridge-nf-call-iptables
  shell: echo "1" > /proc/sys/net/bridge/bridge-nf-call-iptables
  tags: [bridge]

- name: Add Kubernetes repo
  yum_repository:
    name: kubernetes
    description: Kubernetes repo
    file: kubernetes
    baseurl: https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
    enabled: yes
    gpgcheck: 1
    repo_gpgcheck: 1
    gpgkey: https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
  tags: [k8srepo]

- name: Install packages
  yum:
    name:
      - kubectl
    state: present
  tags: [kubectl_install]

- name: Set up docker repository
  shell: |
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

- name: Install Docker CE
  package:
    name: 
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: present

- name: Add user to the docker group
  user:
    name: istacey
    groups: docker
    append: yes
  tags: [docker_install]

