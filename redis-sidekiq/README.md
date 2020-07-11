Phew. Redis and Sidekiq. 

I've got a ticket where I have to push data from a Rails app to Salesforce, which relies on background jobs to do the heavy lifting.

When you run `foreman start` and you get:

```
You are connecting to Redis v3.2.9, Sidekiq requires Redis v4.0.0 or greater
```

run `brew upgrade redis`

Then:

```
PG::ConnectionBad: could not translate host name "postgres" to address: nodename nor servname provided, or not known
```
Run:

```
$ brew postgresql-upgrade-database
```

And/or file up your local Postgres app and check for updates. 

Here's another error you might get:

![Redis server not running, causing error](/images/redis/redis-server-not-running.jpg)

Once it's all running, you can go to http://localhost:3000/admin/sidekiq and see your sidekiq dashboard. 

It's critical that you have redis running locally before you try to start sidekiq.

You know how visitting localhost:4000 won't work unless you have your rails console going?

Same thing happens under your hood when you boot up sidekiq workers.

### Foreman

We use `foreman` to start the app. Foreman reads out of a "process file", called a `Procfile`, which lives at the root of the application:

Go ahead and look at the Profile at the root of _this_ project:

```
text: echo "hi there!"
```
now run `foreman start`

you should see somethting like this:

![foreman start](/images/redis/procfile-01.jpg)


So, back to redis/sidekiq. If you try to do `foreman start` and get an error about redis not being available:

do:

```shell
# to start redis, but is a "blocking" process and takes over the tab:
$ redis-server

# to start redis, but make it a background process, so it doesn't take over the tab:
$ redis-server &

# to stop redis
$ redis-cli shutdown
```

So, once you've got Redis running (and I have it running as a background process), feel free to poke around.

Lets start a redis command line interface session:

```shell
$ redis-cli
127.0.0.1:6379> ping
PONG



127.0.0.1:6379> help
redis-cli 6.0.4
To get help about Redis commands type:
      "help @<group>" to get a list of commands in <group>
      "help <command>" for help on <command>
      "help <tab>" to get a list of possible help topics
      "quit" to exit

To set redis-cli preferences:
      ":set hints" enable online hints
      ":set nohints" disable online hints
Set your preferences in ~/.redisclirc
```

cool. we'll come back to this later. For now, lets leave the tab running with:

```shell
redis-cli monitor
```

From the [Redis docs about `monitor`](https://redis.io/commands/monitor):

> MONITOR is a debugging command that streams back every command processed by the Redis server. It can help in understanding what is happening to the database. This command can both be used via redis-cli and via telnet.
> 
> The ability to see all the requests processed by the server is useful in order to spot bugs in an application both when using Redis as a database and as a distributed caching system.


So, we've got Redis running, we're "monitoring" it, lets fire up our sidekiq server locally!

If your Procfile has a reference to `worker` or `sidekiq`, it'll probably be running with Redis:

```
$ foreman start
```

My `foreman start` command kept ending with this:


![foreman start failing](/images/redis/procfile-02.jpg)

So, I looked at the Procfile. The `release` line was:

```shell
# Procfile
.
.
release: bin/rake db:migrate
```
So I deleted that line. (I'm not planning on commiting this change, of course. Just making local modifications to get up and running.)

Lets go take a look at the tab running `redis-cli`. It'll look like about 1x/second, a bunch of activity happens, with lots of references to `brpop`, `hget`, `sscan`, etc.

![redis-cli gif](/images/redis/redis-cli-monitor.gif)

I don't know what all of this is and what it means, but my mental modal of Redis puts it very close to... a very eager database, which is running, and listening in the background for anything you might ask it to do. 

As an aside, I'd recommend [Sidekiq and Background Jobs for Beginners](https://josh.works/sidekiq-and-background-jobs-in-rails-for-beginners). I wrote it a few years ago, this material and that will strongly overlap. 

That post accounts for about half of the traffic my website gets, from all over the world, so I think there's value to it.

------------------

If you ever 'lose' your redis server, and it's running somewhere on your laptop and you want to kill it, or restart it, or the tab it was in gets closed.... you can use the `Process Status` CLI tool to find it. 

```
$ ps aux | grep redis
```

When you run that command, the results can be a little counter-intuitive:

![ps aux grep redis](/images/redis/ps-aux-grep-redis.jpg)

the first line is very long, and usually wraps to the second line. It's the one that has `grep --color=auto...` in it. 

Lets break this down:

`ps` is `Process Status`

`aux`:

```
a => show processes for all users
u => display the process's user/owner
x => also show processes not attached to a terminal
```

[source](https://unix.stackexchange.com/a/106848)

So, if we run the `ps aux` command, you'll see a ton of output. (go ahead, run `ps aux` in your terminal. make sure to scroll up to the beginning of the output. )

The `| grep` filters results down to just what matches the given string, like `redis`.

Anyway, since we're `grepping` for `redis`, AND there's a `redis-server` running, we get two results from `ps aux | grep redis`

1. the `grep` process, searching the output of `ps aux`
2. The `redis-server` process, which matches the `grep`. 

Anyway, the first number that comes back, after your username, is the "process ID" or `PID` of the redis process. 

If you want to kill the process, you can use `kill <pid>`, like so:

![kill redis](/images/redis/kind-kill-redis-server-ps-aux.jpg)

------------------------------------

 
So, once you’ve got redis running, to watch the logs for JUST hsets and lpushes, run:

```
redis-cli monitor | grep -E "(hset|lpush)"
```

run `tldr grep` in your terminal to see the "too long, didn't read" overview of `grep`, to see what that `-E` flag does!

`tldr` returns `command not found`?

Go ahead and install it! [https://github.com/tldr-pages/tldr](https://github.com/tldr-pages/tldr)

or do `brew install tldr`


What does `hset` and `lpush` do?

- [redis docs for `hset`](https://redis.io/commands/hset)
- [redis docs for `lpush`](https://redis.io/commands/lpush)


lead = Lead.new( city: "Golden", email: "thompsonjoshd+leadtest03@gmail.com", kind: "match", name: "Josh Thompson", sent_at: Time.current )













### Resources

- [Sidekiq and Background Jobs for Beginners](https://josh.works/sidekiq-and-background-jobs-in-rails-for-beginners)
- [PG::ConnectionBad: could not connect to server: No such file or directory](https://medium.com/@yutafujii_59175/pg-connectionbad-could-not-connect-to-server-no-such-file-or-directory-9a2eada16f9)
- [could not translate host name "postgres" to address: nodename nor servname provided, or not known](https://github.com/instructure/lti_tool_provider_example/issues/4)