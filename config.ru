require 'rubygems'
require 'bundler/setup'
require 'json'
run lambda{|env|
  req = Rack::Request.new env
  msg = JSON.parse req.body.read
  status = eval(File.new('./repos.rb').read).
    select{|i| i[0..2] == [req.host, msg['repository']['url'], msg['ref']]}.
    map{|i| system("cd #{i[3].inspect} && git checkout -q #{i[2].split('/')[2]} && git pull -q")}
  [status.empty? ? 404 : status.all? ? 200 : 500, {}, []]
}
