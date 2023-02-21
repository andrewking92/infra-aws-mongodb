# mongosh --eval "rs.initiate()"

# mongosh --eval "db.createUser({ user: 'admin0', pwd: 'admin0', roles: ['root']})" admin

# mongosh --username root --password admin --eval "db.createUser({user: 'opsmanager', pwd: 'opsmanager', roles: [{db: 'admin', role: 'readWriteAnyDatabase'}, { db: 'admin', role: 'dbAdminAnyDatabase'}, {db: 'admin', role: 'clusterMonitor'}]})" admin

# mongosh --username root --password admin --eval "db.createUser({user:'opsmanageragent',pwd:'xxxx', roles:['clusterMonitor']})" admin
