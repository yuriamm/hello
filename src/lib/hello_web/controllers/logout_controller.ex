defmodule HelloWeb.LogoutController do   
    use HelloWeb, :controller
    
   def delete(conn, _params) do
        conn
        |> delete_session(:current_user)
        |> put_flash(:info, "Successfully signed out!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
end