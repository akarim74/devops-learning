from flask import Flask, render_template
import redis
import os
import socket

# Redis configuration using environment variables
redis_host = os.getenv("REDIS_HOST", "redis")
redis_port = int(os.getenv("REDIS_PORT", "6379"))

# Initialise Flask and Redis
app = Flask(__name__)
db = redis.Redis(
    host=redis_host,
    port=redis_port,
    decode_responses=True
)

# Homepage
@app.route('/')
def hello_world():
    return render_template('index.html')

# Visit counter
@app.route('/count')
def count():
    visits = db.incr("visits")
    return render_template(
        'count.html',
        visits=visits,
        hostname=socket.gethostname()
    )

# About page
@app.route('/about')
def about():
    return render_template('about.html')


# Start Flask application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
