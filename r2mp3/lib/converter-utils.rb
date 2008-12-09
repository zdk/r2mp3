class Converter
   def initialize(opts={},&block)
       $opts = opts
       yield(opts) if block_given?
   end
end

class Convert

   def self.mp3_to_wav(input, output=nil, opts={})
       puts "mp3 to wav"
       conversion(:mp3, :wav, input, output, opts) do | input, output, opts |
         Mplayer.dump_to_wav(input, output, opts)
       end
   end
    
   def self.mp3_to_mp3(input, output=nil, opts={})
       puts "mp3 to mp3"
       output ||= input.gsub(/\.rm$/,".mp3")
       mp3_to_wav(input, 'temp.wav', opts) and wav_to_mp3('temp.wav', output, opts.merge({:delete_input=>true}))
   end
   
   def self.ra_to_wav(input, output=nil, opts={})
       conversion(:rm, :wav, input, output, opts) do | input, output, opts |
         Mplayer.dump_to_wav(input, output, opts)
       end
   end
    
   def self.ra_to_mp3(input, output=nil, opts={})
       output ||= input.gsub(/\.rm$/,".mp3")
       ra_to_wav(input, 'temp.wav', opts) and wav_to_mp3('temp.wav', output, opts.merge({:delete_input=>true}))
   end
  
   def self.aac_to_wav(input, output=nil, opts={})
       conversion(:m4a, :wav, input, output, opts) do | input, output, opts |
         Mplayer.dump_to_wav(input, output, opts)
       end
   end
    
   def self.aac_to_mp3(input, output=nil, opts={})
       output ||= input.gsub(/\.m4a$/,".mp3")
       aac_to_wav(input, 'temp.wav', opts) and wav_to_mp3('temp.wav', output, opts.merge({:delete_input=>true}))
   end

   def self.wma_to_mp3(input, output=nil, opts = {})
       p opts
       output ||= input.gsub(/\.wma$/,".mp3")
       wma_to_wav(input, 'temp.wav', opts) and wav_to_mp3('temp.wav', output, opts.merge({:delete_input=>true}))
   end
       
   def self.wma_to_wav(input, output=nil, opts={})
       conversion(:wma, :wav, input, output, opts) do | input, output, opts |
         Mplayer.dump_to_wav(input, output, opts)
       end
   end
    
   def self.wav_to_mp3(input, output=nil, opts={})
       puts "wav to mp3"
       conversion(:wav, :mp3, input, output, opts) do | input, output, opts |
          opts[:mode] ||= :stereo 
          opts[:bitrate] ||= 64
          puts "bitrate = #{opts[:bitrate]}"
          lame = LameAdapter.new
          lame.input_file input
          lame.output_file output
          lame.mode opts[:mode]
          lame.bitrate opts[:bitrate]
          lame.convert!
       end
   end
    
   def self.conversion(input_format, output_format, input_file, output_file, opts={}, &block)
       puts "...conversion"
       input_format = input_format.to_s
       output_format = output_format.to_s
       input_regexp = /\.#{input_format}$/
       return false unless File.exists? input_file and File.extname(input_file) =~ input_regexp
       output_file ||= input_file.gsub(input_regexp,".#{output_format}")
       success = yield(input_file, output_file, opts)
       FileUtils.rm input_file if opts[:delete_input]
       success and File.exists? output_file
   end
    
   def self.wma_dir_to_mp3(dirname, opts = {})
       Dir["#{dirname}/*.wma"].each do |name|
           if !name[/[\s]+/].nil? then
           new_name = name.gsub(" ","_").downcase
           FileUtils.mv "#{name}", "#{new_name}", :force => true  # no error
           name = new_name
           end
         wma_to_mp3(name, nil, opts)
       end
    end
    
   def self.wma_file_to_mp3(filename, opts = {})
       wma_to_mp3(filename, nil, opts)
   end
    
   def self.aac_dir_to_mp3(dirname, opts = {})
       Dir["#{dirname}/*.m4a"].each do |name|
          if !name[/[\s]+/].nil? then
           new_name = name.gsub(" ","_").downcase
           FileUtils.mv "#{name}", "#{new_name}", :force => true  # no error
           name = new_name
          end
         aac_to_mp3(name, nil, opts)
       end
   end
    
   def self.aac_file_to_mp3(filename, opts = {})
       aac_to_mp3(filename, nil, opts)
   end
    
   def self.ra_dir_to_mp3(dirname, opts = {})
       Dir["#{dirname}/*.rm"].each do |name|
         if !name[/[\s]+/].nil? then
         new_name = name.gsub(" ","_").downcase
         FileUtils.mv "#{name}", "#{new_name}", :force => true  # no error
         name = new_name
         end
         ra_to_mp3(name, nil, opts)
       end
   end
    
   def self.ra_file_to_mp3(filename, opts = {})
       ra_to_mp3(filename, nil, opts)
   end
   
   def self.mp3_dir_to_mp3(dirname, opts = {})
       Dir["#{dirname}/*.mp3"].each do |name|
         if !name[/[\s]+/].nil? then
         new_name = name.gsub(" ","_").downcase
         FileUtils.mv "#{name}", "#{new_name}", :force => true  # no error
         name = new_name
         end
         mp3_to_mp3(name, nil, opts)
       end
   end
    
   def self.mp3_file_to_mp3(filename, opts = {})
       mp3_to_mp3(filename, nil, opts)
   end
   
