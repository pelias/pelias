# Local Installation of Pelias

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22Local%20Installation%22)

## Overview

Implement a simple installation process for a small local instance of Pelias designed for testing or working with small regions on a personal computer.

## Functionality

### Import Filters

#### Area
User must be able to limit the install process to a region by specifying either of the following:
    - the area's bounding box
    - the area's Who's on First ID
When the installation is limited in either of the above ways, only the relevant data should be downloaded and used in the build process.

#### Data Sources
User must be able to limit the install process to only desired data sources. For instance, one should be able to only import OpenAddresses data and avoid all others.
