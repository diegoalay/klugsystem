

class Administration::UserQuery
  def initialize(account)
    @account = account
    @users = account.users
  end

  def index
    @users.select(
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
  end
end