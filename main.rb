require 'json'
require 'openssl'

class Timestamp
  attr_reader :prefix, :postfix, :operator
  def initialize(operator, prefix, postfix)
    @operator = operator
    @prefix = prefix
    @postfix = postfix
  end
end

class MerkleTreeVerifier
  attr_reader :merkle_root, :initial_message

  def initialize
    @merkle_root = "f832e7458a6140ef22c6bc1743f09610281f66a1b202e7b4d278b83de55ef58c"
    @initial_message = "b4759e820cb549c53c755e5905c744f73605f8f6437ae7884252a5f204c8c6e6"
  end

  def verify
    timestamps = parse_timestamps
    verify_hash(timestamps, @initial_message, @merkle_root)
  end

  def parse_timestamps
    file = File.open('./bag/timestamp.json')
    data = JSON.parse(file.read)
    timestamps = data.map { |array| Timestamp.new(array[0], array[1], array[2]) }
  end

  def verify_hash(timestamps, message, merkle_root)
    raise ArgumentError unless timestamps.all? { |element| element.is_a?(Timestamp)}
    raise ArgumentError unless is_hex?(message)
    raise ArgumentError unless is_hex?(merkle_root)

    current_message = message

    timestamps.each do |timestamp|
      current_message = timestamp.prefix + current_message + timestamp.postfix
      digest = OpenSSL::Digest.new(timestamp.operator, byte_array(current_message))
      current_message = digest.to_s
    end

    if current_message == convert_endian(merkle_root)
      puts "VERIFIED"
    else
      puts "INVALID"
    end
  end

  def is_hex?(str)
    str.is_a?(String) && str =~ /^[[:xdigit:]]+$/
  end

  def byte_array(str)
    # High nibble first
    [str].pack("H*").force_encoding('UTF-8')
  end

  def convert_endian(str)
    str.scan(/../).reverse.join
  end
end


MerkleTreeVerifier.new.verify