end


class Hash 
      
   def to_mp3
     case $opts[:convert]
     when :wma
          unless $opts[:dir].nil? then 
              puts "convert all wma files in #{self[:dir]}"
              Convert.wma_dir_to_mp3(self[:dir], self)
          else
              puts "(wma) convert #{self[:file]} to mp3"
              Convert.wma_file_to_mp3(self[:file], self)
           end
     when :aac
           unless $opts[:dir].nil? then
              puts "convert all aac files in #{self[:dir]}"
              Convert.aac_dir_to_mp3(self[:dir], self)
           else
              puts "(aac) convert #{self[:file]} to mp3"
              Convert.aac_file_to_mp3(self[:file], self)
           end
     when :ra
           unless $opts[:dir].nil? then
              puts "convert all ra files in #{self[:dir]}"
              Convert.ra_dir_to_mp3(self[:dir], self)
           else
              puts "(ra) convert #{self[:file]} to mp3"
              Convert.ra_file_to_mp3(self[:file], self)
           end
     when :mp3
           unless $opts[:dir].nil? then
              puts "convert all mp3 files in #{self[:dir]}"
              Convert.mp3_dir_to_mp3(self[:dir], self)
           else
              puts "(mp3) convert #{self[:file]} to mp3"
              Convert.mp3_file_to_mp3(self[:file], self)
           end
     end
   end
   
   def bitrate kbps
       self[:bitrate] = kbps
   end
   
   def mode m
       self[:mode] = m
   end
   
end




# class Options < Hash
#    def initialize(arg)
#       begin
#          optstruct = OpenStruct.new
#          options = OptionParser.new do |opts|
#            opts.banner = "usage: #{__FILE__} [options]"
#            opts.on('-w','--wma-to-mp3','convert .wma to mp3 ')do
#              self[:wma] = true
#            end
#            opts.on('-a','--aac-to-mp3','convert .m4a to mp3')do
#              self[:aac] = true
#            end
#            opts.on('-r','--ra-to-mp3','convert .rm to mp3')do
#              self[:ra] = true
#            end
#            opts.on('-m','--mp3-to-mp3','convert mp3 to mp3')do
#              self[:mp3] = true
#            end
#            opts.on('-f','--file [filename]','file') do |f|
#              self[:file] = f
#            end
#            opts.on('-d','--dir [directoryname]','directory') do |d|
#              self[:dir] = d
#            end
#            opts.on('-b','--bitrate [kbps]','bitrate') do |b|
#              self[:bitrate] = b.to_i
#            end
#            opts.on_tail('-h','--help','help') do
#              puts opts
#              exit
#            end
#            raise "print help" if ARGV.size < 1
#            raise "choose wma or aac " if self[:wma] and self[:aac] 
#          end.parse!(arg)
#       rescue  OptionParser::InvalidOption, RuntimeError => e
#       puts e
#       puts "#{$0} -h or --help , for help"
#       end
#    end
# end