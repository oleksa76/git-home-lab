# Infrastructure description
| Role name | Server name | IP | RDP port | VM Gen | VM GUI |
| --------- |------------ | -- | -------- | ------ | ------ |
| Domain controller | DC01 | 10.10.0.10 | | 2 | no|
| Failover cluster node 1 | SQLNODE01 | 10.10.0.51 | | 2| yes|
| Failover cluster node 2 | SQLNODE01 | 10.10.0.51 | | 2| yes|