#!/bin/bash

docker_service_status () {
export $(cat environments/$ENVIRONMENT | grep -v ^# | xargs)
container_id=$(docker-compose -f docker-compose-local.yml ps -q $service)
inspect_json=$(docker inspect $container_id)
#echo $inspect_json | jq -r '{running: .[0].State.Running, ports: .[0].NetworkSettings.Ports | keys| join(",")|test("3031/tcp")}| .running and .ports'
status=$(echo "$inspect_json" | jq -r '{running: .[1].State.Running, ports: .[0].NetworkSettings.Ports | keys| join(",")|test("3031/tcp")}| .running and .ports')
return 0
if [ $status == "true" ]; then
    return 0
else
    return 1
fi
}

test_host_port () {
    nc -z 0.0.0.0 $port
}
