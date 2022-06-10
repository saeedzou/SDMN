/**
	This program creates a container with isolated net, mount, uts, and pid namespaces
	and runs bash in the container.
	To run another script when starting the container change the argument of line 65 
	from "/bin/bash" to your arbitary script
	Instructions to run this program:
		1.	Go to the directory where this file is at
		2.	Make a directory named ubuntu_fs and extract the tar file into this folder
		3.	Run this program with sudo privelage: >> go run main.go <hostname> [-m || --memory] <memory_limit>
		4.	The memory option is optional and limits the memory usage of the container in megabytes

*/
package main

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"
	"path/filepath"
	"io/ioutil"
	"strconv"
)
func main() {
	switch os.Args[1] {
	case "run":
		run()
	case "child":
		child()
	default:
		panic("bad command")
	}

}

func run() {
	fmt.Printf("Running %v %d\n", os.Args[2:], os.Getpid())
	cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	// Cloning uts, pid, mount, and net namespaces
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Cloneflags:   syscall.CLONE_NEWUTS | syscall.CLONE_NEWPID | syscall.CLONE_NEWNS | syscall.CLONE_NEWNET,
		Unshareflags: syscall.CLONE_NEWNS ,
	}
	cmd.Run()
	

}
//  Add a child process so that we can change hostname and mount filesystem and create cgroups 
func child() {
	fmt.Printf("Running %v %d\n", os.Args[2:], os.Getpid())
	// optional arguement to limit memory usage of the container
	if len(os.Args)==5 {
		if (os.Args[3]=="--memory" || os.Args[3]=="-m"){
			cg(os.Args[4])
		}
	}	
	must(syscall.Sethostname([]byte(os.Args[2])))
	must(syscall.Chroot("./ubuntu_fs"))
	must(syscall.Chdir("/"))
	must(syscall.Mount("proc", "proc", "proc", 0, ""))

	cmd := exec.Command("/bin/bash")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	cmd.Run()
	syscall.Unmount("proc", 0)

}

func cg(memory_limit string) {

	cgroups := "/sys/fs/cgroup/"
	memory := filepath.Join(cgroups, "memory")
	os.Mkdir(filepath.Join(memory, "container"), 0755)
	must(ioutil.WriteFile(filepath.Join(memory, "container/memory.limit_in_bytes"), []byte(memory_limit+"M"), 0700))
	//  assigning the process id of the container to the tasks of cgroup container
	must(ioutil.WriteFile(filepath.Join(memory, "container/tasks"), []byte(strconv.Itoa(os.Getpid())), 0700))
}


func must(err error) {
	if err != nil {
		panic(err)
	}
}
