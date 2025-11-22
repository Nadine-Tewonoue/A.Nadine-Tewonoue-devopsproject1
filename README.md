# A.Nadine-Tewonoue-devopsproject1

1-Multiple Micro-Services Voting Application
The app is a micro-services app where users can cast their favourite pet : cats or dogs. We have a vote page and a result page. These are the two services that are meant to be seen by the end-user. The other micro-services are meant to be private and handled only internally, to enable security.

Part 1.1 - Cloning the Application
Part 1.2 - Dockerizing the Applications
Key Points About the Dockerfiles:
vote (Python): The provided Dockerfile installs dependencies via pip, sets up the Python environment, and uses gunicorn for a production-ready server. There’s also a dev stage allowing you to run the application with file watching.
result (Node.js): The Dockerfile installs dependencies, uses nodemon for development, and runs the Node.js server on port 80.
worker (.NET): The Dockerfile uses multi-stage builds to restore, build, and publish a .NET 7 app, then runs it in the runtime-only container.

Part 2 - Provisioning Infrastructure Using Terraform
Now that you understand and can run everything locally, you will provision the required infrastructure on AWS using Terraform.

Application Distribution
Instance A (Application Tier - Frontend):
An EC2 instance launched in any AZ that runs the Vote (Python/Flask) and Result (Node.js/Express) services.

Instance B (Data/Backend Services): Runs Redis and the Worker (.NET) in a private subnet (single AZ or multi-AZ for high availability).

Instance C (Database Tier): Runs PostgreSQL in its own private subnet, optionally with a read-replica in a second AZ.

Setting up the Infrastructure
Infrastructure Setup:
Create a VPC with one public subnet in any AZ and one private subnet in any AZ.
Create your EC2 instances:
A in a public subnet from Vote + Result, this instance will be used as a Bastion Host
B in a private subnet for Redis + Worker
C in a private subnet for PostgreSQL
Create Security Groups for each tier, locking down inbound/outbound traffic as outlined below.
Public Subnets: Place the instance A here so it’s internet-accessible.
Private Subnets: Place instances B and C in private subnets. They should not be directly exposed to the internet.
Desired Layout:

Security Groups:
Vote/Result SG: Allows incoming HTTP/HTTPS from the internet.
Redis/Worker SG: Allows inbound traffic from Vote/Result EC2 to Redis port (6379), and allows outbound to Postgres.
Postgres SG: Allows inbound traffic on port 5432 only from the Worker SG (and possibly from Vote/Result if needed directly).
Remote State and Locking:

Store your terraform.tfstate file in a remote backend and enable state locking with DynamoDB or a similar mechanism.


Part 3 - Configuration Management with Ansible