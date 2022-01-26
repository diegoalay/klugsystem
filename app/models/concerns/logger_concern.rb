
  module LoggerConcern
    extend ActiveSupport::Concern

    included do
      after_create  :log_create
      after_destroy :log_destroy
      after_update  :log_update

      belongs_to :user_creator, class_name: "::User", foreign_key: "user_creator_id", optional: true

      enum category: {
        list: "list",
        create: "create",
        show: "show",
        update: "update",
        destroy: "destroy"
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
        fields.keys.except!("created_at", "updated_at", "deleted_at").each do |key|
          old_value = fields[key].first
          new_value = fields[key].last

          next if old_value == new_value

          update_field(key, old_value, new_value, category)

          yield if block_given?
        end
      end


    private

    def self.update_field(key, old_field, new_field, category)
      # old_field = LC::Date.to_string_datetime(old_field) if old_field.is_a ? (Time) || old_field.is_a ? (Date)
      # new_field = LC::Date.to_string_datetime(new_field) if new_field.is_a ? (Time) || new_field.is_a ? (Date)

      object.activities.create(
        user_creator: self.user_modifier,
        category: category,
        field_name: key,
        value_from: old_field,
        value_to: new_field,
        field_type: field_type(field_name)
      )
    end

    def field_type(field_name)
      column = self.class.columns_hash[field_name]

      column&.type&.to_s if column.present?

      nil
    end
  end
end