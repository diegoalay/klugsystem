class Shared::File < ApplicationRecord
  include ActiveModel::Dirty

  self.abstract_class = true
  mount_uploader :attachment_s3,      AwsUploader
  mount_uploader :attachment,         LocalUploader

  belongs_to :user_creator, class_name: "User", foreign_key: "user_creator_id"

  validates_presence_of :attachment, on: :create

  def self.object_model
    self.reflect_on_association(:object).klass
  end

  def self.verify_file_extension(filename)
    allowed_file_extensions_ = self.allowed_file_extensions

    return true unless allowed_file_extensions_

    allowed_file_extensions_.each do |file_extesion|
        if filename.downcase.end_with?(file_extesion)
            return true
        end
    end

    return false
  end

  def destroy
    update(
      attachment: nil,
      attachment_s3: nil,
      attachment_public: nil
    )

    super
  end

  def self.allowed_file_extensions
    return [
      "jpeg",
      "png",
      "jpg",
      "gif",
      "pdf",
      "docx"
    ]
  end
end
