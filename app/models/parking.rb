class Parking < ApplicationRecord
  include ActionView::Helpers::DateHelper
  before_create do
    self.status ||= :waiting_payment
  end

  validate :plate_has_pendency?, on: :create

  enum status: {waiting_payment: 0, paid: 1, closed: 2} do
    event :pay do
      before { self.paid_at = Time.zone.now }

      transition :waiting_payment => :paid
    end

    event :out do
      before { self.left_at = Time.zone.now }

      transition :paid => :closed
    end
  end

  def plate_has_pendency?
    if Parking.where(plate: self.plate).where("parkings.paid_at IS NULL OR parkings.left_at IS NULL").any?
      errors.add(:plate, "this plate has pendency")
    end
  end

  def time
    self.paid? ? distance_of_time_in_words(self.paid_at, self.created_at) : distance_of_time_in_words(Time.zone.now, self.created_at)
  end

  def paid?
    self.paid_at.present?
  end

  def left?
    self.left_at.present?
  end
end
