# On-Demand Scaling

[Track Milestone Here](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3Apelias+milestone%3A%22On-Demand%20Scaling%22)

## Overview

Design and implement an automated scaling infrastructure that allows us to quickly spin up additional instances based on system load.

## Functionality

### Monitoring

Setup infrastructure that detects when usage is approaching critical thresholds and triggers warnings. 

- The critical thresholds must be configurable.
- The trigger warnings must be configurable and allow for easy plug-n-play setup of new triggers.

### Scaling

All scaling processes must be accessible via an automated interface and require no manual intervention, unless desired for one-off purposes. There must be a manual trigger for each scaling process, as well.

#### Grow

The new scaling infrastructure must be capable of adding predictable capacity to the service in under 10 minutes (less is obviously more here). 

- Monitoring triggers must kick off scaling processes when a critical usage threshold is hit.
- It must be known how much throughput each grow process will introduce.
- There must be a way to specify how many "steps" to grow by.

#### Shrink

The new scaling infrastructure must be capable of decreasing available capacity of the service in under 10 minutes. 

- Monitoring triggers must kick off scaling processes when a critical usage threshold is hit.
- It must be known how much throughput each shrink process will take away.
- There must be a way to specify how many "steps" to grow by.

## Documentation

Internal documentation of the new framework and all available options must be written up.

## Validation

This framework should be reproduceable and validation should be done by spinning up an isolated instance of Pelias and pushing it to its limits and growing and shrinking the service as needed.