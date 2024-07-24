# Eifa Gateway

Eifa Gateway is a Golang-based HTTP proxy server that communicates with backend servers using the **Eifa protocol** over TCP or gRPC. It includes features such as latency monitoring, server weight adjustment, load balancing, and subscription-based monitoring.

## Terminology
- **Eifa Protocol:** communication protocol over TCP or gRPC used for exchanging data between the **Eifa Gateway** and **Eifa Proxy**
- **Eifa Gateway**: service that acts as an HTTP proxy server communicating with **Eifa Proxy** backend servers. 
- **Eifa Proxy:** service that install on backend servers and communicating with **Eifa Gateway**

## Features

- **HTTP Proxy Server**: Acts as an HTTP proxy server.
- **Eifa Protocol**: Communicates with backend servers using the Eifa protocol (TCP or gRPC).
- **Installation Options**:
  - Can be installed as a service or as a container using Docker Compose.
- **Latency Monitoring**:
  - Periodically checks latency and adjusts backend server weights accordingly.
- **Load Balancer**:
  - Balances load between servers based on their weights.
- **Monitoring Options**:
  - Subscribes server status changes (e.g., broken, added, removed) based on the `brokenThreshold` configuration.
  - Provides metrics such as top hosts.
- **Subscription Channels**:
  - Supports multiple subscription channels like Telegram bot or standard logging.
- **Rules Configuration**:
  - Allows setting rules to direct or block specific hosts from being proxy.
- **Configuration**:
  - All configurations can be customized and set in the `config.yml` file located in the root of the project.


## File Structure

- **config.yml:** contains all configurations for the service.
- **server-list.yml:** includes the status of **Eifa Proxy** servers, along with their weights and latency information that the *watcher* component attempts to update.

## Installation
You can install and run the **Eifa Gateway** service either as a standalone service or within a container, depending on your preference.

### Service Installation
- Replace `<version>` with your specific version:
```bash
bash <(curl -Ls https://raw.githubusercontent.com/erfan-272758/eifa-gateway-deploy/main/service/install.sh) <version>
```

### Docker Compose Installation
- Replace `<version>` with your specific version.
- Make sure you have Docker and Docker Compose installed on your system:
```bash
bash <(curl -Ls https://raw.githubusercontent.com/erfan-272758/eifa-gateway-deploy/main/docker/install.sh) <version>
```


## Configuration

The `config.yml` file contains various settings to configure the behavior and functionality of the service. below is a breakdown of the available configuration options:

- **Environment**:
  - `env`: specify the environment (e.g., `production`, `development`) to clarify system behavior and logging.

- **Time Zone**:
  - `timeZone`: set the timezone for log timestamps and cron jobs.

- **Logging**:
  - `log`:
    - `enable`: enable or disable logging.
    - `level`: set the logging level (`0` for error, `1` for info, `2` for verbose).

- **Server**:
  - **HTTP**:
    - `enable`: enable or disable the HTTP server.
    - `port`: specify the port on which the HTTP proxy server listens.

- **Authentication**:
  - `auth`:
    - `internal`:
      - `enable`: enable authentication between **Eifa Gateway** and **Eifa Proxy** servers.
      - `method`: specify the authentication method.
      - `key`: define the authentication key.

- **Eifa Proxy Servers**:
  - `backend`:
    - `app`: specify the app name of **Eifa Proxy**, dynamic way of setup **Eifa Proxy** servers
    - `ips`: provide an array of IP addresses for **Eifa Proxy**, static way of setup **Eifa Proxy** servers
    - `watcher`: enable or disable the watcher feature.
    - `watcherPeriod`: set the time duration for the watcher (e.g., `1m` for 1 minute).
    - `preferSecure`: prefer secure protocol for communication with **Eifa Proxy**.
    - `brokenThreshold`: specify the latency threshold in milliseconds to determine if an **Eifa Proxy** server is broken.

    - **Server Communication**:
    - `server`
      - `tcp`, `tcp_s`, `grpc`, `grpc_s`:
        - `enable`: enable or disable the communication protocol.
        - `port`: specify the port for the communication protocol.

- **Monitoring**:
  - `monitor`:
    - `enable`: enable or disable monitoring features.
    - `track`:
      - `latency`: track latency and subscribe server status changes based on the `brokenThreshold`.
      - `request`: track requests and save the time of a host request.
      - `metric`:
        - `cron`: set the crontab schedule for metric subscriptions.
        - `topN`: specify the number of top hosts to include in metrics.

    - **Subscription Channels**:
      - `subscribe`:
        - `telNotif`: telegram bot subscription.
          - `enable`: enable or disable Telegram notifications.
          - `token`: specify the bot token.
          - `channelId`: define the channel ID.

        - `log`: logging subscription.
          - `enable`: enable or disable logging subscription.

- **Server List**:
  - `server-list`:
    - `persistStep`: define the interval for persisting server status base on `watcher` steps to `server-list.yml`.

- **Rules**:
  - `rules`:
    - `direct`: define hosts or host patterns that must be directed and not proxy with **Eifa Proxy**.


## Contributing

- Explain how others can contribute to the project.
- Include guidelines for bug reports, feature requests, and code contributions.