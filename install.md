
## Installation

### Install ElasticSearch (debian/ubuntu)

```bash
sudo apt-get update
sudo apt-get install openjdk-7-jre-headless -y
cd /tmp
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb
sudo dpkg -i elasticsearch-1.1.1.deb
sudo service elasticsearch start
```

### Confirm Install

```bash
curl http://127.0.0.1:9200
```

```javascript
{
  "status" : 200,
  "name" : "Hindsight Lad",
  "version" : {
    "number" : "1.1.1",
    "build_hash" : "f1585f096d3f3985e73456debdc1a0745f512bbc",
    "build_timestamp" : "2014-04-16T14:27:12Z",
    "build_snapshot" : false,
    "lucene_version" : "4.7"
  },
  "tagline" : "You Know, for Search"
}
```

### Install node.js

```bash
cd /tmp
wget https://raw.githubusercontent.com/isaacs/nave/master/nave.sh
sudo bash nave.sh usemain stable
```

### Confirm Install

```bash
node --version
v0.10.26

npm --version
1.4.3
```

### Install npm dependencies

```bash
npm install
```