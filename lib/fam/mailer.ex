defmodule Fam.Mailer do
  use Mailgun.Client,
      domain: Application.get_env(:fam, :mailgun_domain),
      key: Application.get_env(:fam, :mailgun_key)

  def send_login_email(email_address, token) do
    send_email to: email_address,
               from: "us@example.com",
               subject: "Confirm Login",
               text: "Click the following link: http://example.com/session/verify/#{token}"
  end
end


# claim=%{"email" => "tim@timmorgan.org", "exp" => Guardian.Utils.timestamp + 3600, "iss" => "Fam"}
# iex(44)> { :ok, jwt} = Joken.encode(claims)                                                                                                                   {:ok,                                                                                                                                                          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGYW0iLCJleHAiOjEwMDAwMDAwLCJlbWFpbCI6InRpbUB0aW1tb3JnYW4ub3JnIn0.lBrHErfsW7zW9bLSpra19VKibQ-KiGLETtUOW8i-7kE"}
# iex(45)> Guardian.decode_and_verify(jwt)
