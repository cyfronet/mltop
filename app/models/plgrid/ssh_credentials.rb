require "net/ssh"

class Plgrid::SshCredentials
  def initialize(key, certificate)
    @key = key
    @certificate = certificate
  end

  def valid?
    return false unless @certificate.present?

    pk = Net::SSH::KeyFactory.load_data_public_key(@certificate)
    pk.valid_after.past? && pk.valid_before.future?
  rescue Net::SSH::Exception
    false
  end
end
