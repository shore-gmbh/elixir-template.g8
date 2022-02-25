kubectl create secret generic $name;format="word-space,hyphenate"$ \
  --from-literal=databaseUrl=postgres://someurl \
  --from-literal=secretKeyBase=somesecretvalue \
  --from-literal=sentryUrl=http://sentry.com
