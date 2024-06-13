module R2mp3
  module Version
    MAJOR = '0'
    MINOR = '3'
    TINY = '1'
    BUILD = Time.now.to_i.to_s
  end
  VERSION = [Version::MAJOR, Version::MINOR, Version::TINY, Version::BUILD].compact * '.'
end
