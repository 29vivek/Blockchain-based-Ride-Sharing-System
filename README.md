# Blockchain-based Ride Sharing System 

CS143 Computer Networks Final Project

Shuyuan X, Weiru C, Wenlin G

## Instructions to run

Clone the project,

```sh
$ git clone https://github.com/WenlinG28/Blockchain-based_Ride_Sharing_System.git
```

Install the dependencies,

```sh
$ cd Blockchain-based_Ride_Sharing_System
$ pip install -r requirements.txt
```

Start a blockchain node server,

```sh
# Windows users can follow this: https://flask.palletsprojects.com/en/1.1.x/cli/#application-discovery
$ export FLASK_APP=node_server.py
$ flask run --port 8000
```

One instance of our blockchain node is now up and running at port 8000.


Run the application on a different terminal session,

```sh
$ python run_app.py
```

The application should be up and running at [http://localhost:5000](http://localhost:5000).

To play around by spinning off multiple custom nodes, use the `register_with/` endpoint to register a new node. 

Here's a sample scenario that you might wanna try,

```sh
# Make sure you set the FLASK_APP environment variable to node_server.py before running these nodes
# already running
$ flask run --port 8000 &
# spinning up new nodes
$ flask run --port 8001 &
$ flask run --port 8002 &
```

You can use the following cURL requests to register the nodes at port `8001` and `8002` with the already running `8000`.

```sh
curl -X POST \
  http://127.0.0.1:8001/register_with \
  -H 'Content-Type: application/json' \
  -d '{"node_address": "http://127.0.0.1:8000"}'
```

```sh
curl -X POST \
  http://127.0.0.1:8002/register_with \
  -H 'Content-Type: application/json' \
  -d '{"node_address": "http://127.0.0.1:8000"}'
```

This will make the node at port 8000 aware of the nodes at port 8001 and 8002, and make the newer nodes sync the chain with the node 8000, so that they are able to actively participate in the mining process post registration.

To update the node with which the frontend application syncs (default is localhost port 8000), change `CONNECTED_NODE_ADDRESS` field in the [views.py](/app/views.py) file.

Once you do all this, you can run the application, create transactions (post messages via the web inteface), and once you mine the transactions, all the nodes in the network will update the chain. The chain of the nodes can also be inspected by inovking `/chain` endpoint using cURL.

```sh
$ curl -X GET http://localhost:8001/chain
$ curl -X GET http://localhost:8002/chain
```

## Instructions to test smart contracts with Truffle

Install Python3 and NodeJS v8.9.4 or later for installing `truffle`.

Inside this project, install `truffle`:

```sh
$ npm install truffle
---------------------
# Once the installation process is finished, you should see something like this
+ truffle@5.1.57
```

Then use the the `truffle` CLI tool to initialize a smart contract project:

```sh
$ ./node_modules/.bin/truffle init
# if truffle was installed globally (npm install -g truffle): $ truffle init
```

Since we already have smart contracts and unit tests for the smart contracts written in this project, enter N for both `? Overwrite contracts? (y/N)` and `? Overwrite test?` during the initialization process.

The above commands will create the following project structure:
* `<span style="color:red;">contracts/</span>`: Directory for Solidity contracts source code (`<span style="color:red;">.sol</span>` files).
* `<span style="color:red;">migrations/</span>`: Directory for contracts migration files.
* `<span style="color:red;">test/</span>`: Directory for test files. Won't be covered in this tutorial.
* `<span style="color:red;">truffle.js</span>`: Truffle configuration file.

`contracts/` and `migrations/` folders will already contain a Migration contract and its deploy script (`1_initial_migration.js`). This contract is used by truffle to keep track of the migrations of our contracts.


