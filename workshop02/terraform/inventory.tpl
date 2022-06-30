all:
  hosts:
    server-0:
      ansible_host: ${nginx_ip}
  vars:
    ansible_connection: ssh
    ansible_user: root
    ansible_ssh_private_key_file: /home/fred/.ssh/id_rsa
    ansible_become: yes
    
