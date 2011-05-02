require 'rake/clean'

verbose true

task :default => ['game:debug', :fdb]

namespace :game do
  src_files = FileList['lib/**/*.as', 'src/**/*.as'].each do |src_file|
    file src_file
  end
  
  desc "Build the debug version of the game"
  task :debug => 'bin/game-debug.swf'
  file 'bin/game-debug.swf' => [:sounds] + src_files do
    mxmlc 'src/Main.as', 'bin/game-debug.swf', mxmlc_opts({
      :source_paths => ['lib/flashpunk', 'src']
    })
  end
  
  desc "Build the release version of the game"
  task :release => 'bin/game.swf'
  file 'bin/game.swf' => [:sounds] + src_files do
    mxmlc 'src/Main.as', 'bin/game.swf', mxmlc_opts({
      :debug => false,
      :source_paths => ['lib/flashpunk', 'src']
    })
  end
  
  CLEAN << FileList['bin/*.swc', 'bin/*.cache']
end

desc "Convert WAV files to MP3s using ffmpeg"
task :sounds
FileList['**/*.wav'].each do |wav_file|
  mp3_file = wav_file.pathmap('%X.mp3')
  file wav_file
  file mp3_file => wav_file do |t|
    ffmpeg wav_file, t.name
  end
  task :sounds => mp3_file
end

desc "Run an automated version of FDB"
task :fdb do
  Debugger.new.run
end

desc "Run a local web server"
task :server do
  sh 'ruby server.rb'
end

def compc(input_folders, output_file, opts={})
  mkdir_p File.dirname(output_file)
  args = compiler_args(opts[:command] || 'compc', opts)
  input_folders = [input_folders] if input_folders.kind_of? String
  input_folders.each do |input_folder|
    args << "-include-sources+=#{input_folder}"
  end
  args << "-output=#{output_file}"
  sh args.join ' '
end

def compc_opts(opts={})
  {
    :debug => true,
    :source_paths => ['.'],
    :static => false
  }.merge(opts)
end

def mxmlc(input_file, output_file, opts={})
  mkdir_p File.dirname(output_file)
  args = compiler_args(opts[:command] || 'mxmlc', opts)
  args << "-output=#{output_file}"
  args << input_file
  sh args.join ' '
end

def mxmlc_opts(opts={})
  {
    :bgcolor => '#ffffff',
    :size => '800 600 ',
    :debug => true,
    :library_paths => [],
    :source_paths => ['.'],
    :static => true
  }.merge(opts)
end

def compiler_args(command, opts)
  args = [
    command,
    "-as3",
    "-strict",
    "-verbose-stacktraces=true",
    "-warnings=true",
  ]
  if opts[:debug]
    args << "-debug" if opts[:debug]
    args << "-define+=ENV::debug,true"
    args << "-define+=ENV::release,false"
  else
    args << "-define+=ENV::debug,false"
    args << "-define+=ENV::release,true"
  end
  opts[:defines].each_pair do |key, value|
    args << "-define+=#{key},#{value}"
  end if opts[:defines]
  args << "-default-size #{opts[:size]}" if opts[:size]
  args << "-default-background-color=#{opts[:bgcolor]}" if opts[:bgcolor]
  args << "-incremental" if opts[:incremental]
  args << "-static-link-runtime-shared-libraries=true" if opts[:static]
  args << "-use-network=true" if opts[:network]
  opts[:library_paths].each do |path|
    args << "-library-path+=#{path}"
  end if opts[:library_paths]
  opts[:source_paths].each do |path|
    args << "-source-path+=#{path}"
  end if opts[:source_paths]
  args += opts[:args] if opts[:args]
  args
end

def ffmpeg(input, output)
  begin
    sh "ffmpeg -y -i #{input.inspect} #{output.inspect}" 
  rescue
    puts "WARNING: Couldn't encode #{output}, ffmpeg is required"
  end
end

class Debugger
  def initialize
    $stdout.sync = true
    @line_triggers = {
      "Player connected; session starting." => proc { trigger :connected },
      "Player session terminated" => proc { trigger :connect },
      "Failed to connect; session timed out." => proc { trigger :connect }
    }
    @triggers = {
      "(fdb) " => proc { trigger :idle }
    }
    @read_buffer = ""
    @write_buffer = ""
    @state = :starting
  end
  
  def run
    open('|fdb', 'w+') do |handle|
      @pipe = handle
      while true do
        IO.select [@pipe], [], [@pipe]
        
        # read
        begin
          data = @pipe.read_nonblock 1024
          print data
          @read_buffer += data
        rescue Errno::EAGAIN, Errno::EWOULDBLOCK
          nil
        end
        
        # parse
        until (i = @read_buffer.index("\n")) == nil
          line, @read_buffer = @read_buffer.split("\n", 2)
          # puts line
          if (trigger = @line_triggers[line]) || (trigger = @triggers[line])
            trigger.call 
          end
        end
        if (trigger = @triggers[@read_buffer])
          @read_buffer = ""
          trigger.call
        end
        
        # write
        unless @write_buffer.empty?
          length = @pipe.write_nonblock @write_buffer
          @write_buffer.slice! length..-1 if length > 0
        end
      end
    end
  end
  
  def trigger(type)
    case type
    when :connect
      write "run"
      @state = :connecting
    when :connected
      @state = :connected
    when :continue
      write "continue"
      @state = :running
    when :idle
      case @state
      when :starting then trigger :connect
      when :connected then trigger :continue
      end
    else
      raise "Unknown trigger type #{type}"
    end
  end

  def write(command)
    print command, "\n"
    @pipe.write command + "\n"
  end
end
