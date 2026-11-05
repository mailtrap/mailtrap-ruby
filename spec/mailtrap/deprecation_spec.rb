# frozen_string_literal: true

RSpec.describe Mailtrap::Deprecation do
  describe '.warn' do
    it 'warns once per deprecated name' do
      expect { described_class.warn('Old', 'New') }.to output(
        /warning: \[mailtrap\] Old is deprecated and will be removed in a future major release; use New instead\.$/
      ).to_stderr
      expect { described_class.warn('Old', 'New') }.not_to output.to_stderr
      expect { described_class.warn('Older', 'New') }.to output(/Older is deprecated/).to_stderr
    end
  end
end
