# SDMN - Software-Defined Mobile Networking Course Homework
This repository contains homework solutions for the "Software-Defined Mobile Networking" course at Sharif University of Technology. The course is instructed by Dr. Khalaj and Dr. Ravanshid.

This repository is organized into folders, each corresponding to a specific problem or assignment from the course.

## Problem 1: Network Setup

This problem involves setting up a virtual network with multiple nodes and bridges using Linux network namespaces.

**Scripts:**

*   `create_network.sh`:
    *   Creates 5 network namespaces: `node1`, `node2`, `node3`, `node4`, and `router`.
    *   `node1` & `node2` are on the `172.0.0.0/24` subnet.
    *   `node3` & `node4` are on the `10.10.0.0/24` subnet.
    *   The `router` namespace connects to both subnets (`172.0.0.1/24` and `10.10.0.1/24`).
    *   Sets up veth pairs for each node and connects them through two bridges (`br1` and `br2`).
    *   Requires `sudo` privileges to run.
*   `ping.sh`:
    *   A utility script to test connectivity between the created network nodes.
    *   Usage: `./ping.sh <source_node> <destination_node>` (e.g., `./ping.sh node1 node2`).
    *   Requires execute permissions (`chmod +x ping.sh`).
*   `del.sh`:
    *   Cleans up the network environment created by `create_network.sh`.
    *   Deletes the network namespaces and bridges.
    *   Requires `sudo` privileges to run.

**Supporting Files:**

*   `part1.txt`: Discusses routing configurations and alternatives for enabling communication between the namespaces (e.g., explicit routes vs. IP forwarding on bridges).
*   `part2.txt`: Appears to describe an extension or modification to the setup in `part1.txt`, focusing on host routing rules.
*   `ping.txt`: A log file showing example execution of `create_network.sh` and various `ping.sh` commands, demonstrating network connectivity tests.

**Instructions:**
1.  Make the scripts executable: `chmod +x create_network.sh ping.sh del.sh`
2.  Run `create_network.sh` with sudo: `sudo ./create_network.sh`
3.  Test connectivity using `ping.sh`: `./ping.sh node1 node3` (for example)
4.  Delete the network setup: `sudo ./del.sh`

## Problem 2: Container Runtime

This problem features a program that creates a container with isolated **net**, **mount**, **uts**, and **pid** namespaces. By default, it runs a bash shell within this container.

**Core Components:**

*   `main.go`: The Go program responsible for creating the container environment and isolating namespaces. You can modify line 65 of this file to run a different script instead of `/bin/bash` upon container startup.
*   `filesystem.sh`: This shell script prepares the root filesystem for the container.
    *   It downloads an Ubuntu 20.04 base image if not already present.
    *   It creates a directory named `ubuntu_fs` to be used as the container's root directory.
*   `src/images/container_shell.jpg`: An example image showing the container shell in action.

**Instructions to run this program:**

1.  Navigate to the `Problem 2/` directory.
2.  Make the `filesystem.sh` script executable: `chmod +x filesystem.sh`.
3.  Run `filesystem.sh` with `sudo` privileges. You have two options:
    *   To set a hostname: `sudo ./filesystem.sh <hostname>`
    *   To set a hostname and a memory limit (in megabytes): `sudo ./filesystem.sh <hostname> -m <memory_limit_in_megabytes>`

    For example, to run the container with hostname "mycontainer" and a 200MB memory limit:
    `sudo ./filesystem.sh mycontainer -m 200`

For more details, refer to the `Problem 2/README.md` file.

## How to Use This Repository

*   **Navigation:** The repository is organized into folders, with each folder (`Problem 1/`, `Problem 2/`) containing the files and scripts for a specific problem or assignment.
*   **Problem-Specific READMEs:** Some folders (like `Problem 2/`) may contain their own `README.md` files with more detailed instructions and explanations for that specific problem. Be sure to check those for specific guidance.
*   **Scripts:** Most executable tasks are handled by shell scripts (`.sh`) or Go programs (`.go`). Instructions for running these are typically provided within the relevant problem's section in this README or in the problem-specific READMEs.
*   **Permissions:** Remember that you might need to grant execute permissions to shell scripts (e.g., `chmod +x script_name.sh`).
*   **Sudo Privileges:** Some scripts, particularly those dealing with network configuration (`Problem 1`) or containerization (`Problem 2`), require `sudo` privileges to run.

## Contributing

Contributions to this repository are welcome. If you have suggestions for improvements, new solutions, or bug fixes, please feel free to:

1.  Fork the repository.
2.  Create a new branch for your changes.
3.  Make your modifications.
4.  Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
