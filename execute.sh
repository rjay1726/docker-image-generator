for service_num in {200..450}
do
    export SERVICE_NAME="test-service-$service_num"
    source ./env.sh || errorExit "Loading env.sh failed"
    docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
    ./run-local.sh 
done