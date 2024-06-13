require "r2mp3/tool"
module R2mp3
  class Converter < Data.define(:input_file, :output_file, :bitrate)
    def run!
      command = "#{R2mp3::FFMPEG} -i #{input_file} -acodec libmp3lame -ab #{bitrate}k #{output_file}"

      result, err, s = Open3.capture3(command)
      return if s.success?

      print err
      nil
    end
  end
end
