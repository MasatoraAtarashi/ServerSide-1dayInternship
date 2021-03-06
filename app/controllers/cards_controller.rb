class CardsController < ApplicationController
  def show
    s3 = Aws::S3::Resource.new(
      endpoint: 'http://serverside-1dayinternship_minio_1:9000',
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.aws[:access_key_id],
      secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      force_path_style: true
    )
    bucket = s3.bucket('cards').exists? ? s3.bucket('cards') : s3.create_bucket(bucket: 'cards')
    obj = bucket.object(params[:id].to_s)
    image = obj.get
    send_data image.body.read
  end

  def create
    # mergeされた時はpersonを保存しないようにしようとしたが断念
    ActiveRecord::Base.transaction do
      card = Person.create.cards.build(card_params)
      card.merge
      card.save!
      SampleCardImageUploader.upload(card)
    end

    head :created
  end

  private

  def card_params
    params.permit(:name, :email, :organization, :department, :title)
  end
end
