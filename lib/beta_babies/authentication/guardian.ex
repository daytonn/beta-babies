defmodule BetaBabies.Authentication.Guardian do
  use Guardian, otp_app: :beta_babies

  alias BetaBabies.Authentication

  def subject_for_token(account, _claims), do: {:ok, to_string(account.id)}

  def resource_from_claims(%{"sub" => id}) do
    case Authentication.get_account(id) do
      nil -> {:error, :resource_not_found}
      acount -> {:ok, acount}
    end
  end
end
