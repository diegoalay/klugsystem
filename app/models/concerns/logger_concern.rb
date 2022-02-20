
  module LoggerConcern
    extend ActiveSupport::Concern

    included do
      acts_as_paranoid

      belongs_to :account,       class_name: "Account", foreign_key: "account_id"
      belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id", optional: :true
      belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

      has_many   :activities, foreign_key: "#{name.titleize.downcase.gsub("/", "_").gsub(" ", "_")}_id"

      after_create  :log_create
      after_destroy :log_destroy
      after_update  :log_update

      enum category: {
        list: "list",
        create: "create",
        show: "show",
        update: "update",
        destroy: "destroy",
        create_file: "create_file",
        destroy_file: "destroy_file",
      }, _prefix: :categories

      def log_show(current_user)
        self.activities.create(
          user_creator: current_user,
          category: "show"
        )

        yield if block_given?
      end

      def log_destroy
        self.activities.create(
          user_creator: self.user_modifier,
          category: "destroy"
        )

        yield if block_given?
      end

      def log_create
        self.activities.create(
          user_creator: self.user_creator,
          category: "create"
        )

        yield if block_given?
      end

      def log_update(category = "update")
        fields = self.previous_changes

        fields.each do |key, values|
          next if key == "updated_at"
          next if key == "created_at"
          next if key == "deleted_at"

          old_value = values.first
          new_value = values.last

          next if old_value == new_value

          update_field(key, old_value, new_value, category)

          yield if block_given?
        end
      end


    private

    def update_field(field, old_field, new_field, category)
      ActiveRecord::Base.transaction do
        self.activities.create(
          user_creator: self.user_modifier,
          category: category,
          field_name: field,
          value_from: old_field,
          value_to: new_field,
          field_type: field_type(field)
        )
      end
    end

    def field_type(field_name)
      column = self.class.columns_hash[field_name]
      return column&.type&.to_s if column.present?

      nil
    end
  end
end