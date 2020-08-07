class Micropost < ApplicationRecord
  PARAMS = %i(content image).freeze
  TYPES = Settings.micropost.format.freeze

  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: true, allow_nil: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_length}
  validates :image, content_type: {in: TYPES,
                                   message: I18n.t("microposts.must_be_a_valid_image_format")},
                    size: {less_than: Settings.micropost.image.size.megabytes,
                           message: I18n.t("micoposts.should_be_less_than")}

  scope :created_post_at, ->{order created_at: :desc}

  def display_image
    image.variant resize_to_limit: Settings.micropost.image.resize_to_limit
  end
end
