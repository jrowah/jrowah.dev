%{
    slug: "system-design-concepts",
    title: "Beyond Syntax: A Self-Taught Developer's Journey into System Design",
    description: "The introductory part of a series of blogs posts about system design concepts in software development every self-taught software developer needs to master.",
    tags: ["System Design", "Databases", "DNS", "Proxies", "Latency", "Scaling", "Load Balancing", "Database Indexing", "Replication", "Sharding", "partitioning", "cashing", "CDN", "web sockets", "webhooks", "microservices", "message queuing", "rate limiting", "idempotency"],
    hero_image: "/images/2025/system_design_concepts.jpg",
    published: true
}

---

## Introduction


Hi, and welcome. I'm @Jrowah, a self-taught software developer. If you're like me or on a similar journey, you'll find this series valuable.

Most of us start by learning "how to code"—mastering language syntax, understanding frameworks, and building applications that work. But then we reach a point where we realize there's a crucial next level: understanding the *why* behind software design decisions.

The questions that spark this exploration include:

* Your app works fine with 100 users, but crashes with 10,000—what architectural decisions could have prevented this?
* When should you choose PostgreSQL over MongoDB, and when might Redis be the better option entirely?
* Why do some companies use microservices while others stick with monoliths—and how do you decide what's right for your situation?
* Your database queries are getting slower as data grows—is the solution better indexing, query optimization, or a completely different data strategy?
* How do you handle real-time features like chat or notifications without bringing your server to its knees?
* What's the difference between horizontal and vertical scaling, and why does it matter for your wallet and your sleep schedule?

These are the kinds of questions that separate developers who can build functional applications from those who can architect robust, scalable systems. That's why I'm embarking on this article series about system design—to bridge that gap in my understanding, and hopefully yours too.

Join me as we dive deep into the principles, patterns, and trade-offs that drive real-world software architecture decisions.

I will write about the topics that I am going to briefly mention below shallowly and then later dig deep on individual topic in its own article. It begins with the simple client - server architecture and finishes up with more complex topics on distributed systems. 

Let's go.

## 1. Client-Server Architecture
The series begins with a simple foundation;
### Basic Client-Server Model;
- A look at basic request-response model by clients; web browser, mobile app, crawlers etc,
- Separation of concerns 
- Communication patterns
- State management

### Server
- This will cover physical vs Virtual vs Cloud Servers in order to understand bare metal servers, virtual machines (VMs), cloud instances (AWS EC2, Google Compute), and containerized deployments.
- We will look at how a server receives request, performs necessary operations and sends back a response.
## 2. Networking Fundamentals
Networking is key to system design and so this will be the next stop, and will cover;
### IP Address
- **IPv4 vs IPv6**; the traditional 32-bit IPv4 addresses (like 192.168.1.1) and the newer 128-bit IPv6 addresses
- Generally, this is how a client knows how to locate a server. Every publicly deployed server has an IP address, that uniquely identifies it. Example; 172.217.170.174 is one of Google's IP addresses.

### DNS (Domain Name System)
- This will cover how DNS maps human readable domain names to ip addresses. When you type google.com on the browser, the browser asks a DNS server for the corresponding IP address 172.217.170.174, which is what the browser uses to establish a connection with google's server.
- DNS Hierarchy; includes understanding root servers, top-level domains (TLDs), authoritative nameservers, and how DNS queries traverse this hierarchy to resolve your application's domain names

Use

```html
ping anydomainname.com
```

to see its IP address.

DNS Record Types covers the essential records you'll work with;
1. A Records map domain names to IPv4 addresses (yourapp.com → 203.0.113.1)
2. AAAA Records map to IPv6 addresses
3. CNAME Records create domain aliases (www.yourapp.com → yourapp.com)
4. MX Records specify mail servers for your domain

### Communication Protocols
I will revisit the good old HTTP/HTTPS; set of rules that govern client-server communications. 
- HTTP request-response lifecycle
- HTTP security concerns; sends data as texts.
- HTTPS sends data using SSL or TLS protocols

### State Management
- Involves understanding where state lives (client-side vs server-side), session management, and how to handle stateful vs stateless interactions
### Proxies
- A middle man between your device and the internet, and forwards your requests to the target server. It hides your location, thereby keeping your location and identity private. 
## 3. Latency
This is the time it takes for data to pass from one point to another on a network, making it essential in system design. Several factors affect this time delay between a user's action and the server's response; 
### Network Latency
- The time it takes for a data packet to travel across a network and other network latency factors
### Server Latency
- The time the server takes to process the request.

