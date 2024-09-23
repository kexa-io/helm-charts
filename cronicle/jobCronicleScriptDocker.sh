#!/bin/sh

# Enter your shell script code here

docker pull innovtech/kexa:latest

SHARED_DIR="/app/shared"

TMP_KEXA_IMG="temp_image"

docker rm temp_container
docker rmi $TMP_KEXA_IMG
rm -rf tmp_env_file

docker pull innovtech/kexa:latest

docker create --name temp_container innovtech/kexa:latest

docker cp "$SHARED_DIR" temp_container:/app/shared

# ADD PREFIX FOR IDENTYFING KEXA VAR, THEN PRINT redirect ONLY KEXA VAR ?

docker commit temp_container $TMP_KEXA_IMG

ENV_VARS=$(docker exec temp_container printenv)

printenv | grep -E '^[A-Z_][A-Z0-9_]*=.*$' | grep -v ' ' > tmp_env_file

docker run --rm \
  -e NODE_OPTIONS="--max-old-space-size=8192" \
  --env-file tmp_env_file \
  $TMP_KEXA_IMG sh -c "cp -r /app/shared/rules/* /app/rules/ && cp -r /app/shared/config/* /app/config/ && printenv > .env && pnpm run start:nobuild"

rm -rf tmp_env_file

docker rm temp_container
docker rmi $TMP_KEXA_IMG