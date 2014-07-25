#!/bin/sh

dataset="/dana/databases/postgresql"
zpool="zroot"
blocksize="8k" # the default PostgreSQL blocksize


# Sequential write

seqwrite() {
for i in 1 ; do
cat << EOF
[seq-write]
rw=write
size=$size
directory=$dataset
fadvise_hint=0
blocksize=$blocksize
direct=0
numjobs=1
; number of files total per process
nrfiles=1
runtime=1h
time_based
; should flush the cache on freebsd, similar to 'echo 3 > /proc/sys/vm/drop_caches' on linux
exec_prerun=cd $dataset && umount $dataset
EOF
done >> $jobfile
}

jobfile="seqwrite.fio"
size="128g" # larger than system memory
seqwrite

# compression off

zfs destroy $zpool$dataset
zfs create $zpool$dataset

zfs set recordsize=$blocksize $zpool$dataset
zfs set compression=off $zpool$dataset
zfs set primarycache=metadata $zpool$dataset
zfs set secondarycache=metadata $zpool$dataset

fio $jobfile > seqwrite-comp-off.out

# compression lz4

zfs destroy $zpool$dataset
zfs create $zpool$dataset

zfs set recordsize=$blocksize $zpool$dataset
zfs set compression=lz4 $zpool$dataset
zfs set primarycache=metadata $zpool$dataset
zfs set secondarycache=metadata $zpool$dataset

fio $jobfile > seqwrite-comp-lz4.out
