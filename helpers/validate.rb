module Validate
  def validate_name(errors, name)
    errors.push(I18n.t(:ampty_name)) unless name != '' && name[0].upcase == name[0]
    errors
  end

  def validate_login(errors, login, accounts)
    errors.push('Login must present') if login == ''
    errors.push('Login must be longer then 4 symbols') if login.length < 4
    errors.push('Login must be shorter then 20 symbols') if login.length > 20
    errors.push('Such account is already exists') if accounts.map(&:login).include? login
    errors
  end

  def validate_password(errors, password)
    errors.push('Password must present') if password == ''
    errors.push('Password must be longer then 6 symbols') if password.length < 6
    errors.push('Password must be shorter then 30 symbols') if password.length > 30
    errors
  end
end
