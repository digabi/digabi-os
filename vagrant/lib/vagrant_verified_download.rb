require 'digest'
require 'vagrant/util/downloader'
require 'vagrant/errors'

def check(path)
  checksum = Digest::SHA256.new.file(path).hexdigest
  if checksum != BOX_CHECKSUM
    raise Vagrant::Errors::BoxVerificationFailed.new
  end
end

module Vagrant
  if vagrant_old
    class Action::Box::Download
      alias :unverified_download :download
      def download
        unverified_download
        check(@temp_path)
      end
    end
  else
    class Util::Downloader
      alias :unverified_download! :download!
      def download!
        unverified_download!
        check(@destination)
      end
    end
  end
end
