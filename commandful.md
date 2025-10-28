# Commandful 

Set-VMProcessor -VMName "VM-SP3-SO-0929-5817" -ExposeVirtualizationExtensions $true

> drag and drop file/folder to paste path

## PORTS

### What the hell are a TCP and a UDP ports

```
cat /etc/services 
grep -w '80/tcp' /etc/services 
grep -w '443/tcp' /etc/services 
grep -E -w '22/(tcp|udp)' /etc/services
```

My frequently used command is:

```
netstat -tulpn 
```

### Using netstat to list open ports

```
sudo netstat -tulpn | grep LISTEN
```

#### Open and kill ports

### How to force kill process in Linux

1. Use the pidof command to find the process ID of a running program or app
   ```
   pidof appname
   ```

2. To kill process in Linux with PID:

   ```
   kill -9 pid
   ```

3. Want to kill process in Linux with application name? Try:
   ```
   killall -9 appname
   ```

## Delete node_modules   
https://www.cyberciti.biz/faq/show-all-running-processes-in-linux/

Remove & delete all node_modules files

```
npx npkill
```

## sudo!!

Runs the last command with sudo privileges

```
sudo!!
```
