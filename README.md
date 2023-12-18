# Switch Cloud Run revisions without mixed traffic
There are two ways.
### A. After deploying new revision, and then update routing to the latest.
### B. After deploying new revision with new tagged url, and then update routing to it.

From perspective of comfirmability if the new revison was available, the B has advantage rather than A.

*Note: Log Analytics or Log sink will enable you to see if traffic was mixed by logging query before working it.*

# B. After deploying new revision with new tagged url, update routing to it.

### Prerequisite
- Docker engine working on local.


1. Build image
```
make image
```

2. Deploy the first revison.
```
make deploy
```
It will give you the service url.
```
https://###########-############-uc.a.run.app
```

You can test the service,
```bash
curl https://###########-############-uc.a.run.app/version
```
You will see like this,
```
version: standard
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
It generate new tagged url.
```
https://v10---###########-############-uc.a.run.app
```



4. Switch to new one after confirmation.
Make sure if the new tagged revision is available completely.
```bash
curl https://v10---###########-############-uc.a.run.app/version
```
After that,
```
make update-traffic-tag
```

5. Access the url of service.
```bash
curl https://###########-############-uc.a.run.app/version
```
You will not see any responses from the old url.

6. Remove the tagged url after switching successfully.

```bash
make remove-tag
```
That's it.  
Have a nice Cloud Run day!