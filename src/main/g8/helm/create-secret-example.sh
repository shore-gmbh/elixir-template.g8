kubectl create secret generic dory \
  --from-literal=databaseUrl=postgres://someurl \
  --from-literal=secretKeyBase=somesecretvalue
