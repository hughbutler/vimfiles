# == Schema Information
#
# Table name: attributes
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  hint_field            :string(255)
#  is_searchable         :boolean
#  attribute_type_id     :integer
#  community_id          :integer
#  attribute_position_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class Attribute < ApplicationRecord

  # Callbacks
  after_save :assign_available_answers

  # Associations
  has_many :answers, class_name: 'Attribute::Answers', dependent: :destroy
  has_many :values, class_name: 'Attribute::Value', dependent: :destroy

  belongs_to :community
  belongs_to :type, foreign_key: 'attribute_type_id', class_name: 'Attribute::Type', dependent: :destroy
  belongs_to :position, foreign_key: 'attribute_position_id', class_name: 'Attribute::Position', dependent: :destroy

  validates_presence_of :title, :attribute_type_id, :attribute_position_id

  attr_writer :available_answers

  scope :by_position,       -> (tag_string) { where('lower(attribute_positions.tag) = ?', tag_string.downcase).joins(:position) }

  def to_s
    self[:title]
  end

  def available_answers
    @available_answers || values.map(&:title).join(', ') || nil
  end

  def has_available_answers?
    (attribute_type_id.present?) ? type.tag == 'select' : false
  end

  private

  def assign_available_answers
    if @available_answers.present?
      self.values = @available_answers.split(/,\s+/).map { |available_answer| AttributeValue.find_or_create_by_title_and_attribute_id(available_answer, self.id) }
    end
  end

end