One of the factors that affect latency is physical distance. This is why some organizations have multiple data centers across the world, so that a user gets connected to the server nearest to them. We will look at how to optimize you application in this aspect.
## 4. API Design
I will also look at these middle men that allow client-serve communication and consumption of requests and responses.
Client sends a request to an API hosted on a server, the API process the request, interacts with databases, or other services, and prepares a response, which it sends back using a format, JSON or XML.

We will cover:
### Rest API
Representational State Transfer characterized by;
- Stateless Design
- Every request is independent
- Everything is treated as a resource
- Has limitations; returns more data (solved by GraphQL)
### GraphQL API
Lets clients ask for exactly what they need, nothing more, nothing less. 
When getting a user with their most recent post for example, through a REST API, you might be forced to make multiple requests to different endpoints, while GraphQL enables you to combine these requests into one, and returns exactly what you need.

Limitations
* Required more processing on the server side
* Is not easy to cash as rest

Other important topics here will include;
* API Design and Best Practices
* API Performance and Optimization
* API Error Handling and Reliability
* API Documentation and Developer Experience
* Real-time APIs with Phoenix
• WebSocket APIs
• Phoenix PubSub Integration
• LiveView as API Alternative
•
We will then take a look at API Integration and Consumption.
## 5. Data Storage and Management
After making a request and getting a response, we always want to store, for small applications, we can store them as variables, or a file, and load it in memory. Modern applications handle huge loads of data that can't be stored or handled efficiently in the above ways. How do we design a system that facilitates better storage, management, and access of data?

Enters dedicated server for data storage and management, databases.
We will look at database fundamentals and how they ensure efficient storage, retrieval, and management of data, while maintaining its security, integrity, consistency, and durability.

Types of databases we will look at;
### SQL Databases characterized by;
Store data in structured formats using;
1. predefined schemas
2. ACID properties (Atomicity, Consistency, Isolation, and Durability)
3. strong consistency
4. structured relationships
Then I will need a reminder of popular DBMSs(PostgresSQL, MySQL)
### NoSQL
These are designed for high scalability and performance, and use key-value stores(Redis, DynamoDB), documented stores(MongoDB, CouchDB), wide-column and graph stores

- Choose SQL database if you need structured relational data and strong consistency.
- Choose NoSQL database if you need high scalability and flexible schema

Here I will also look at;
- Database Design Principles
- Transactions and Data Consistency
- Caching Strategies

## 6. Database Scaling Strategies
Now imagine we have a database running our application, but the application is getting large , then what? Here comes the process of increasing or decreasing a system's capacity to handle changing workloads, user numbers, or data volumes without compromising performance or stability.

Key concepts I will look at here include;
### Vertical Scaling
Scaling by adding more CPU, RAM, and Storage to our server machines, this makes a single machine more powerful. Is usually a quick fix and has limitations that we will look at in detail.

Limitations;
* Its impossible to keep upgrading forever as every machine has maximum capacity
* More powerful machines become exponentially more expensive
* If a single server fails, the entire system crashes (single point of failure(SPOF))
### Horizontal Scaling
Involves adding more database servers to share the increasing load, making the system to handle increasing traffic more effectively. If one server crashes, others easily take over.

Benefits of this include;
- Making a system more reliable and fault tolerant.

Bringing a new challenge of how clients knowing which server to connect to, and this is where:
- Will look at distributed architecture and load distribution challenges

- We can also scale databases vertically similar to servers, but there are limits to this as well.

We will also look at other database scaling techniques that can help manage large volumes of data efficiently such as;
### Database Indexing
Speeds up database read queries. Think of this as the index page at the back of a book that helps you jump directly to the relevant page/section of the page instead of flipping through every page.

Indexes are often created on columns that are frequently queried such as primary keys, foreign keys, and columns frequently used in where conditions. 

Important to note that while indexes speed up read operations, they slow down write operations since the index needs to be updated whenever data changes, which is why we should only index the most frequently accessed columns
### Replication
Is another db scaling technique which involves creating copies of our dbs across multiple serves. 
One primary replica handles write operations, others secondary replicas handle read operations, a written database gets copied to the replicas for them to stay in sync. Read requests get spread across multiple replicas. When a primary replica fails, a read replica can take its place.

