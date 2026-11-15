class Pass < ApplicationRecord
  validates :valid_until, presence: true
  validates_comparison_of :entries_left, greater_than_or_equal_to: 0
  validates_comparison_of :entries_total, greater_than: 0
  validates_comparison_of :entries_left, less_than_or_equal_to: :entries_total
  belongs_to :user

  scope :usable, -> { where("valid_until > ?", Date.current).where("entries_left > 0") }

  def expiring_soon?
    valid_until.present? &&
      valid_until >= Date.current &&
      valid_until <= 7.days.from_now.to_date
  end

  def low_entries?
    entries_left == 1
  end
end
