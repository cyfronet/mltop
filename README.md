# SPEECHM (codename: mltop)

[SPEECHM](https://speechm.cloud.cyfronet.pl)
(Speech Performance Evaluation Criteria and Holistic Metrics) - a
benchmark to evaluate multimodal downstream tasks. Automated metrics available
in a centralised evaluation server allow a quick and accessible approach to
evaluate and compare different models. Besides the pure performance evaluation,
we also intend to assess additional aspects of the models, such as real-time
factors, biases, privacy awareness and the integration of additional context.

## Dependencies

asdf-vm can be used to install dependencies below. [(asdf guide)](https://asdf-vm.com/guide/getting-started.html)

Then add required plugins:

* MRI (`asdf plugin add ruby`)

Next run `asdf install`

Further dependencies
* PostgreSQL (`sudo apt-get install postgresql`)
* PostgreSQL libpq-dev (`sudo apt-get install libpq-dev`)

## DBMS Settings

You need to create user/role for your account in PostgreSQL. You can do it
using the 'createuser' command line tool. Then, make sure to alter this user
for rights to create databases.

For example:
`sudo -u postgres createuser name -s`

## Synchronizing test sets

We are storing test sets on the Ares HPC system. To fetch it from the cluster
and upload it to the application runn following command:

```
./bin/rails test_sets:synchronize
```

At the beginning it will synchronize your test sets files with the one stored on
the cluster (by using `rsync` command). Next, test sets will be imported to the
application (files are stored in active storage).

## Running in development mode

You need to have `config/credentials/development.key` file to run an application in development
mode. Contact @mkasztelnik for details.

To make database preparation and dependencies you can use:

```
./bin/setup
```

To start only web application run:

```
bin/dev
```

Now you can point your browser into `http://localhost:3000`.


## ngrok
While you're developing locally, there still needs to be a way for the cluster to contact the server.
This is because `evaluations` contacts cluster to download hypotheses, ground truth files, and upload metrics scores.
To achieve it, we're using ngrok. It enables you to get `localhost` out in the world.

First you have to [install and setup ngrok](https://ngrok.com/download)

Then, open terminal and run this command - your local server should be running!
```
ngrok http 3000
```
After you make a request to your localhost server, ngrok server should start working.
You can find the url to it in the terminal where you ran the command above.

We are automatically discover ngrok URL and extract host from it. If you want to
override you can set `HOST` environment variable:

```bash
export HOST=mltop.public.host
```

## ENV variables

To customize the application you can set the following ENV variables:

  * `HOST` - Application host used in `*_url` helpers.
    Default is set to `127.0.0.1`.
  * `SENTRY_DN` - if present Portal will sent error and performance
    information to Sentry

## Testing

Some tests require Chrome headless installed. Please take a look at:
https://developers.google.com/web/updates/2017/04/headless-chrome for manual. To
install chrome on your debian based machine use following snippet:

```
curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >
/etc/apt/sources.list.d/google.list

apt-get update -q
apt-get install -y google-chrome-stable
```

To execute all tests run:

```
./bin/rails test
./bin/rails test:system
```

## Becoming an admin

We don't deliver roles management UI yet. To promote the regular user to an
admin you need to user rails console (`./bin/rails c`) and then:

```
User.find_by(email: "user@email").update(roles: [:admin])
```

## Populating database with fake data

To setup development database and populate it with generated data run:

```
./bin/rails dev:recreate
```

It will drop existing database, create a new one and populate with generated
data. Since the generated models need to be linked with the user script needs to
create user entry in advance. To link created user entry with you account please
add following entry into `.env` file.

```
UID=your-user-uid-from-keycloa
```

The simples way to discover your PLGrid SSO UID is to start the application with
blank database, login though the PLGrid and inspect your UID by invoking
following command in the rails console:

```ruby
User.first.uid
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`)
5. Create new pull request
6. When feature is ready add reviewers and wait for feedback (at least one
   approve should be given and all review comments should be resolved)
