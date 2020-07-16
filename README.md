JMeter 3 Server
===============

[<img src="https://img.shields.io/docker/automated/flaviostutz/jmeter-server"/>](https://hub.docker.com/r/flaviostutz/jmeter-server)
[![](https://images.microbadger.com/badges/image/flaviostutz/jmeter-server.svg)](https://microbadger.com/images/flaviostutz/jmeter-server "Get your own image badge on microbadger.com")

Use this container in order to execute load tests using JMeter remotelly.

To use this container:
   - Install JMeter 3.0 on your machine and run it using Java 8
      - http://mirror.nbtelecom.com.br/apache//jmeter/binaries/apache-jmeter-3.0.zip
   - Run this container in a remote host
      - git clone https://github.com/flaviostutz/jmeter-server.git
      - docker-compose up -d
      - (OR) docker run -p 24000:24000 -p 26000:26000 -p 2222:22
   - Create a SSH tunel between your machine and the remote host running the container (this step may be skipped if you have direct access to all ports of the host machine running the container)
      - ssh user@remotehostip -L 2222:localhost:2222
   - In a new terminal, create a second tunel, this time the SSH tunel will connect your machine directly to the SSH inside the jmeter container and export some ports
      - ssh root@localhost -p 2222 -L 24000:127.0.0.1:24000 -R 25000:127.0.0.1:25000 -L 26000:127.0.0.1:26000
      - (or if you skipped last step) ssh root@remotehostip -p 2222 -L 24000:127.0.0.1:24000 -R 25000:127.0.0.1:25000 -L 26000:127.0.0.1:26000
   - Edit jmeter/bin/user.properties of the JMeter you will be using as a client and add the following lines:
      - remote_hosts=localhost:24000
      - client.rmi.localport=25000
      - mode=Statistical
   - Start JMeter on your machine, create a Test Plan and execute the plan through Execute -> Execute Remote -> "localhost:24000"
   - Verify your test statistics
   - If needed, see container logs for details on test execution

Reference: https://cloud.google.com/compute/docs/tutorials/how-to-configure-ssh-port-forwarding-set-up-load-testing-on-compute-engine/
