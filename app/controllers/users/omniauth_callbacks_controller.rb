class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = 'Google 계정으로 성공적으로 로그인되었습니다.'
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: '회원가입에 실패했습니다. 다시 시도해주세요.'
    end
  end

  def kakao
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = '카카오 계정으로 성공적으로 로그인되었습니다.'
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.kakao_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: '회원가입에 실패했습니다. 다시 시도해주세요.'
    end
  end

  def naver
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = '네이버 계정으로 성공적으로 로그인되었습니다.'
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.naver_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: '회원가입에 실패했습니다. 다시 시도해주세요.'
    end
  end

  def failure
    redirect_to root_path, alert: '소셜 로그인에 실패했습니다. 다시 시도해주세요.'
  end
end