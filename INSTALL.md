
## Installation

### Installing Oracle Java

You can run elasticsearch with `openjdk-7` (such as the `openjdk-7-jre-headless` which ships with ubuntu); however elasticsearch recommend you use `oracle-7`.

Some Elasticsearch documentation can naturally fall out-of-date, for definitive info on the latest supported java versions, use the following link: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup.html#jvm-version

To install `oracle` java on `ubuntu`:

```bash
sudo apt-get remove 'openjdk-7-jre*';
sudo add-apt-repository ppa:webupd8team/java;
sudo apt-get update;
sudo apt-get install oracle-java7-installer;
```

### Install ElasticSearch Service (debian/ubuntu)

**Always use the latest version over the one specified here**

```bash
sudo apt-get update
cd /tmp
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.4.deb
sudo dpkg -i elasticsearch-1.7.4.deb
sudo service elasticsearch start
```

### Set Elasticsearch to start at boot time
`@ref` http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-service.html
```bash
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start
```

### Building from Source (advanced users only)

```bash
sudo apt-get update
sudo apt-get install maven
cd /tmp
git clone git@github.com:elasticsearch/elasticsearch.git
cd elasticsearch
mvn clean package -DskipTests -e
cd releases/elasticsearch*
./bin/elasticsearch
```

### Configure Elasticsearch

You should tune your `ES_HEAP_SIZE` to half your available RAM. '@ref' https://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html

On `ubuntu` you can change this setting by editing `/etc/init.d/elasticsearch` and then restarting the service with `sudo service elasticsearch stop; sudo service elasticsearch start`

### Confirm Install

```bash
curl 127.0.0.1:9200
```
You'll see output similar to the following:
```javascript
{
  "status" : 200,
  "name" : "Iron Man",
  "version" : {
    "number" : "1.3.4",
    "build_hash" : "a70f3ccb52200f8f2c87e9c370c6597448eb3e45",
    "build_timestamp" : "2014-09-30T09:07:17Z",
    "build_snapshot" : false,
    "lucene_version" : "4.9"
  },
  "tagline" : "You Know, for Search"
}

```

### EsRejectedExecutionException in ES > `1.2.1`

If you experience the error `EsRejectedExecutionException` during imports you may be able to fix this with:

```bash
curl -XPUT localhost:9200/_cluster/settings -d '{
    "persistent" : {
        "threadpool.bulk.queue_size" : 250
    }
}'
```

### Install node.js

There are many ways to install npm/node.js, but the following is one of the most simple and straightforward:

```bash
cd /tmp
wget https://raw.githubusercontent.com/isaacs/nave/master/nave.sh
sudo env SHELL=`which bash` bash nave.sh usemain stable
```

### Confirm Install

**Always use the latest version over the one specified here**

```bash
node --version
v0.10.42

npm --version
3.7.3
```

**note** you should be running `at least` npm `1.4+`
