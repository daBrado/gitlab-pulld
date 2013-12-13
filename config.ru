REPOS = [
  ['mbpdev.komp.org', 'git@git.mousebiology.org:mbp-dev/pulld.git', 'refs/heads/master', '/u02/home/developers/pushd'],
]
require 'rubygems'
require 'bundler/setup'
require 'json'
run lambda{|env|
  req = Rack::Request.new env
  msg = JSON.parse req.body.read
  status = REPOS.select{|i| i[0..2] == [req.host, msg['repository']['url'], msg['ref']]}.map{|i| system("cd #{i[3].inspect} && git pull -q")}
  [status.empty? ? 404 : status.any? ? 200 : 500, {}, []]
}
