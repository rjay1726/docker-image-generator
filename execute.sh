for service_num in {1..10}
do
    export SERVICE_NAME="test-service-$service_num"
    ./run-local.sh 
done 