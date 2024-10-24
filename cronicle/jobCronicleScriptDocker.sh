#!/bin/sh

# docker pull innovtech/kexa:latest

TMP_KEXA_IMG="temp_image"
HOST_CONFIG_FOLDER="tmpconfig"
KUBERNETES_CONFIG_FOLDER="kubernetesconfigurations"



SHARED_DIR="/app/shared/$HOST_CONFIG_FOLDER/rules"

mkdir /tmp/$KUBERNETES_CONFIG_FOLDER

for file in /app/$KUBERNETES_CONFIG_FOLDER/*; do
    filename=$(basename "$file")
    cat "$file" > "/tmp/$KUBERNETES_CONFIG_FOLDER/$filename"
done

if [ "$(docker ps -aq -f name=temp_container)" ]; then
    docker stop temp_container
    docker rm temp_container
fi

if [ "$(docker images -q $TMP_KEXA_IMG 2> /dev/null)" ]; then
    docker rmi $TMP_KEXA_IMG
fi

rm -rf tmp_env_file

echo "Pulling latest image and creating temp container..."
docker run -d --name temp_container innovtech/kexa:latest tail -f /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to create temp container."
    exit 1
fi

echo "Created temp container."
echo "Copying shared directory to temp container..."
docker cp "$SHARED_DIR" temp_container:/app/
docker cp /app/config temp_container:/app/
echo "INTERFACE_CONFIGURATION_ENABLED='true'" >> /app/.env
docker cp /app/.env temp_container:/app/.env
docker cp /tmp/$KUBERNETES_CONFIG_FOLDER/* temp_container:/app/

docker exec temp_container sh -c 'ls /app/'

docker commit temp_container $TMP_KEXA_IMG

printenv | grep -E '^[A-Z_][A-Z0-9_]*=.*$' | grep -v ' ' > tmp_env_file

echo "Running kexa..."

docker run --rm \
  -e NODE_OPTIONS="--max-old-space-size=8192" \
  --env-file tmp_env_file \
  $TMP_KEXA_IMG sh -c "pnpm run start:nobuild"

rm -rf tmp_env_file

rm -rf /tmp/$KUBERNETES_CONFIG_FOLDER/*
rmdir -rf /tmp/$KUBERNETES_CONFIG_FOLDER

if [ "$(docker ps -aq -f name=temp_container)" ]; then
    docker stop temp_container
    docker rm temp_container
fi

docker rmi $TMP_KEXA_IMG
