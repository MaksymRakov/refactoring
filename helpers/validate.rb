module Validate
  def validate_name(errors, name)
    unless name != '' && name[0].upcase == name[0]
      errors.push('Your name must not be empty and starts with first upcase letter')
    end
    errors
  end

  def validate_login(errors, login, accounts)
    if login == ''
      errors.push('Login must present')
    end

    if login.length < 4
      errors.push('Login must be longer then 4 symbols')
    end

    if login.length > 20
      errors.push('Login must be shorter then 20 symbols')
    end

    if accounts.map { |a| a.login }.include? login
      errors.push('Such account is already exists')
    end
    errors
  end

  def validate_password(errors, password)
    if password == ''
      errors.push('Password must present')
    end

    if password.length < 6
      errors.push('Password must be longer then 6 symbols')
    end

    if password.length > 30
      errors.push('Password must be shorter then 30 symbols')
    end
    errors
  end
end