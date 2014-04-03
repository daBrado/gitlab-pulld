require 'rubygems'
require 'bundler/setup'
require 'json'
require 'logger'
LOG = Logger.new STDERR
run lambda{|env|
  req = Rack::Request.new env
  begin
    msg = JSON.parse body=req.body.read
  rescue JSON::ParserError
    LOG.error "Cannot parse request #{body}"
    return [400, {}, []]
  end
  repo = [req.host, msg['repository']['url'], msg['ref']]
  LOG.info "Request for: #{repo.join(' ')}"
  threads = eval(File.new('./repos.rb').read).select{|i|i[0..2]==repo}.map{|i|
    cmd = ["#{File.dirname __FILE__}/git-forced-pull", i[3], i[2].split('/')[2]]
    LOG.info "Run: #{cmd}"
    Thread.new{
      output = ["#{cmd}", *IO.popen(cmd,err:[:child,:out]){|io|io.map{|l|l.chomp}}]
      severity = $?.success? ? Logger::INFO : Logger::ERROR
      output.each{|l|LOG.log(severity,"#{$?} : #{l}")}
    }
  }
  LOG.info "No matching repos found" if threads.empty?
  [threads.empty? ? 404 : 200, {}, []]
}
