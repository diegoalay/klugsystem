

class Administration::RoleQuery
  def initialize(account)
    @account = account
  end

  def index
    @account.roles
    .joins('
      left join (
        select
          count(ur.id) as total,
          ur.role_id
        from user_roles ur
        group by ur.role_id
      ) as role_users
      on role_users.role_id = roles.id
    ')
    .select(
      'roles.id',
      'roles.name',
      'roles.code',
      'roles.created_at',
      'case
        when role_users.total is null then 0
        else role_users.total
      end as users_count'
    )
  end

  def users(role)
    role.users.select(
      'users.created_at',
      "concat(
        trim(users.first_name),
        ' ',
        trim(users.first_surname)
      ) as user_name",
      'users.email',
      'users.id'
    )
  end
end