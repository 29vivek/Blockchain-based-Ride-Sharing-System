import datetime
import json
import time
import requests
from flask import render_template, redirect, request

from app import app

# The node with which our application interacts, there can be multiple
# such nodes as well.
CONNECTED_NODE_ADDRESS = "http://127.0.0.1:8000"

confirmed_posts = []
replies = []
post = None

def fetch_confirmed_posts():
    """
    Function to fetch the chain from a blockchain node, parse the
    data and store it locally.
    """
    get_chain_address = "{}/chain".format(CONNECTED_NODE_ADDRESS)
    response = requests.get(get_chain_address)

    if response.status_code == 200:
        content = []
        chain = json.loads(response.content)
        for block in chain["chain"]:
            for tx in block["transactions"]:
                global post
                global replies
                if(tx["author"]+tx["price"]+tx["number"]+tx["start"]+ \
                    tx["end"]+tx["content"]==post["unique_id"]):
                    post = None
                    replies = []
                tx["index"] = block["index"]
                tx["hash"] = block["previous_hash"]
                content.append(tx)

        global confirmed_posts
        confirmed_posts = sorted(content, key=lambda k: k['timestamp'],
                       reverse=True)


@app.route('/')
def index():
    fetch_confirmed_posts()
    return render_template('index.html',
                           title='Ride Request Site',
                           post=post,
                           confirmed_posts=confirmed_posts,
                           replies=replies,
                           node_address=CONNECTED_NODE_ADDRESS,
                           readable_time=timestamp_to_string)


@app.route('/submit', methods=['POST'])
def submit_textarea():
    """
    Endpoint to create a new transaction via our application.
    """
    has_pending = True
    post_content = request.form["content"]
    author = request.form["author"]
    price = request.form["price"]
    start = request.form["start"]
    end = request.form["end"]
    number = request.form["number"]

    post_object = {
        'author': author,
        'content': post_content,
        'price':price,
        "number":number,
        "start": start,
        "end": end
    }

    # Submit a transaction
    new_tx_address = "{}/new_transaction".format(CONNECTED_NODE_ADDRESS)

    requests.post(new_tx_address,
                  json=post_object,
                  headers={'Content-type': 'application/json'})

    global post
    post = post_object
    post["timestamp"] = time.time()
    post["unique_id"] = author+price+number+start+end+post_content

    return render_template('index.html',
                           title='Ride Request Site',
                           post=post,
                           confirmed_posts=confirmed_posts,
                           replies=replies,
                           node_address=CONNECTED_NODE_ADDRESS,
                           readable_time=timestamp_to_string)


def timestamp_to_string(epoch_time):
    return datetime.datetime.fromtimestamp(epoch_time).strftime('%H:%M')

@app.route('/signup', methods = ['POST'])
def signup():
    global replies
    replies.append(request.form['reply'])
    print("One driver is interested!")

    return render_template('index.html',
                           title='Ride Request Site',
                           post=post,
                           replies=replies,
                           confirmed_posts=confirmed_posts,
                           node_address=CONNECTED_NODE_ADDRESS,
                           readable_time=timestamp_to_string)
