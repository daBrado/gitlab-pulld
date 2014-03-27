# GitLab PullD

GitLab PullD is a Ruby + Rack implementation of a simple daemon to do a `git pull` in an existing clone, triggered by a GitLab web hook.

It cab be used for e.g. automatic website deployment when pushing to a given branch.

## Install

To install for deployment, be sure to have the `bundler` gem installed, and then you can do:

    RUBY=/path/to/ruby
    $RUBY/bin/bundle install --deployment --binstubs --shebang $RUBY/bin/ruby

You will also need to create a `repos.rb` file for your environment.  There is an example provided.

There is also an example Upstart and init.d config to show how you can run it as a service.

## Usage

Run `pulld` on the host where the `git pull` will occur on, and add to the `repos.rb` file an array holding the target host, the uri of the repository, the ref to be pulled, and the path to the clone to pull in to.

In GitLab, then just add a web hook that points to the running `pulld` application uri.

### Without GitLab

Given that GitLab just talks JSON, if you want to trigger the `pulld` daemon directly from a git hook, you can use the `update` hook, and do something like:

    #!/bin/sh
    ref=$1
    repouri=git@git.example.org:myrepo.git
    pulld=http://deploy.example.org:14070
    curl --data '{"repository":{"url":"'$repouri'"},"ref":"'$ref'"}' $pulld

The `repouri` only needs to match whatever you listed in the `repos.rb` file, i.e. just some unique identifier of your choosing.
