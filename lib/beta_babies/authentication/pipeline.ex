defmodule BetaBabies.Authentication.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :beta_babies,
    error_handler: BetaBabies.Authentication.ErrorHandler,
    module: BetaBabies.Authentication.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the account if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