Some replication strategies are;
- Master-slave replication
- Master-master replication
- Read replicas
### Sharding
Is a method of horizontally scaling databases by splitting large datasets into multiple smaller, more manageable databases, called shards and distribute them across multiple servers.
- Each shard contains a sub-set of the total data, 
- Helps in scaling write operations and mainly helps where the issue is the number of row. 
- Cross-shard queries
- Sharding challenges
### Vertical Partitioning
-  Split the database by columns
- Access pattern optimization
- Join considerations
### Denormalization
- Reduces the number of joins by combining related data into a single table.
- An example would be instead of having users and posts tables, you would have users_orders table that stores users details along with their orders, so we do not need a join operation when retrieving a user's order history. 
- Normally used in read-heavy applications, but leads to increased storage and more complex update requests.
## 7. Load Balancers and Reverse Proxies
We have applied better database management principles through distribution and now we need to ensure requests are fairly distributed across multiple clusters. We will look at how a load balancer sits between clients and backend servers, and acts as a traffic manager, that distributes requests across multiple db servers.

A reverse proxy kind of protects the server, and intercepts client requests and forward to the servers following a set of predefined rules. We will dig deep into these as well.

We'll tackle load balancing algorithms that enables them know which requests to redirect to which server;
* Round-Ribon
* Least Connections
* IP hashing
## 8. Cashing Strategies
To further ensure our system runs smooth, we need to ensure data retrieval happens faster, and doing this from memory is usually much faster than from databases.

This is the perfect opportunity to introduce cashing. We will look at how cashing helps by storing frequently accessed data in-memory (cashe) to optimize system performance, and what mechanisms we use to prevent outdated data from being served, TTL(time to live value).
### Cashing Patterns
- Cashe-aside(Lazy Loading)
- Write-through
- Write-behind(Write-back)
- Refresh-ahead
### Cashe Levels
- Browser Cashe
- **CDN**; it becomes slow when you try to access large files such as say streaming a video from a Blob storage that is on the other side of the world.
In comes the Content Delivery Network, that delivers content faster to users based on their locations.
A CDN is a global network of distributed servers that work together to deliver web content like html pages, javascript files, images, videos etc to users based on their geographic location
- Application level cashe
- Database Cashe
### Cashe Technologies we will cover
- Redis vs Memcashed
- Cashe eviction policies(LRU, LFU, FIFO)
- Cashe warming strategies

## 9. File Storage
We often need to serve large files to our applications. Our database is not designed to storing videos and other large files. How do we handle this?

In comes Blob Storage, under which we will look at;
- Object Storage Systems(AWS S3, Google Cloud Storage)
- Metadata management
- How applications handle large files such as videos, pdfs, and other large files, which relational databases are not designed to store.
- Blobs are like individual files which are stored in large containers in the clouds, where each file gets a unique url, making it easy to retrieve and serve over the web.

We will also take a look at File Systems
- Distributed File Systems(HDFS, GFS)
- Network-attached storage(NAS)
## 10. WebSockets
Sometimes we build applications that demand real time updates such as chat applications and online multiplayer games, what design choices do we make to achieve these effectively?

Here we will look at how websockets solve regular http problems where clients send requests and the server processes it and sends back a response, and if the client needs new data, it must send another request which works fine for static web pages but is too slow abd inefficient for real-time applications like live chat applications, stock market dashboards, online multiplayer games etc.

With HTTP, the only way to get real-time updates is through frequent polling, sending repeated requests every few seconds, which is inefficient as it increases server load and wastes bandwidth. Most responses are also often empty and there is no new data.

In comes websockets, which allow continuos communication between the client and the server over a single persistent connection.

The client initiates a websocket connection with the server, once established, the connection remains open and so the server can send updates to the client at any given time without waiting for a request while the client can also instantly send messages to the server, which eliminates polling, thus enabling real-time communication between a server and a client.
## 11. Webhooks
When a sever needs to inform another server about the occurrence of an event. For example, when a client makes a payment, the payment gateway needs to notify an application, instead of the application constantly polling the gateway to check for any event occurrences, webhooks would allow a server to send an HTTP request to another server as soon as the event occurs.
You app registers a webhook url with a provider, when an event occurs, the provider sends a HTTP POST request to the webhook url with the event details.
## 12. System Architecture Patterns
We will loo at system architecture patterns;
### Monolithic Architecture
- Single Deployable unit
- Advantages and limitations
- When to use monolithic
### Microservices Architecture
Traditional websites were built within a monolithic architecture, where all features are inside one large code base. This works well for small applications, but for larger scale systems, monoliths become a limitation and hard to manage, scale and deploy.
In comes microservices architecture, a solution in which you break down your application into smaller independent services called micro-services that work together.
Each micro-service handling a single responsibility, has its own database and logic, so it can scale independently, and communications with other micro-services is through APIs or message queues. Here we will look at;
- Service decomposition strategies
- Inter-service communication
- Service Discovery
- Data consistency across services 
## 13. Message Queueing and Communication
Solves the limiting aspects of micro services communications through APIs, by enabling micro services to communicate asynchronously thereby allowing requests to be processed without dropping other operations, the queuing helps prevent overload on internal services within our systems.
### Asynchronous Messaging
- Message queues(RabbitMQ, Amazon SQS)
- PubSub Systems
- Message brokers vs event streaming
### Event-Driven Architecture
- Event sourcing
- CQRS(Command Query Responsibility Segregation)
- Saga patterns for distributed transactions 
## 14. Other Distributed Systems Concepts we will look at include;
- CAP Theorem
- Consistency, Availability, Partition Tolerance
- CP vs AP systems
## 15. Security and Reliability

