# DBOTF-Docker

# Building the containers:

- `docker build -f Dockerfile_AFLGO -t aflgo:latest .`
- `docker run --rm -ti -v "/tmp/path/to/mount/code:/tmp/volume" aflgo:latest /bin/bash`

The last command starts a container and mounts `/tmp/path/to/mount/code` to `/tmp/volume` in the container.
This can be used to compile the code and apply the fuzzing to get the results on the host machine.

The images are based on Debian Bullseye and contain the LLVM Version 11 and the source code with binaries from AFLGo.
Also, the packages *tmux*, *htop*, *nano* and *vim* are installed.

## Docker files

- `Dockerfile_AFLGO`: For Fuzzing with AFLGo
- `Dockerfile_DFFBOT`: For Fuzzing Distance-guided fuzzing on binaries (AFLGo on binaries)
- `Dockerfile_AFL-QEMU`: For fuzzing with QEMU without distance-guided and on the base of AFLGo (old AFL)


## Starting evaluation

Preparing run and then:

```
for i in $(seq 0 9)
do
   timeout -s INT -k 10 8h $AFLGO/afl-fuzz -m none -z exp -c 45m -i in -o "out_$i" $SUBJECT/xmllint --valid --recover @@
done
```


- `timeout` for aborting the command after n time units.
- The for loop to run the experiment 10 times.
- If QEMU should be applied, supply `-Q` to afl-fuzz.


## Compiling with the own AFLGO implementation

Ensure that clang is used and not afl-clang-fast to prevent the instrumentation of the binaries.

```
export CXX=clang++
export CC=clang
```
