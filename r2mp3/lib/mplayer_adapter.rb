class Mplayer
   # Can be used to dump any audio file to wav   
   def self.dump_to_wav(input, output, opts={})
     puts "dump to wav"
     begin
      platform = `uname -a`
      binary = "#{%r{Linux} =~ platform}".empty?? "/Applications/mplayer":"mplayer"
      FileUtils.rm("audiodump.wav") if File.exists? "audiodump.wav"
      opts[:resample] ||= '44100'
      args = ""
      force_opt = {:vo => "null", :vc => "dummy", :af => "resample=#{opts[:resample]}", :ao => "pcm:waveheader"}
      force_opt.each{|k,v| args << "-#{k.to_s} #{v} "}
      cmd = "#{binary} #{args} #{input}"
      success = system(cmd) 
      puts "Success? #{success}"
      FileUtils.mv("audiodump.wav", output)  if File.exists? "audiodump.wav"
      success 
    rescue Errno::ENOENT => err
      puts "No audiodump :" + err
    end
   end
   
end
