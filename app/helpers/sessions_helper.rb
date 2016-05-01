module SessionsHelper
  def sign_in(user)
    # トークンを新規作成する
    remember_token = User.new_remember_token

    # permanentメソッドによって自動的に期限が20.years.from_nowに設定される
    cookies.permanent[:remember_token] = remember_token

    # 暗号化したトークンをデータベースに保存する
    # update_attributeを使用して検証をすり抜けて単一の属性を更新する
    user.update_attribute(:remember_token, User.encrypt(remember_token))

    # 与えられたユーザーを現在のユーザーに設定する
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # current_userへの要素代入を定義する
  def current_user=(user)
    @current_user = user
  end

  def current_user
    # 記憶トークンに対応するユーザーを検索する
    # データベース上の記憶トークンは暗号化されているので、
    # cookiesから取り出した記憶トークンは、データベース上の記憶トークンを検索する前に暗号化する
    remember_token = User.encrypt(cookies[:remember_token])
    # ||= は、@current_userが未定義の場合にのみ、@current_userインスタンス変数に記憶トークンを設定する
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end
end
