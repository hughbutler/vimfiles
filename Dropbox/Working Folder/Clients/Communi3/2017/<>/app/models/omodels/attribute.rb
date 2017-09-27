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

class Attribute < ActiveRecord::Base
  belongs_to :community
  belongs_to :attribute_type
  belongs_to :attribute_position

  has_many :attribute_values, :dependent => :destroy
  has_many :attribute_answers, :dependent => :destroy

  validates_presence_of :title, :attribute_type_id, :attribute_position_id
  attr_writer :available_answers
  after_save :assign_available_answers

  scope :by_community, lambda { |community_id| where('community_id = ?', community_id) }
  scope :by_position, lambda { |tag_string| where('lower(attribute_positions.tag) = ?', tag_string.downcase).joins(:attribute_position) }
  # scope :selects_only, where('attribute_types.tag = ?', 'select').joins(:attribute_type).includes(:attribute_type)
  # scope :textareas_only, where('attribute_types.tag = ?', 'textarea').joins(:attribute_type).includes(:attribute_type)
  # scope :inputs_only, where('attribute_types.tag = ?', 'input').joins(:attribute_type).includes(:attribute_type)

  def to_s
    self[:title]
  end

  def available_answers
    @available_answers || attribute_values.map(&:title).join(', ') || nil
  end

  def has_available_answers?
    (attribute_type_id.present?) ? self.attribute_type.tag == 'select' : false
  end

  private

  def assign_available_answers
    if @available_answers.present?
      self.attribute_values = @available_answers.split(/,\s+/).map { |available_answer| AttributeValue.find_or_create_by_title_and_attribute_id(available_answer, self.id) }
    end
  end

end
