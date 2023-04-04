# Answers to questions from "Linux for Bioinformatics"

Q1. What is your home directory?
A1: /home/ubuntu

Q2. What is the output of this command?
A2: hello_world.txt

Q3. What is the output of each `ls` command?
A3: empty; hello_world.txt

Q4. What is the output of each?
A4: empty; empty; hello_world.txt

Q5: What editor did you use and what was the command to save your file changes?
A5: nano; `^O`

Q6. What is the error?
A6: sudouser@ec2-3-86-35-70.compute-1.amazonaws.com: Permission denied (publickey).

Q7. What was the solution?
A7: 
The public key should be copied to .ssh directory of the sudo user: `sudo cp /home/ubuntu/.ssh/authorized_keys /home/sudouser/.ssh/authorized_keys`
After that, the ownership of this file should be changed: `sudo chown sudouser /home/sudouser/.ssh/authorized_keys`

Q8. what does the `sudo docker run` part of the command do? and what does the `salmon swim` part of the command do
A8: The first part instructs Docker to create a new `container` from the `salmon` image, and to run the `salmon` executable. The second part is a function in `salmon` that prints the artistic "salmon" text (which is referred to as "perform super-secret operation" in `salmon`'s help text)

Q9. What is the output of this command?
A9: serveruser is not in the sudoers file.  This incident will be reported.

Q10. What is the output of `flask --version`?
A10: 
Python 3.10.10
Flask 2.2.2
Werkzeug 2.2.2

Q11. What is the output of `mamba -V`
A11: conda 23.1.0

Q12. What is the output of `which python`
A12: /home/serveruser/mambaforge/envs/py27/bin/python

Q13. What is the output of `which python` now?
A13: /home/serveruser/mambaforge/bin/python

Q14. What is the output of `salmon -h`?
A14:
```
salmon v1.4.0

Usage:  salmon -h|--help or 
        salmon -v|--version or 
        salmon -c|--cite or 
        salmon [--no-version-check] <COMMAND> [-h | options]

Commands:
     index      : create a salmon index
     quant      : quantify a sample
     alevin     : single cell analysis
     swim       : perform super-secret operation
     quantmerge : merge multiple quantifications into a single file
```

Q15. What does the `-o athal.fa.gz` part of the command do?
A15: `-o` saves the download into a file. Otherwise the output would be binary output which floods up the terminal

Q16. What is a `.gz` file?
A16: `.gz` is the file extension for Gzip compressed files. It is a file compression format for a single file, and is commonly used on Unix and Linux systems.

Q17. What does the `zcat` command do?
A17: The `zcat` command prints the contents of a `.gz` file to the terminal, without actually extracting it. This is similar to what the `cat` command does to uncompressed files.

Q18. what does the `head` command do?
A18: The `head` command prints  by default the first 10 lines of the specified file(s).

Q19. what does the number `100` signify in the command?
A19: The `head` command with flag `-n 100` prints the first 100 lines of the specified file(s) instead of 10.

Q20. What is `|` doing?** -- **Hint** using `|` in Linux is called "piping" 
A20: The `|` redirects the output of `zcat` as the input of `head`. 

Q21. What is a `.fa` file? What is this file format used for?
A21: `.fa` is the file extension of a FASTA formatted text. It is the standard of representing nucleotide or protein sequences, which contains a header line beginning with a ">" symbol, followed by the actual sequence data. In this case the `.fa` file stores each cDNA transcript of Arabidopsis thaliana, which will be indexed by `salmon` later.

Q22. What format are the downloaded sequencing reads in?
A22: The downloaded reads are in `.sra` format, which is a binary file format that contains raw sequencing data, along with metadata describing the experiment, sample and sequencing platform used. The `.sra` file can be converted to other file formats, such as FASTQ, which is demonstrated in later steps.

Q23. What is the total size of the disk?
Q24. How much space is remaining on the disk?
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       7.6G  5.4G  2.2G  72% /
tmpfs           484M     0  484M   0% /dev/shm
tmpfs           194M  880K  193M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda15     105M  6.1M   99M   6% /boot/efi
tmpfs            97M  4.0K   97M   1% /run/user/1000
```
According to the printed message, 
A23: Total size of the disk is 7.6G
A24: 2.2G is remaining

Q25. What went wrong?
A25: Several error messages such like this below were printed, indicating that the disk space is used-up.
```
2023-04-04T10:34:12 fastq-dump.2.11.0 err: storage exhausted while writing file within file system module - system bad file descriptor error fd='4'
```

Further examination with `df -h` proves the exhaustion of disk space: 
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       7.6G  7.6G  4.0K 100% /
tmpfs           484M     0  484M   0% /dev/shm
tmpfs           194M  880K  193M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda15     105M  6.1M   99M   6% /boot/efi
tmpfs            97M  4.0K   97M   1% /run/user/1000
```

Q26: What was your solution?
A26: By using `fastq-dump SRR074122 --gzip`, the output would be in `.gz` format, which saves disk space since it's a compressed file.

