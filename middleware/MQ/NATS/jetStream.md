# JetStream 持久化

## 节点宕机，流异常

如果创建流时，副本不满足最小节点数量，即 `1/2(集群数)+1`，其中一个节点宕机，会导致整个持久化流不能正常工作

如果 3 个 js 集群，创建了一个 2 副本的流， 其中一个节点宕机，另一个节点会报异常

从节点宕机：

```bash
$ nats str info s2 -s test:test@192.168.1.202:34223
Information for Stream s2 created 2022-06-24T15:53:26+08:00

Configuration:

             Subjects: s.>
     Acknowledgements: true
            Retention: File - Limits
             Replicas: 3
       Discard Policy: Old
     Duplicate Window: 2m0s
    Allows Msg Delete: true
         Allows Purge: true
       Allows Rollups: false
     Maximum Messages: unlimited
        Maximum Bytes: unlimited
          Maximum Age: unlimited
 Maximum Message Size: unlimited
    Maximum Consumers: unlimited


Cluster Information:

                 Name: ABCDE
               Leader: A
              Replica: C, outdated, seen 50.05s ago, 2 operations behind

State:

             Messages: 50
                Bytes: 1.9 KiB
             FirstSeq: 1 @ 2022-06-24T08:17:36 UTC
              LastSeq: 50 @ 2022-06-24T08:17:36 UTC
     Active Consumers: 0
```

或者主节点宕机：

```bash
...
Cluster Information:

                 Name: ABCDE
               Leader:
              Replica: C, outdated, seen 1m25s ago, 75 operations behind
              Replica: A, outdated, seen 32.14s ago, 75 operations behind
...
```

这时可以修改流的副本数量来使流可以重新选举

```bash
 nats stream edit --replicas=3 -f s2 -s test:test@192.168.1.202:34223
Differences (-old +new):
  api.StreamConfig{
        ... // 10 identical fields
        Storage:  s"File",
        Discard:  s"Old",
-       Replicas: 2,
+       Replicas: 3,
        NoAck:    false,
        Template: "",
        ... // 9 identical fields
  }
nats.exe: error: could not edit Stream s2: context deadline exceeded # 虽然报错了，但是配置修改成功了
```

查看修改后流的信息：

```bash
$ nats str info s2 -s test:test@192.168.1.202:34223
Information for Stream s2 created 0001-01-01T08:00:00+08:00

Configuration:

             Subjects: s.>
     Acknowledgements: true
            Retention: File - Limits
             Replicas: 3
       Discard Policy: Old
     Duplicate Window: 2m0s
    Allows Msg Delete: true
         Allows Purge: true
       Allows Rollups: false
     Maximum Messages: unlimited
        Maximum Bytes: unlimited
          Maximum Age: unlimited
 Maximum Message Size: unlimited
    Maximum Consumers: unlimited


Cluster Information:

               Leader: C
              Replica: A, outdated, seen 5m28s ago, 78 operations behind
              Replica: B, current, seen 0.17s ago

State:

             Messages: 50
                Bytes: 1.9 KiB
             FirstSeq: 1 @ 2022-06-24T08:17:36 UTC
              LastSeq: 50 @ 2022-06-24T08:17:36 UTC
     Active Consumers: 0

```

这时，流的节点可能还会报异常 `JetStream stream "s2" for account "test" is not current`

可以进行强制选举，更换 Leader 来使流正常，但是新节点 B 没有同步该流之前的持久化数据，可能依旧异常，**有待深入研究**

```bash
$ nats stream cluster step-down s2 -s test:test@192.168.1.202:34223
16:40:04 Requesting leader step down of "C" in a 3 peer RAFT group
16:40:05 New leader elected "B"

Information for Stream s2 created 0001-01-01T08:00:00+08:00

Configuration:

             Subjects: s.>
     Acknowledgements: true
            Retention: File - Limits
             Replicas: 3
       Discard Policy: Old
     Duplicate Window: 2m0s
    Allows Msg Delete: true
         Allows Purge: true
       Allows Rollups: false
     Maximum Messages: unlimited
        Maximum Bytes: unlimited
          Maximum Age: unlimited
 Maximum Message Size: unlimited
    Maximum Consumers: unlimited


Cluster Information:

                 Name: ABCDE
               Leader: B
              Replica: C, current, seen 0.15s ago
              Replica: A, outdated, OFFLINE, not seen, 80 operations behind

State:

             Messages: 0
                Bytes: 0 B
             FirstSeq: 0
              LastSeq: 0
     Active Consumers: 0
```
