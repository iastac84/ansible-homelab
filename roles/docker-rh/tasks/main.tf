---
- name: Set up docker repository
  yum_repository:
    name: docker
    description: Docker CE Repository
    file: docker
    baseurl: https://download.docker.com/linux/centos/docker-ce.repo
    enabled: yes
    gpgcheck: yes
    repo_gpgcheck: yes

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

