from flask import Flask
import redis
import os
import socket

# Retrieve environment variables
redis_host = os.getenv("REDIS_HOST", "redis")
redis_port = int(os.getenv("REDIS_PORT", "6379"))

# Initialise Flask
app = Flask(__name__)

# Connect to Redis
db = redis.Redis(
    host=redis_host,
    port=redis_port,
    decode_responses=True
)

# Homepage - display the container hostname
@app.route('/')
def hello_world():
    return f"Welcome to my Flask and Redis application! Served by: {socket.gethostname()}"

# Visit counter
@app.route('/count')
def count():
    visits = db.incr("visits")
    return f"Visit count: {visits}"

# Start Flask
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
