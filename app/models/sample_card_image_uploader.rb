class SampleCardImageUploader
  def self.upload(card)
    new(card).upload
  end

  def initialize(card)
    @card = card
  end

  def upload
    s3_bucket.object(card.id.to_s).put(body: card_image_bin(card.organization, card.department, card.name, card.email))
  end

  private

  attr_reader :card

  def s3_bucket
    s3_resource.bucket('cards').exists? ? s3_resource.bucket('cards') : s3_resource.create_bucket(bucket: 'cards')
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new(
      endpoint: 'http://serverside-1dayinternship_minio_1:9000',
      region: 'us-east-1',
      access_key_id: 'ak_eight',
      secret_access_key: 'sk_eight',
      force_path_style: true
    )
  end

  def card_image_bin(org, dep, name, email)
    color = '#' + Array.new(3) { [*126..255].sample.to_s(16) }.join
    image = Magick::Image.new(600, 381) do
      self.format = 'jpeg'
      self.background_color = color
    end
    draw = Magick::Draw.new.tap do |d|
      d.font = 'VL-Gothic-Regular'
      d.pointsize = 40
      d.gravity = Magick::NorthWestGravity
    end
    draw.annotate(image, 600, 381, 0, 0, "#{org}\n#{dep}")
    draw.pointsize = 32
    draw.gravity = Magick::SouthEastGravity
    draw.annotate(image, 600, 381, 0, 0, "#{name}\n#{email}")
    image.to_blob
  end
end
