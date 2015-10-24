# k8s-integration

Containerize and test infrastructure for standardizing build and test processes.

*Integration build test concepts around build validation and testing*

*Basic approach to validate*

0. *Orchestration and process monitor container managing a set of docker in docker containers*
   0. builder container which runs  docker in docker or rkt equivalent
   0. executor container docker in docker, with a wait for presence script
   0. unit test container
   0. functional test container
0. *k8s POD configuration*
   0. docker in docker container attribute settings 
      privileged: true
      imagePullPolicy: IfNotPresent
   0. storage / volumes
      0. secrets - k8s secret storage type to securely share credentials.
      0. /run/docker.sock 
      0. /var/lib/docker
0. Initial workflow 
   0. Push button or event action initiates lifecycle test
   0. Each worker container has a single work step script and waits
      for notification of ready to run on socket or file
   0. build container
      0. executes git pull of commit
      0. execute docker build 
      0. post build status
   0. execute new appl container
   0. execute unit or functional test container
   0. if configured for image push, move to repo
0. 2 storage options to test -- share the docker paths only in the
  pod or use the hosts docker /run/docker.sock socket and
  /var/lib/docker
0. Notice that this workflow is independent of an external driver but
   is motivated by the ability to execute multiple co-dependent
   containers in encapsulated worker items and steps via k8s

![](https://github.com/davidwalter0/k8s-integration/blob/master/image/k8s-integration-flow.png)
