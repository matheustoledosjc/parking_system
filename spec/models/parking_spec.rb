require "rails_helper"

RSpec.describe "Parking", type: :model do
  let(:created_parking) { create(:parking, created_at: 4.hours.ago) }
  let(:paid_parking) { create(:parking, :paid, created_at: 5.hours.ago, paid_at: 4.hours.ago) }
  let(:left_parking) { create(:parking, :left, created_at: 7.hours.ago, paid_at: 5.hours.ago, left_at: 4.hours.ago) }
  let(:unsaved_parking) { Parking.new(plate: created_parking.plate) }

  describe 'should be invalid when plate haspendency' do
    it { expect(unsaved_parking).to be_invalid }
  end

  describe '#plate_has_pendency?' do
    it 'return true when plate has a parking pending' do
      expect(created_parking.plate_has_pendency?).to be_truthy
      expect(paid_parking.plate_has_pendency?).to be_truthy
    end

    it 'return false when plate has not parking pending' do
      expect(left_parking.plate_has_pendency?).to be_falsey
    end
  end

  describe '#time' do
    it 'when parking is paid or closed, should be the difference between pay time and creation time' do
      expect(paid_parking.time).to eq('about 1 hour')
      expect(left_parking.time).to eq('about 2 hours')
    end

    it 'when parkin is created, should be the difference between current time and creation time' do
      expect(created_parking.time).to eq('about 4 hours')
    end
  end

  describe '#paid?' do
    it 'return true when plate has paid_at value' do
      expect(paid_parking.paid?).to be_truthy
      expect(left_parking.paid?).to be_truthy
    end

    it 'return false when plate has not paid_at value' do
      expect(created_parking.paid?).to be_falsey
    end
  end

  describe '#left?' do
    it 'return true when plate has left_at value' do
      expect(left_parking.left?).to be_truthy
    end

    it 'return false when plate has not left_at value' do
      expect(created_parking.left?).to be_falsey
      expect(paid_parking.left?).to be_falsey
    end
  end
end