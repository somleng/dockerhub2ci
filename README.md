# dockerhub2ci

[![Build Status](https://travis-ci.org/dwilkie/dockerhub2ci.svg?branch=master)](https://travis-ci.org/dwilkie/dockerhub2ci)
[![Test Coverage](https://codeclimate.com/github/dwilkie/dockerhub2ci/badges/coverage.svg)](https://codeclimate.com/github/dwilkie/dockerhub2ci/coverage)

dockerhub2ci handles Dockerhub's Webhooks so you can trigger CI on a successful build. It has built in support for [Travis](https://travis-ci.org/).

## Example Use Case

Some of my applications run on AWS Elastic Beanstalk (multi-container docker). It's relatively straight forward to setup automated deployment to Elastic Beanstalk via Travis, however when a deployment is triggered on Elastic Beanstalk it pulls the latest image from Dockerhub. Most of the time the travis build completes and deployment is triggered before Dockerhub has successfully built the new image so the old image is redeployed to Elastic Beanstalk.

Using dockerhub2ci you can setup the following workflow:

1. Push to Github
2. Automated build runs on Dockerhub
3. Webhook is sent to dockerhub2ci if Docker image is successfully built
4. dockerhub2ci triggers a build on your CI
5. CI runs the build and deploys using the latest image

## Deploy to dockerhub2ci to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Configuration

See [app.json](https://github.com/dwilkie/dockerhub2ci/blob/master/app.json) for list of the main configuration options.

Optional configuration options are listed below:

### `REPO_MAPPINGS`

One or more Dockerhub repo to build repo name mappings (separated by semicolons (;)). For example if you want the Dockerhub repository `dwilkie-docker/dockerhub2ci` to trigger a build on `dwilkie/dockerhub2ci` set `REPO_MAPPINGS=dwilkie-docker/dockerhub2ci=dwilkie/dockerhub2ci`. If there is no mapping for the Dockerhub repo, it's assumed the build repo is the same as the Dockerhub repo.

### `TAG_MAPPINGS`

One or more Dockerhub tag to build branch name mappings (separated by semicolons (;)). For example if you want the `lastest` Dockerhub tag to trigger a build on the `staging` branch and the `stable` Dockerhub tag to trigger a build on the master branch set `TAG_MAPPINGS=latest=staging;stable=master`. If there is no mapping for the Dockerhub tag, it's assumed the build branch name is the same as the Dockerhub tag name.

Defaults to `latest=master`

### `TRAVIS_ENDPOINT`

Set to `https://api.travis-ci.com` for private repositories.

Defaults to `https://api.travis-ci.org`

### `TRAVIS_CONTENT_TYPE`

The content type header for Travis API requests.

Defaults to `application/json`

### `TRAVIS_API_VERSION`

The API version header for Travis API requests.

Defaults to `3`

## Setup your Webhook on Dockerhub

Set the Webhook URL in your Dockerhub configuration

```
https://api-key:@your-dockerhub2ci-app.herokuapp.com/api/webhooks
```

Replace `api-key` with one of the keys you set in `API_KEYS` and replace `your-dockerhub2ci-app.herokuapp.com` with the domain of your dockerhub2ci instance. Don't forget the trailing colon (:) after the `api-key`

![Dockerhub Webhook Settings](https://raw.githubusercontent.com/dwilkie/dockerhub2ci/master/docs/images/dockerhub-webhook-settings.png)

## Turn off automated builds on your CI

After you have setup dockerhub2ci to trigger builds you can turn off automated builds on your CI. Here's a screenshot of how to turn off automated builds on Travis.

![Travis Repo Settings](https://raw.githubusercontent.com/dwilkie/dockerhub2ci/master/docs/images/travis-settings.png)

## Contributing

dockerhub2ci use the [publish-subscribe pattern](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) so that additional subscribers can be added with ease. Subscribers are configured using the `WEBHOOK_SUBSCRIBERS` environment variable (see [app.json](https://github.com/dwilkie/dockerhub2ci/blob/master/app.json) for more info).

A subscriber just needs to implement the `perform!` method which takes one argument which is the payload from the Dockerhub webhook (see [WebhookSubscriber::Travis](https://github.com/dwilkie/dockerhub2ci/blob/master/app/models/webhook_subscriber/travis.rb) for an example).

## License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
