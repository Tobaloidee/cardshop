import os
from flask import Flask

from routes import auth, users, errors, channels, orders
from utils.json import Encoder
from prestart import Initializer


flask = Flask(__name__)
flask.json_encoder = Encoder

flask.register_blueprint(auth.blueprint)
flask.register_blueprint(users.blueprint)
flask.register_blueprint(channels.blueprint)
flask.register_blueprint(orders.blueprint)

errors.register_handlers(flask)


if __name__ == "__main__":
    Initializer.start()

    is_debug = os.getenv("DEBUG", False)
    flask.run(host="0.0.0.0", debug=is_debug, port=80, threaded=True)
