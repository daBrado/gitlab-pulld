require 'rubygems'
require 'bundler/setup'
require 'json'
require 'logger'
LOG = Logger.new STDERR
run lambda{|env|
  req = Rack::Request.new env
  msg = JSON.parse req.body.read
  repo = [req.host, msg['repository']['url'], msg['ref']]
  LOG.info "Request for: #{repo.join(' ')}"
  status =
    eval(File.new('./repos.rb').read).
    select{|i| i[0..2] == repo}.
    map{|i|
      cmd = "cd #{i[3].inspect} && git checkout -q #{i[2].split('/')[2]} && git pull -q"
      LOG.info "Run: #{cmd}"
      status = system cmd
      LOG.info "Exit status: #{status}"
      status
    }
  LOG.info "No matching repos found" if status.empty?
  [status.empty? ? 404 : status.all? ? 200 : 500, {}, []]
}
