# Kafka Docker Image

## Configuration
The configuration for the kafka server (`${KAFKA_HOME}/conf/server.properties`) is generated from the template `server.properties.tmpl`, itself based on the standard kafka configuration.

Every variable not overridden defaults to the value set in the distribution-supplied kafka `server.properties` config.

To override a variable, you need to set its corresponding environment variable. To derive the environment variable name, take a configuration option, e.g. `num.network.threads`, and then: 

  1. substitute each period (`.`) with an underscore (`_`)
  2. prefix it with `cfg_`. 

For example, `num.network.threads` becomes `cfg_num_network_threads`.

Any variable supplied as an environment variable prefixed with `cfg_` will be available from within the server configuration template - the mapping from env-variable to configuration-option detailed above is simply a convention.

### Required environment variables
  * `cfg_broker_id` - sets the kafka broker id
  * `cfg_zookeeper_connect` - a CSV list of ZK servers (& their chroot) to use for the kafka cluster
    * each entry has the format `<hostname>[:port][/<ZK-chroot>]