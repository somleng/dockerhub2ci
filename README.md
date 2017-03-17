# dockerhub2ci

[![Build Status](https://travis-ci.org/dwilkie/dockerhub2ci.svg?branch=master)](https://travis-ci.org/dwilkie/dockerhub2ci)

dockerhub2ci handles Dockerhub's Webhooks so you can trigger deployment on a successful build. It has built in support for Travis.

## Use Cases

Some of my applications run on AWS Elastic Beanstalk (multi-container docker). It's relatively straight forward to setup automated deployment to Elastic Beanstalk via Travis, however when a deployment is triggered on Elastic Beanstalk it pulls the latest image from Dockerhub. Most of the time the travis build completes and deployment is triggered before Dockerhub has successfully built the new image so the old image is redeployed to Elastic Beanstalk.

Using dockerhub2ci you can setup the following workflow:

1. Push to github
2. Automated build runs on Dockerhub
3. Webhook is sent to dockerhub2ci
4. dockerhubci triggers a build on travis
5. Travis deploys to Elastic Beanstalk
6. Elastic Beanstalk pulls the new image from Dockerhub

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Setup your Webhook on Dockerhub

Set the Webhook URL in your Dockerhub configuration

```
https://api-key:@your-dockerhub2ci-app.herokuapp.com/api/webhooks
```

Replace `api-key` with one of the keys you set in `API_KEYS` and replace `your-dockerhub2ci-app.herokuapp.com` with the domain of your dockerhub2ci instance. Don't forget the trailing colon (:) after the `api-key`

## Development

## License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
