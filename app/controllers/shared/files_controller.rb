class Shared::FilesController < ApplicationController

  def index
    set_object_model

    respond_to do |format|
      format.json do
        @files = @object_model.files
        .order(id: :desc).map do |file|
          file_attributes = file.attributes
          file_attributes["user_creator_name"] = file.user_creator&.name
          file_attributes["public_url"] = file.attachment_public.url if file.attachment_public
          file_attributes["created_at_raw"] = file_attributes["created_at"]
          file_attributes["updated_at_raw"] = file_attributes["updated_at"]
          file_attributes
        end

        if block_given?
          yield(@files)
        else
          respond_with_successful(@files)
        end
      end

      format.zip do
        @files = @object_model.files
        .where(
          "#{file_model.table_name}.id in (#{params[:ids]})"
        )

        handle_zip_download(@files)
      end
    end
  end

  def show
    set_file

    return respond_with_not_found unless @file

    disposition = "inline"
    disposition = "attachment" if params["download"]

    # Sending file using CarrierWave
    if @file.attachment_s3.file

      # We either get the file from AWS and serve it ourselves or provide a direct AWS link with expiration time
      if @file.size_mb && @file.size_mb > file_model.size_threshold
        redirect_to @file.refresh_external_url
      else
        send_data(@file.attachment_s3.read, filename: @file.name_with_extension, disposition: disposition, stream: "true")
      end
    else
      send_data(@file.attachment.file.read, filename: @file.name_with_extension, disposition: disposition, stream: "true")
    end
  end

  def create
    set_object_model

    new_file_params = file_params.merge(
      user_creator: current_user,
      object_model: @object_model
    )

    # Verifying the extension of the file. If it's valid, the block will be executed
    decode_and_verify_file(new_file_params) do |verified_file_params|

      file = file_model().new(verified_file_params)

      if file.save
        # Setting the file name in case it's blank and updating the file in case the filename changed
        if file.name.blank?
            file.update(
              name: params[:file][:attachment].original_filename
            )
        else
            file.update({})
        end

        # Setting up file uploader to upload in background
        Files::AwsUploadJob.perform_later(file)

        if block_given?
          yield(file.object_model, file)
        else
          # Registering an activity in the object
          file.object_model.activities.create(
            user_creator: current_user,
            category: "create_file",
            description: "#{file.name} - #{file.attachment_identifier}"
          )

          respond_with_successful(file)
        end
      else
        respond_with_error(file.errors.full_messages.to_sentence)
      end
    end
  end

  def set_object_model
    @object_model = object_model().find_by(
      account: current_user.account,
      id: params["#{object_model.name.demodulize.underscore}_id".to_sym],
    )
  end

  def destroy
    set_file

    return respond_with_not_found unless @file

    if @file.destroy
      if block_given?
          yield(@object_model, @file)
      else
        @object_model.activities.create(
            user_creator: current_user,
            category: "destroy_file",
            description: @file.name
        )

        respond_with_successful
      end
    else
      respond_with_error(@file.errors.full_messages.to_sentence)
    end
  end

  def set_file
    set_object_model

    return unless @object_model

    @file = @object_model.files.find_by(id: params[:id])
  end

  def object_model
    self.class.name.gsub("FilesController","").singularize.constantize
  end

  def file_model
    self.class.name.gsub("Controller","").singularize.constantize
  end

  def file_params
    params.fetch(:file).permit(%i[name attachment])
  end

  def extensions
    respond_with_successful(file_model.allowed_file_extensions)
  end

  protected

  def handle_zip_download(files)
    s3 = LC::Config::Providers::Aws::S3.new()

    zip_stream = ::Zip::OutputStream.write_buffer do |zip|
      files.each do |file|
        # Handling an AWS S3 file
        if file.attachment_s3.file
          file_filepath = file.attachment_s3.current_path
          filename = file.attachment_s3_identifier
          file_obj = s3.get_object(file_filepath)
          zip.put_next_entry filename
          zip.print file_obj.body.read
        # Haindling a local storage file
        elsif file.attachment.file
          file_filepath = file.attachment.current_path
          filename = file.attachment_identifier
          next unless ::File.exist?(file_filepath)
          zip.put_next_entry filename
          zip.print IO.binread(file_filepath)
        end
      end
    end

    zip_stream.rewind
    send_data zip_stream.read, filename: "all_documents_#{Date.today.strftime('%d_%B_%Y')}.zip", type: 'application/zip'
  end

  def decode_and_verify_file(file_params)
    # Verifying the extension of the file
    extension = ""

    if file_params[:attachment]
      file_extension = file_params[:attachment].original_filename&.split(".")[-1]
      file_name = file_params[:name]

      if file_params[:attachment].is_a? String
        # Base64 images

        if @file
          file_name = @file.name.downcase
        else
          file_name = "file_#{DateTime.now.strftime("%Y%m%d%H%M%S")}"
        end

        img_from_base64 = Base64.decode64(file_params[:attachment])

        begin
          extension = /(png|jpg|jpeg|exif|jfif)/.match(img_from_base64[0,16].downcase)[0]
        rescue
          return invalid_extensions() unless file_model.verify_file_extension(extension)
        end

        # Due a encode issue, jpeg images are sent as jfif
        extension = "jpeg" if extension == "jfif"
        extension = "png"  if extension == "exif"

        return invalid_extensions() unless file_model.verify_file_extension(extension)

        file_path = Rails.root.join("public", "uploads", "tmp", file_name << '.' << extension)
        File.open(file_path, 'wb') do|f|
            f.write(img_from_base64)
        end

        file_params[:attachment] = File.open(Rails.root.join(file_path), "rb")
        FileUtils.rm_rf(Rails.root.join(file_path))
      else
        extension = file_params[:attachment].original_filename

        return invalid_extensions() unless file_model.verify_file_extension(extension)
      end
    end

    file_params[:file_extension] = file_extension
    file_params[:name] = file_name

    if block_given?
      yield(file_params)
    end
  end

  def invalid_extensions()
    respond_with_error("Extensión inválida, las extensiones permitidas son [#{file_model.verify_file_extension.join(", ")}]")
  end
end
