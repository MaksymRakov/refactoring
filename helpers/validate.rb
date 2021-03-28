module Validate
  def validate_name(errors, name)
    errors.push(I18n.t(:ampty_name)) unless name != '' && name[0].upcase == name[0]
    errors
  end

  def validate_login(errors, login, accounts)
    errors.push(I18n.t(:login_present)) if login == ''
    errors.push(I18n.t(:min_login_lemngth)) if login.length < 4
    errors.push(I18n.t(:max_login_lemngth)) if login.length > 20
    errors.push(I18n.t(:account_exist)) if accounts.map(&:login).include? login
    errors
  end

  def validate_password(errors, password)
    errors.push(I18n.t(:password_present)) if password == ''
    errors.push(I18n.t(:min_password_lemngth)) if password.length < 6
    errors.push(I18n.t(:max_password_lemngth)) if password.length > 30
    errors
  end
end
