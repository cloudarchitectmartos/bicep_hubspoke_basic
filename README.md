# Project Goal
To deploy a simple architecture allowing two virtual machines, isolated by virtual networks to communicate with each other via a Hub Network.

## Project Inputs
1 Hub and 2 Spoke Networks
Network Security Group at Subnet Level.
IP Networking Requirements:
- VNET Private IP - 10.0.0.0/24
- Subnet #1: Hub Network - 10.0.1.0/26
- Subnet #2: Spoke 1 - 10.0.20.0/26
- Subnet #3: Spoke 2 - 10.0.30.0/26