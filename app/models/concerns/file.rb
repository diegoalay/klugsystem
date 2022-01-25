module Concerns
  class File
    extend ActiveSupport::Concern

    included do
      self.abstract_class = true
      mount_uploader :attachment, LocalUploader

      def destroy
        update(attachment: nil, attachment_s3: nil, attachment_public: nil)

        super
      end
    end
  end
end