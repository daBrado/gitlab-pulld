# GitLab PullD

GitLab PullD is a Ruby + Rack implementation of a simple daemon to do a `git pull` in an existing clone, triggered by a GitLab web hook.

It cab be used for e.g. automatic website deployment when pushing to a given branch.

## Install

To install for deployment, you can do:

    RUBY=/path/to/ruby
    $RUBY/bin/gem install bundler -i vendor/gem -n bin
    bin/bundle install --deployment --binstubs --shebang $RUBY/bin/ruby

You will also need to create a `repos.rb` file for your environment.  There is an example provided.

There is also an example Upstart and init.d config to show how you can run it as a service.
