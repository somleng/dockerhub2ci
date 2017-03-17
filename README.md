# dockerhub2ci

[![Build Status](https://travis-ci.org/dwilkie/dockerhub2ci.svg?branch=master)](https://travis-ci.org/dwilkie/dockerhub2ci)

## Setup your Webhook on Dockerhub

Set the Webhook URL in your Dockerhub configuration

```
https://api-key:@your-dockerhub2ci-app.herokuapp.com/api/webhooks
```

Replace `api-key` with one of the keys you set in `API_KEYS` and replace `your-dockerhub2ci-app.herokuapp.com` with the domain of your dockerhub2ci instance. Don't forget the trailing colon (:) after the `api-key`
