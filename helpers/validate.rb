module Validate
  def validate_name(errors, name)
    errors.push(I18n.t(:ampty_name)) if name.empty? || name[0].upcase != name[0]
    errors
  end

  def validate_login(errors, login, accounts)
    errors.push(I18n.t(:login_present)) if login.empty?
    errors.push(I18n.t(:min_login_lemngth)) if login.length < MIN_LOGIN_LENGTH
    errors.push(I18n.t(:max_login_lemngth)) if login.length > MAX_LOGIN_LENGTH
    errors.push(I18n.t(:account_exist)) if accounts.map(&:login).include? login
    errors
  end

  def validate_password(errors, password)
    errors.push(I18n.t(:password_present)) if password.empty?
    errors.push(I18n.t(:min_password_lemngth)) if password.length < MIN_PASSWORD_LENGTH
    errors.push(I18n.t(:max_password_lemngth)) if password.length > MAX_PASSWORD_LENGTH
    errors
  end
end
