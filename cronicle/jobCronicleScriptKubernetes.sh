#!/bin/sh

# Enter your shell script code here

DATE_STAMP=`date "+%Y-%m-%d"`

YOUR_RELEASE_NAME="kexa-helm"



JOB_NAME="kexa-job-run-$DATE_STAMP"

kubectl delete job $JOB_NAME

kubectl create job --from=cronjob/$YOUR_RELEASE_NAME-job $JOB_NAME

# wait for pod to start before following logs

while true; do
    STATUS=$(kubectl get job $JOB_NAME -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')
  
    if [ "$STATUS" = "Pending" ]; then
        echo "Waiting for job to start..."
        sleep 2
    else
        break
    fi
    
done


kubectl logs -f job/$JOB_NAME


while true; do
    STATUS=$(kubectl get job $JOB_NAME -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}')
    
    if [ "$STATUS" = "True" ]; then
        echo "Job completed successfully."
        break
    fi
    
    FAILED_STATUS=$(kubectl get job $JOB_NAME -o jsonpath='{.status.conditions[?(@.type=="Failed")].status}')
    if [ "$FAILED_STATUS" = "True" ]; then
        echo "Job failed."
        exit 1
    fi
    
    sleep 5
done

kubectl delete job $JOB_NAME

exit 0