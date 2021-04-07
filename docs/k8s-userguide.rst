Kubernetes User Guide
=====================

This document provides information needed to run applications on the NCEAS Kubernetes (k8s) cluster.

k8s Application Configurations
------------------------------

One approach to installing and managing an application on k8s is to create a Linux username for
and application and configure k8s to allow that username to handle all operations needed to
install and run that application.

This example shows how to create a new Linux username and k8s configuration that can be used 
to run and administer a k8s application on the NCEAS cluster.

In the example, the Linux username 'slinky' will be used. These commands require 
Linux sudo privilege and a k8s user with k8s 'kubernetes-admin' privilege (metadig).

1. Create the Linux username:

::

       sudo useradd -m -d /home/slinky -s /bin/bash slinky

2. Create an NFS share for the app, if needed.

   This share could be used to store external configuration files or data that the application uses,
   for example, a persistent database. To create the NFS share:

   - Add entry for new node in /etc/exports on k8s control node. Here is an example for 
     docker-dev-ucsb-1 (128.111.85.190):
     
     - /data2 128.111.85.190(rw,no_root_squash) 128.111.85.191(rw,no_root_squash) 128.111.85.225(rw,no_root_squash)
   - Then export the new share:
   
     - exportfs -a
   - On each worker node, add a mount for the NFS share to /etc/fstab:
     
     - i.e. docker-dev-ucsb-1.test.dataone.org:/data2 /data2  nfs rsize=8192,wsize=8192,timeo=14,intr
   - Install nfs-common if not present - this is needed by NFS to mount the remote share:

     - sudo apt install nfs-common
   - Mount the remote share:
   
     - sudo mount -a

3. Create a k8s namespace that the application will use:

   - kubectl create namespace slinky

   
The k8s command line tool 'kubectl' is used to start, stop and view k8s resources such as pods and applications.
This tool reads the file ~/.kube/config to authorize the user for k8s operations. 

The k8s 'serviceAccount' permission mechanism will be used to authorize a user to perform operations 
within a specified k8s namespace. Currently the process for creating a kubeconfig for a serviceAccount 
is a manual process. A skeleton config file will be created from the running k8s system, and then 
will be edited with needed authentication information obtained from the following commands:

1. Setup a k8s serviceAccount to authorize a user to perform any operation within a specified
   k8s namespace:
   
   - kubectl create -f slinky-access.yml

2. Get the serviceAccount secret:

   - kubectl describe serviceaccount slinky -n slinky

3. Get the client token by modifying the command below with the secret found from the previous command:

   - kubectl get secret slinky-token-n4dx7 -n slinky -o "jsonpath={.data.token}" | base64 -d

4. Get the client certificate data:

   - kubectl get secret slinky-token-n4dx7 -n slinky -o "jsonpath={.data['ca\.crt']}"

5. Get the current k8s config info. The config for the k8s admin user will be shown, which
   will be modified for the 'slinky' user 

   - kubectl config view --flatten --minify
   - The output from this command can be used as a template to create the kubeconfig file ~slinky/.kube/config for the 
     slinky username. the output from this command, using 'slinky-config.template' as a guide,  to create the kubeconfig file that will be
     used by the new username.

9. Edit ~slinky/.kube/config with the info obtained in previous steps.

10. Change ownership of the new config file to the 'slinky' username:

    - chown slinky:slinky ~slinky/.kube/config

10. Set the current context to be used by 'kubectl':

    - kubectl config --kubeconfig=$HOME/.kube/sa-config set-context slinky

Now that the service account has been created and set as the default configuration, all
operations performed by the user will be performed under the context 'slinky-context'.

This serviceAccount must be referenced by all pod and service definitions, for example,
this simple pod definition references the serviceAccount that was just created:

::

    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
      namespace: slinky
    spec:
      containers:
      - image: busybox
        command:
          - sleep
          - "3600"
        imagePullPolicy: IfNotPresent
        name: busybox
      serviceAccountName: slinky
      restartPolicy: Never

References
----------
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
- https://kubernetes.io/docs/reference/access-authn-authz/authentication/

