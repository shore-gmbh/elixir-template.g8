kubectl create secret generic $name$ \
  --from-literal=databaseUrl=postgres://someurl \
  --from-literal=secretKeyBase=somesecretvalue \
  --from-literal=sentryUrl=http://sentry.com
