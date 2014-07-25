#!/bin/sh

dataset="/dana/data/postgresql"
zpool="zroot"
blocksize="8k" # the default PostgreSQL blocksize


# Random write

randwrite() {
for i in 1 ; do
cat << EOF
[random-write]
rw=randwrite
size=$size
directory=$dataset
fadvise_hint=0
blocksize=$blocksize
direct=0
numjobs=$numjobs
; number of files total per process
nrfiles=1
runtime=1h
time_based
; should flush the cache on freebsd, similar to 'echo 3 > /proc/sys/vm/drop_caches' on linux
exec_prerun=cd $dataset && umount $dataset
EOF
done >> $jobfile
}

jobfile="randwrite.fio"
size="10g" # flaf
numjobs="16" # cpu threads
randwrite

# compression off

zfs destroy $zpool$dataset
zfs create $zpool$dataset

zfs set recordsize=$blocksize $zpool$dataset
zfs set compression=off $zpool$dataset
zfs set primarycache=metadata $zpool$dataset
zfs set secondarycache=metadata $zpool$dataset

fio $jobfile > randwrite-comp-off.out

# compression lz4

zfs destroy $zpool$dataset
zfs create $zpool$dataset

zfs set recordsize=$blocksize $zpool$dataset
zfs set compression=lz4 $zpool$dataset
zfs set primarycache=metadata $zpool$dataset
zfs set secondarycache=metadata $zpool$dataset

fio $jobfile > randwrite-comp-lz4.out
