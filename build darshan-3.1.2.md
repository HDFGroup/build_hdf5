TLDR:  Building darshan on blue waters

Building:

Prepare the environment:
$ module unload darshan
Darshan needs to be built with gnu environment:
$ module swap PrgEnv-cray PrgEnv-gnu
Cheat the compiler driver, which does all the linking for MPI but doesn’t go by the name:
$ alias mpicc=”cc”
Get and unpack the sources
$ wget ftp://ftp.mcs.anl.gov/pub/darshan/releases/darshan-3.1.2.tar.gz
$ tar -zxvf darshan-3.1.2.tar.gz
$ cd darshan-3.1.2/darshan-runtime
Set these to whatever they need to be:
$ export DARSHAN_LOGDIR=$HOME/scratch/darshan-logs
$ export DARSHAN_PREFIX=$HOME/scratch/local
$ module swap PrgEnv-cray PrgEnv-gnu
$ CC=cc ./configure --with-mem-align=8 --with-log-path=$DARSHAN_LOGDIR --with-jobid-env=NONE --prefix=$DARSHAN_PREFIX --disable-cuserid 
$ make -j8 install
Go back to cray environment
$ module swap PrgEnv-gnu PrgEnv-cray

There, now it’s built and installed. Make sure the darshan log directory actually exists, or else it won’t be able to write logs. 

To compile and link code is trickier:

Static linkage:

To compile hello.c and statically link all the junk to an executable mpi_hello:
mpicc hello.c -o mpi_hello -static -I$DARSHAN_PREFIX/include -L$DARSHAN_PREFIX/lib -L$DARSHAN_PREFIX/lib -ldarshan -lz -Wl,@$DARSHAN_PREFIX/share/ld-opts/darshan-base-ld-opts -Wl,-rpath -Wl,$DARSHAN_PREFIX/lib -Wl,--enable-new-dtags -L$DARSHAN_PREFIX/lib -Wl,--start-group -ldarshan -ldarshan-stubs -Wl,--end-group -lz -lrt -lpthread -lpthread -lrt -lpthread

Dynamic:

$ mpicc hello.c -o mpi_hello -dynamic
$ export LD_PRELOAD=/u/sciteam/willmore/local/lib/libdarshan.so 

That’s it. Do remember that this mpicc is simply an alias to cc, and doesn’t support adding instrumentation to the stack via the standard mpicc mechanism.
