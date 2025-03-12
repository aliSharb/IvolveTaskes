

1. **build image from  Docker File**
```sh
 docker build -t my-jenkins-docker .
```


2. **Run the Custom Jenkins Container**
```sh
docker run -d --name jenkins-docker \
  --privileged \
  -p 8080:8080 -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.kube:/root/.kube \
  -v jenkins_home:/var/jenkins_home \
  my-jenkins-docker
```

3. **Access Jenkins Web UI**
- Open a browser and go to `http://localhost:8080`.
- Retrieve the initial admin password:
```sh
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
- Enter the password in the Jenkins UI and proceed with setup.
- Install recommended plugins.
- Create an admin user.
