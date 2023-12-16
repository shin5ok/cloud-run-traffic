# Deploy Cloud Run without mixed traffic to multi revisions
There are two ways.
A. After deploying new revision, update routing to the latest.
B. After deploying new revision with new tagged url, update routing to it.

from perspective of comfirmability if the new revison was available, the B has advantage rather than A.

# B. After deploying new revision with new tagged url, update routing to it.
Log Analytics or Log sink will enable you to see if traffic was mixed by logging query.

1. Build image
```
make build
```

2. Deploy the first revison.
```
make deploy
```
You can see the response like this,
```
curl https://###########-############-uc.a.run.app/version
```

3. Deploy the new tagged revision.
Set tag name
```
export VER=v10
```
Deploy as below,
```
make tag-deploy
```
