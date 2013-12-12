REPOS = [
  ['mbpdev.komp.org', 'git@git.mousebiology.org:mbp-dev/pulld', 'refs/heads/master', '/u02/home/developers/pushd']
]
require 'rubygems'
require 'bundler/setup'
require 'json'
run lambda{|env|
  req = Rack::Request.new env
  msg = JSON.parse req.body.read
  info = [req.host, msg['repository']['url'], msg['ref']]
  status = 404
  REPOS.each{|i| status = system("cd #{i[3].inspect} && git pull -q") ? 200 : 500 if info == i[0..2]}
  [status,{},[]]
}
