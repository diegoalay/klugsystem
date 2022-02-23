class Employee::File < Shared::File
  belongs_to :object_model, class_name: "Employee", foreign_key: "employee_id"
end
