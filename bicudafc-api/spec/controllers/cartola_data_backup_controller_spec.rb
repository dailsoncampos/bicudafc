# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe CartolaDataBackupController, type: :controller do
  # include FakeFS::SpecHelpers

  context 'Creating backup rounds data' do
    let(:data) { '{"rodada_id":1, "inicio":"2019-04-27 16:00:00", "fim":"2019-05-02 20:00:00"}' }

    it 'verifies if the content from file is parsed' do
      result = subject.to_parse(data)
      # result = JSON.parse(data)
      # expect(result).to include('rodada_id' => eq(1))
      expect(result).to include("inicio" => match("2019-04-27 16:00:00"))
      expect(result).to include("fim" => match("2019-05-02 20:00:00"))
    end

    it 'verifies if the file is saved in temporary directory' do
    end

    it 'verifies if the file is not blank' do
    end

    it 'verifies if the first round was created' do
    end
  end
end
