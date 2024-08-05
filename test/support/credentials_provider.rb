# frozen_string_literal: true

class CredentialsProvider
  include Singleton

  class << self
    def key
      instance.key
    end

    def cert
      instance.cert
    end
  end

  def key
    key_cert.first
  end

  def cert
    key_cert.last
  end

  private
    def key_cert
      @key_cert ||= generate_key_cert
    end

    def generate_key_cert
      priv_key_path = Tempfile.create.path
      pub_key_path = "#{priv_key_path}.pub"

      File.delete(priv_key_path)
      system("ssh-keygen -t rsa -b 1024 -q -f #{priv_key_path} -N ''")

      cert_path = "#{priv_key_path}-cert.pub"
      system("ssh-keygen -q -s #{priv_key_path} -I your-identity -n user -V +1h #{pub_key_path}")

      [ File.read(priv_key_path), File.read(cert_path) ]
    end
end
