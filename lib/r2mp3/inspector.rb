require "wahwah"
module R2mp3
  class Inspector < Data.define(:file)
    def info
      nil unless File.extname(file).eql?(".mp3")
      tag = nil
      File.open file do |f|
        tag = WahWah::Mp3Tag.new(f)
      end
      tag.instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete("@")] = tag.instance_variable_get(var)
      end
    end
  end
end
