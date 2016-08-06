Para conectar a um jmeter-server rodando em um container:
   - Levante o container em um host remoto
       cd jmeter-server && docker-compose up -d
   - Faça um túnel da sua estação para o servidor em que o jmeter está rodando em container
       ssh labbs@172.17.131.212 -L 2222:localhost:2222
   - Abra um novo terminal e faça um segundo túnel, desta vez chegando ao ssh de dentro do container do jmeter-server
       ssh root@localhost -p 2222 -L 24000:127.0.0.1:24000 -R 25000:127.0.0.1:25000 -L 26000:127.0.0.1:26000
   - Edite o arquivo jmeter/bin/user.properties da sua estação e adicione as seguintes linhas
       remote_hosts=localhost:24000
       client.rmi.localport=25000
       mode=Statistical
   - Inicie o jmeter na sua estação, crie um plano e mande executar no host remoto "localhost:24000"

Referência: https://cloud.google.com/compute/docs/tutorials/how-to-configure-ssh-port-forwarding-set-up-load-testing-on-compute-engine/
