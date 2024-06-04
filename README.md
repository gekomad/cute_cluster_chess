Cute Cluster Chess
=============
Cute Cluster Chess (CCC) is a Chess Engine Testing Framework for **Linux**.

CCC creates a cluster of Linux nodes on an intranet and uses ssh key sharing to access individual nodes. 
But don't worry, the configuration is very simple and is automatic through a web interface. The _nodes_ must already have `git` and an `ssh server` installed (on Ubuntu you can install this with `sudo apt install openssh-server`). 
Instead, `git`, `Python 3` and `sshpass` must be installed on the _master_ node.

How does it work.
---
On the GitHub repository of your chess engine there must be a branch named `base`, it will be the stable version of your engine that you want to improve, then create other branches with the changes to test, these branches must begin with the prefix `_test_/` for example: do you want to test a change to _null moves_? and one to the _quiescence_ function? then create 2 branches `_test_/null` and `_test_/qs` you can create as many branches as you want.
CCC will automatically download these branches and will start playing them against the "base" version through cutechess-cli.

CCC uses crontab to check if there are branches to test (this check is suspended during testing).

Caveats
-----

Before launching CCC, verify that `python 3`, `sshpass` and `git` are installed on the _master_ node with:

```
python --version

sshpass -V

git --version
```

and check that `git` is installed on the _nodes_ and `sshd` is active (just launch `ssh {user}@{ip_node}` from the master node if it asks you for the password and is configured correctly).

If your GitHub repository is **private** verify that individual nodes and the master node can clone your repository.

Let's go
----

On the master node download the source code start the server passing random login/password:
```
git clone git@github.com:gekomad/cute_cluster_chess.git
cd cute_cluster_chess/web
./server.py {login} {pass}
```

open your browser to the page `http://{ip_master}:8395 ` 
enter {login} {pass}

At the first start, only the `Settings` tab will be shown. Fill in these fields:

- GitHub repository: it is the repository of your chess engine (it must start with git@github.com:... and not with ht<span>tps://github.com...)
- Opening epd file: select the file with the openings you see under cute_cluster_chess/epd, you can add your files and restart the server.
- Resign: is the Resign parameter of cutechess-cli.
- Draw: is the draw parameter of cutechess-cli.
- Time Control: is the tc parameter of cutechess-cli.
- Hash size: it is the size in MB of the hash table.
- Concurrency: it is the Concurrency parameter of cutechess-cli, it indicates how many instances of cutechess-cli will be launched in parallel.
- Variant: is the Variant parameter of cutechess-cli.
- Tot Games: is the number of games for each node
- Path to compile: the folder from which to launch the compilation command, if you use make it is probably `src` if you use rust it is probably `.`
- Build command x86_64: you can leave it blank. is the command to generate the executable for the `x86_64` architecture, it could simply be `make`, or `cmake CMakeLists.txt && make` or `cargo build --release`. Remember the compiler must be present on the various nodes (gcc, g++, cardo, rustc, cmake, make, etc).
- Build command aarch64: you can leave it blank, as above but for the `aarch64` architecture. At least one of the two previous fields must be completed.
- exe Relative Path: it is the path of the executable starting from the root of the project, if your sources are in the `src` folder and you use the `make` command to compile the path will be `src/engine_name`, if your engine it is written in rust probably the path will be `target/release/engine_name`.
- First param: is the cutechess-cli `option.FOO=BAR` parameter of the first engine.
- Second param: is the cutechess-cli `option.FOO=BAR` parameter of the second engine.


Add nodes
----

- After configuring go to the 'cluster' tab and click on `Add new`, then enter:

- ip/host: is the address of the insurance node that can be reached via ssh
- user: this is the linux user, it might be a good idea to create a specific user for CCC
- port: it is the ssh port, you can leave it blank
- password: it is the password of the linux user. The password will be used to connect via ssh to the node and add the ssh key in this mode the master node will be able to access the node without a password. The password will not be stored.
- CPU: indicates how many CPUs will be dedicated to tests.

Click `Add Node`

insert as many nodes as you want. Finally click on `Start All`

   The `Tests` tab indicates the currently active tests.

Uninstall nodes
----
  - go to the `Cluster` tab and click `Remove node`, this will delete the `~/cute_cluster_chess_node` folder.
  - on the node run `crontab -e` and delete the line relating to CCC.
  - on the node open the file `~/.ssh/authorized_keys` and delete the name relating to the master, in this way the master will have to enter the password again in order to access the node via ssh.