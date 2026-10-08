class Admin::UploadsController < ApplicationController
  skip_forgery_protection only: :image

  def image
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params[:image],
      filename: params[:image].original_filename,
      content_type: params[:image].content_type
    )

    render json: {
      success: 1,
      file: { url: url_for(blob)}
    }
  end
end
