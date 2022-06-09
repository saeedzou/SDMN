package main

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"
	"path/filepath"
	"io/ioutil"
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
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Cloneflags:   syscall.CLONE_NEWUTS | syscall.CLONE_NEWPID | syscall.CLONE_NEWNS ,
		Unshareflags: syscall.CLONE_NEWNS ,
	}
	cmd.Run()
	

}
func child() {
	fmt.Printf("Running %v %d\n", os.Args[2:], os.Getpid())
	fmt.Printf("%d\n",len(os.Args))
	if (os.Args[3]=="--memory" || os.Args[3]=="-m"){
		cg(os.Args[4])
	}
	syscall.Sethostname([]byte(os.Args[2]))
	syscall.Chroot("./ubuntu_fs")
	syscall.Chdir("/")
	syscall.Mount("proc", "proc", "proc", 0, "")

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
}


func must(err error) {
	if err != nil {
		panic(err)
	}
}
