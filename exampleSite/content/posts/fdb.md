+++ 
author = "Xing Lin"
title = "FoundationDB: A Distributed Unbundled Transactional Key Value Store" 
description = "" 
tags = [ 
    "paper",
    "KV", 
    "2021",
    "SIGMOD",
] 
date = "2026-05-24" 
+++

> Key and value sizes are limited to 10 KB and 100 KB respectively for better performance. Transaction size is limited to 10 MB

Transaction processing
```
Optimistic concurrency control + MVCC: 2.4.1 A client transaction starts by contacting one of the Proxies to obtain a read version (i.e., a timestamp). The Proxy then asks the Sequencer for a read version that is guaranteed to be no less than any
previously issued transaction commit version, and this read version
is sent back to the client. Then the client may issue multiple reads
to StorageServers and obtain values at that specific read version.
Client writes are buffered locally without contacting the cluster.
At commit time, the client sends the transaction data, including
the read and write sets (i.e., key ranges), to one of the Proxies
and waits for a commit or abort response from the Proxy. If the
transaction cannot commit, the client may choose to restart the
transaction from the beginning again.

A Proxy commits a client transaction in three steps. First, the
Proxy contacts the Sequencer to obtain a commit version that is
larger than any existing read versions or commit versions. The
Sequencer chooses the commit version by advancing it at a rate of
one million versions per second. Then, the Proxy sends the transac-
tion information to range-partitioned Resolvers, which implement
FDB’s optimistic concurrency control by checking for read-write
conflicts. If all Resolvers return with no conflict, the transaction
can proceed to the final commit stage. Otherwise, the Proxy marks
the transaction as aborted. Finally, committed transactions are sent
to a set of LogServers for persistence. A transaction is consid-
ered committed after all designated LogServers have replied to the
Proxy, which reports the committed version to the Sequencer (to
ensure that later transactions’ read versions are after this commit)
and then replies to the client. At the same time, StorageServers
continuously pull mutation logs from LogServers and apply com-
mitted updates to disks.
```


```
In the transaction management system of FDB, we handle all failures through the
recovery path: instead of fixing all possible failure scenarios, the transaction system proactively shuts down when it
detects a failure. As a result, all failure handling is reduced
to a single recovery operation, which becomes a common
and well-tested code path. Such error handling strategy is
desirable as long as the recovery is quick, and pays dividends
by simplifying the normal transaction processing.
```
> 5 sec MVCC transaction window: every transaction has to complete in 5 secs. Main reason is then resolver only need to keey the most recent 5-sec updates in memory to detect conflicts among trasactions. 

