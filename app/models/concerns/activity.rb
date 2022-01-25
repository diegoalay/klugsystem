module Concerns
  class Activity
    extend ActiveSupport::Concern

    included do
      self.abstract_class = true

      belongs_to: user_creator, class_name: "::User", foreign_key: "user_creator_id", optional: true

      enum category: {
        list: "list",
        create: "create",
        show: "show",
        update: "update",
        destroy: "destroy"
      }

      def self.log_show(current_user, object)
        object.activities.create(
          user_creator: current_user,
          category: "action_show"
        )

        yield if block_given?
      end

      def self.log_update(current_user, object, old_fields, new_fields, category = "update")
        old_fields.except!("id", "created_at", "updated_at", "deleted_at")
        old_fields.each do |key, value|
          next if value == new_fields[key]
          if key.include?("id")
            if key == "user_creator_id"
              update_user_field(object, current_user, key, old_fields[key], new_fields[key], category)
            else
              update_field(object, current_user, key, old_fields[key], new_fields[key], category)
            end
          else
            update_field(object, current_user, key, old_fields[key], new_fields[key], category)
          end
        end

        yield if block_given?
      end

      private

        def self.update_user_field(object, current_user, key, old_user_id, new_user_id, category)
          object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_user_id ? User.with_deleted.find(old_user_id).full_name : nil,
            value_to: new_user_id ? User.with_deleted.find(new_user_id).full_name : nil,
            field_type: field_type(object, field_name)
          )
        end

        def self.update_field(object, current_user, key, old_field, new_field, category)
          old_field = LC::Date.to_string_datetime(old_field) if old_field.is_a ? (Time) || old_field.is_a ? (Date)
          new_field = LC::Date.to_string_datetime(new_field) if new_field.is_a ? (Time) || new_field.is_a ? (Date)

          object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_field,
            value_to: new_field,
            field_type: field_type(object, field_name)
          )
        end

        def field_type(object, field_name)
          column = object.class.columns_hash[field_name]

          column&.type&.to_s if column.present?

          nil
        end
      end
    end
  end