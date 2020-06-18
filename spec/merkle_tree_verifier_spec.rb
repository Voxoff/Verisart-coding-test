require_relative '../main.rb'

RSpec.describe MerkleTreeVerifier do
  subject { MerkleTreeVerifier.new }

  describe '#merkle_root' do
    it 'returns the merkle root' do
      expect(subject.merkle_root).to eq "f832e7458a6140ef22c6bc1743f09610281f66a1b202e7b4d278b83de55ef58c"
    end
  end

  describe '#initial_message' do
    it 'returns the initial message' do
      expect(subject.initial_message).to eq "b4759e820cb549c53c755e5905c744f73605f8f6437ae7884252a5f204c8c6e6"
    end
  end

  describe '#parse_timestamps' do
    it 'creates an array of timestamps' do
      expect(subject.parse_timestamps).to all(be_an(Timestamp))
    end
  end

  describe '#verify_hash' do
    let(:verify_hash) { subject.verify_hash(timestamps, message, merkle_root) }
    let(:message) { subject.initial_message }
    let(:timestamps) { subject.parse_timestamps }
    let(:merkle_root) { subject.merkle_root }

    it 'prints outs verified' do
      expect { verify_hash }.to output(/VERIFIED/).to_stdout
    end

    context 'with an invalid merkle_root' do
      context 'invalid string' do
        let(:merkle_root) { "f832e7458a6140ef22c6bc1743f09610" }
        it 'prints out invalid' do
          expect { verify_hash }.to output(/INVALID/).to_stdout
        end
      end
      context 'with a non-string merkle_root' do
        let(:merkle_root) { 100 }
        it 'prints out invalid' do
          expect { verify_hash }.to raise_error(ArgumentError)
        end
      end
    end

    context 'with an invalid initial message' do
      context 'invalid string' do
        let(:message) { "f832e7458a6140ef22c6bc1743f096" }

        it 'raises an ArgumentError' do
          expect { verify_hash }.to output(/INVALID/).to_stdout
        end
      end
      context 'with a non-string message' do
        let(:message) { 100 }
        it 'raises an ArgumentError' do
          expect { verify_hash }.to raise_error(ArgumentError)
        end
      end
    end

    context 'with invalid timestamps' do
      context 'with array of non-timestamps' do
        let(:timestamps) { [
          'Wanderer above the Sea of Fog',
          'The Death of Marat'
        ] }

        it 'raises an ArgumentError' do
          expect { verify_hash }.to raise_error(ArgumentError)
        end
      end

      context 'with timestamps from an invalid merkle tree' do
        let(:timestamps) { [
          Timestamp.new("sha256", "", "e3be16e996ecf573979ca58498c5"),
          Timestamp.new("sha256", "0f8b9b68f4a5308a792b01029e64", ""),
        ] }

        it 'prints outs that the vile is invalid' do
          expect { verify_hash }.to output(/INVALID/).to_stdout
        end
      end
    end
  end

  describe '#convert_endian' do
    it 'converts one endian format to another' do
      little_endian_hex = "0e2b4c"
      big_endian_hex = "4c2b0e"
      expect(subject.convert_endian(little_endian_hex)).to eq big_endian_hex
      expect(subject.convert_endian(big_endian_hex)).to eq little_endian_hex
    end
  end

  describe '#verify' do
    it 'calls #parse_timestamps and #verify_hash' do
      expect(subject).to receive(:parse_timestamps)
      expect(subject).to receive(:verify_hash)

      subject.verify
    end
  end

  describe '#byte_array' do
    let(:hex) { "f832e7458a6140ef22c6bc1743f096" }

    it 'converts hex to a byte array' do
      expect(subject.byte_array(hex)).to eq "\xF82\xE7E\x8Aa@\xEF\"\xC6\xBC\x17C\xF0\x96"
    end
  end

  describe '#is_hex?' do
    context 'valid hex string' do
      let(:string) { "0Aff"}
      it 'returns integer (truthy)' do
        expect(subject.is_hex?(string)).to be_an(Integer)
      end
    end

    context 'invalid hex string' do
      let(:string) { "ZZ" }
      it 'returns nil' do
        expect(subject.is_hex?(string)).to be nil
      end
    end

    context 'invalid hex integer' do
      let(:string) { 99 }
      it 'returns nil' do
        expect(subject.is_hex?(string)).to be false
      end
    end
  end
end
