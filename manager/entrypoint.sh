#!/bin/bash

echo "execute our prestart script"
if [ ! -f "${DATA_DIR}/manager.sqlite3" ]; then
	echo "first run !"
	FIRSTRUN=1
else
	echo "not first run !"
	FIRSTRUN=0
fi

# always migrate & collect static file
python3 ./manage.py migrate
python3 ./manage.py loaddata manager/fixtures/media.json
python3 ./manage.py collectstatic --no-input

# create user on first run
if [ $FIRSTRUN -eq 1 ]; then
	python3 ./manage.py shell -c "from manager.models import Profile ; print(Profile.create_admin())"
fi

echo "run parent's entrypoint"
exec /entrypoint.sh "$@"
