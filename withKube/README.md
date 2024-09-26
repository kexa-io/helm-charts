# Cronicle Schedule with kube job

Those files are here if you want to deploy Cronicle to schedule Kexa as a Kube job instead of DinD.

Add the role and binding to the template, then use the jobCronicleScriptKubernetes.sh inside the shell script
of Cronicle (instead of jobCronicleScriptDocker.sh)
