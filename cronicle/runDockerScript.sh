# BACKUP: not used anymore

docker run --env-file .env -v ${PWD}/tmpconfig:/app/shared:rw -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro -v ${PWD}/data/data:/opt/cronicle/data:rw -v ${PWD}/data/logs:/opt/cronicle/logs:rw -v ${PWD}/data/plugins:/opt/cronicle/plugins:rw -v /var/run/docker.sock:/var/run/docker.sock -p 3012:3012 --hostname cronicle --name cronicle cronicle-with-docker