Security isn't an afterthought—it's the foundation that determines whether your application survives in production. A single security vulnerability can destroy years of work overnight, while reliability issues can kill user trust just as quickly.

In this section, we'll explore the essential security and reliability concepts that separate hobby projects from production-ready systems:

### Security Fundamentals & Common Attack Types
Understanding the threat landscape and security principles that guide every architectural decision.
- **Web Application Attacks:** SQL injection, XSS, CSRF, and how they exploit input validation failures
- **Authentication Attacks:** Brute force, credential stuffing, session hijacking, and password spraying
- **Infrastructure Attacks:** Man-in-the-middle, DNS spoofing, and network-based exploits
- **Social Engineering:** How human psychology becomes your weakest security link
- **Supply Chain Attacks:** When trusted dependencies become malicious backdoors
- Defense-in-depth strategy and the principle of least privilege
- Security by design vs. bolted-on security

### Authentication & Authorization
The difference between "who are you?" and "what can you do?" can make or break your data protection.
- Multi-factor authentication strategies
- Role-based access control (RBAC) vs. attribute-based access control (ABAC)
- Session management and token lifecycle

### Modern Authentication Protocols
Understanding why giants like Google and Facebook use these standards for billions of users.
- OAuth 2.0 flows and when to use each
- OpenID Connect for identity management
- JWT tokens: when they're perfect and when they're dangerous

### Data Protection at Every Layer
Data breaches make headlines because most developers get encryption wrong.
- Encryption at rest vs. in transit—and why you need both
- Key management strategies that don't become your weakest link
- Password hashing: why bcrypt beats SHA256 every time

### Infrastructure Security
Your application code might be perfect, but infrastructure vulnerabilities can still sink you.
- HTTPS/TLS implementation and common pitfalls
- Firewall strategies and network segmentation
- VPN architectures for secure remote access

### Resilience Against Attacks
When your system is under attack, these measures determine if you stay online or go dark.
- DDoS protection strategies and rate limiting
- Monitoring and incident response
- Graceful degradation under load

## 16. System Reliability
How do you ensure you design a reliable system? Here we will revisit;
* **Rate Limiting**; helps prevent overload for the public APIs and services.
* Rate limiting restricts the number of requests a client can send within a specific time frame. 
* Every user, or IP address is assigned a request quota eg 100 requests mer minute, which if they exceed, the server temporarily blocks additional requests and throws an error.
Rate limiting algorithms include;
* Fixed window
* Sliding window
* Token bucket algorithm
* Distributed rate limiting
### Circuit Breakers
- Fail-fast mechanism
- Health Checks
- Recovery Strategies
### Bulkhead patterns
- Resource Isolation
- Failure containment
### Retry Mechanisms
- Exponential backoffs
- Jitter
- Idempotency
## 17. API Management
### API Gateways
Helps us so we do not need to implement our own rate limiting systems. An API gateway is a centralized service that handles authentication, rate limiting, logging, monitoring, request routing, etc. In a microservice based application, instead of exposing each service directly to clients, an API gateway can act as a single entry point for all client requests to the appropriate microservice and responses also get sent back to the clients through the gateway 
They simplify API management, improve scalability and security.
Examples;
* Cloudflare API Gateway
* Amazon API Gateways
* NGINX
* Google Apigee
### Idempotency
Network failures, and service retries are common in distributed systems. Take an example, during payment processing, when a user clicks "Pay Now" multiple times due to a slow connection, a system might request two payment requests instead of one. How do you design a system that handles such cases effectively?
This is where **Idempotent systems** come in; they ensure that repeated requests produce the same result, as if the request were made only once
We will look at how this is achieved; where request is assigned a unique id, before processing, the system checks if the request has already been handled, if yes, it ignores the duplicate request, if not, it processes the request normally.

## What's Next?

This introduction covers the roadmap for our system design journey. Each topic will be explored in detail in upcoming posts, with practical examples and real-world applications.

**Part 1 Coming Soon!**

---

*Ready to dive deep into system design? Follow along as we explore each concept with hands-on examples and practical insights.*