class Admin::UploadsController < Admin::BaseController
  ALLOWED_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_SIZE = 10.megabytes

  def image
    file = params[:image]

    unless file.respond_to?(:content_type) && ALLOWED_TYPES.include?(file.content_type) && file.size <= MAX_SIZE
      return render json: { success: 0, message: 'Fichier invalide'}, status: :unprocessable_entity
    end

    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: file.original_filename,
      content_type: file.content_type,
    )

    render json: { success: 1, file: { url: rails_blob_url(blob) } }
  end
end
