

class Administration::UserQuery
  def initialize(account)
    @account = account
  end

  def index
    @account.users.select(
      'branch_offices.name as branch_office_name',
      'users.created_at',
      "concat(
        trim(users.first_name),
        ' ',
        trim(users.first_surname)
      ) as user_name",
      'users.email',
      'roles.name as role_name',
      'users.id'
    )
    .left_joins(:roles)
    .joins(:branch_office)
  end

  def options
    {
      branch_offices: @account.branch_offices.map {|branch_office| {value: branch_office.id, text: branch_office.name}},
      roles: @account.roles.map {|role| {value: role.id, text: role.name}}
    }
  end
end