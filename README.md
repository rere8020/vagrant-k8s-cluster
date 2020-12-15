### Install a 3 node kubernetes cluster on Ubuntu 18
##### *Cluster has helm, kompose, docker, private registry inlcuded in kmaster host*

[Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)

[Install Vagrant](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install)

***Clone repo***

```
cd vagrant-k8s-cluster
```

#### Modify Vagrantfile according to your needs
*Specifically the memory and cpu according to your pc capacities*
*Changing hostname will need to be changed other places for this to work, just leave it alone*

##### ALL VAGRANT COMMANDS NEED TO BE RUN FROM WHERE Vagrantfile 
##### IS LOCATED IN THE k8s_ubuntu DIRECTORY!

```
vagrant up
```

##### Wait for process to finish, may take <= 10mins ish

##### After process completes you can view status of machines and SSH into them with below commands


#### Shows 3 machines status
```
vagrant status
```

#### To SSH into a machine from where the Vagrantfile exists
```
vagrant ssh kmaster
vagrant ssh kworker1
vagrant ssh kworker2
```

The kmaster will have the docker registry running and all machines are configured to pull
insecurely from there. 
##### Registry address kmaster:5000

To add docker images to your local registry.

If you have the image locally first tag it. If you don't have the image you will need to do a docker pull to get the image on your machine first then tag it.

```
docker tag <sourceImageName>:<sourceImageTag> <registryAddress>/<name>:<tag>
docker tag busybox:latest kmaster:5000/busybox:latest
```

Then push to the local registry
```
docker push <repoTag>/<imageName>:<imageTag>
docker push kmaster:5000/busybox:latest
```

To see the images available in your registry follow below commands.

##### Shows all images without tags
```
curl kmaster:5000/v2/_catalog
```

##### Shows an image name and associated tags
```
curl <dockerRegistry>/v2/<imageName>/tags/list
curl kmaster:5000/v2/busybox/tags/list
```

To pull an image from any of the nodes follow below commands.

```
docker pull <dockerRegistry>/<imageName>:<imageTag>
docker pull kmaster:5000/busybox:latest
```
