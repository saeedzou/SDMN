# Problem 2 : Container Runtime
This program creates a container with isolated **net**, **mount**, **uts**, and **pid** namespaces and runs bash in the container.

To run another script when starting the container change the argument of line 65 of *main.go* from *"/bin/bash"* to your arbitrary script

## Instructions to run this program:
    1.  Go to the directory where this file is at.
    2.  Make the filesystem.sh executable.
        This file first downloads the ubuntu 20:04 base image 
        if it doesn't exist in the directory, then creates a directory 
        named ubuntu_fs which is used as the root directory for the container.
    3.  You can run filesystem.sh with sudo privelages in two ways:
        ```
         1. >>./filesystem.sh <hostname>
         2. >>./filesystem.sh <hostname> -m <memory_limit_in_megabytes> 
        ```
        The second way limits the memory usage of the container in megabytes
        

## Example (run container with hostname saeed and limit memory usage by 200 Megabytes)
![This is a alt text.](https://github.com/saeedzou/SDMN/blob/main/Problem%202/src/images/container_shell.jpg "This is a sample image.")