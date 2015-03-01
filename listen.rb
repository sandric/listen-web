require 'listen'
require 'sinatra'
require "sinatra/streaming"

set :server, :thin
set :bind, '0.0.0.0'

module Listen
  class Record
    class << self
      attr_accessor :out
    end

    def build
      start = Time.now.to_f
      @paths = _auto_hash

      # TODO: refactor this out (1 Record = 1 watched dir)
      listener.directories.each do |directory|
        _fast_build(directory.to_s)
      end

      Celluloid::Logger.info "Record.dibuild(): #{Time.now.to_f - start} seconds"
      Listen::Record.out.puts '<div>All listeners are set.</div>'
    rescue
      Celluloid::Logger.warn "build crashed: #{$ERROR_INFO.inspect}"
      Listen::Record.out.puts '<div>An error happened during setting listeners, look at logs.</div>'
      raise
    end
  end
end



get '/' do
  stream do |out|

    Listen::Record.out = out

    out.puts <<eos
    <style>
      div {
        padding: 5px;
        padding-left: 5%;
        font-weight: bold;
        font-family: monospace;
        margin-bottom: 10px;

        animation: fadein 2s;
        -moz-animation: fadein 2s; /* Firefox */
        -webkit-animation: fadein 2s; /* Safari and Chrome */
        -o-animation: fadein 2s; /* Opera */
      }

      span {
        padding-right: 50px;
        font-weight: normal;
        font-size: smaller;
      }
      
      .modified {
        background-color: #ead891;
      }
      .added {
        background-color: #9befb7;
      }
      .removed {
        background-color: #f7b2b2;
      }

      @keyframes fadein {
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-moz-keyframes fadein { /* Firefox */
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-webkit-keyframes fadein { /* Safari and Chrome */
          from {
              opacity:0;
              background-color: #e5b5c4;
          }
          to {
              opacity:1;
          }
      }
      @-o-keyframes fadein { /* Opera */
          from {
              opacity:0;
              background-color: #e5b5c4; 
          }
          to {
              opacity: 1;
          }
      }

    </style>
eos

    out.puts "<div>Starting listening...</div>" 


    listener = Listen.to('/home',
                         '/bin',
                         '/sbin',
                         '/lib',
                         '/lib64',
                         '/opt',
                         '/srv',
                         '/usr',
                         '/var',
                         ignore: [
                           %r{/var/lock},
                           %r{/var/run},
                           %r{/var/tmp}
                         ],
                         debug: true) do |modifications, additions, deletions|
      time = Time.now.strftime("%d/%m/%Y %H:%M:%S")

      modifications.each { |modification| out.puts "<div class='modified'><span>#{time}</span>#{modification}</div>" }
      additions.each { |addition| out.puts "<div class='added'><span>#{time}</span>#{addition}</div>" }
      deletions.each { |deletion| out.puts "<div class='removed'><span>#{time}</span>#{deletion}</div>" }

      out.puts "<script>window.scrollTo(0,document.body.scrollHeight);</script>"               
    end
    
    listener.start # not blocking
    sleep
  end
end
