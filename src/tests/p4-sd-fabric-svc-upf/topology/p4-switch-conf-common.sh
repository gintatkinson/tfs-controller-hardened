#!/bin/bash

# Physical interfaces
HOST_IFACE_EXT="mgmt"      # Interface towards TFS (management)
SW_IFACE_DATA_LEFT="dp-1"  # Interface towards the 5G gNB (data plane)
SW_IFACE_DATA_RIGHT="dp-2" # Interface towards the Data Network (data plane)

# Subnets managed by the switch
DOMAIN_IP_LEFT="10.10.1.1/24"  # Left-hand  side subnet (5G gNB)
DOMAIN_IP_RIGHT="10.10.2.1/24" # Right-hand side subnet (DNN)

# Transport port where the P4Runtime gRPC server is deployed on the switch
SW_P4RT_GRPC_PORT="50001"

# Transport port where the P4Runtime gNMI server is deployed on the switch
SW_P4RT_GNMI_PORT="50000"

# Transport port where Stratum listens to local calls
SW_P4RT_LOCAL_PORT="50101"
