using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

namespace JobPortal
{
    public partial class Email_Verify : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "Email Verification - Trust Bank";

            if (!IsPostBack)
            {
                string Msg = "";
                string PageAccessType = "";
                string Query = "s_Email_Varify_Check";

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = System.Configuration.ConfigurationManager
                                    .ConnectionStrings["JobPortalConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand(Query, conn))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", Request.QueryString["email"]);
                        cmd.Parameters.Add("@ID", System.Data.SqlDbType.BigInt).Value = string.Format("{0}", Request.QueryString["id"]);
                        cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", Request.QueryString["keycode"]);

                        SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                        SQL_Msg.Direction = ParameterDirection.InputOutput;
                        SQL_Msg.Value = Msg;
                        cmd.Parameters.Add(SQL_Msg);

                        SqlParameter SQL_PageAccessType = new SqlParameter("@PageAccessType", SqlDbType.VarChar, 50);
                        SQL_PageAccessType.Direction = ParameterDirection.InputOutput;
                        SQL_PageAccessType.Value = "";
                        cmd.Parameters.Add(SQL_PageAccessType);

                        SqlParameter SQL_ReturnKeycode = new SqlParameter("@ReturnKeycode", SqlDbType.UniqueIdentifier);
                        SQL_ReturnKeycode.Direction = ParameterDirection.InputOutput;
                        cmd.Parameters.Add(SQL_ReturnKeycode);
                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                        Msg = string.Format("{0}", SQL_Msg.Value);
                        PageAccessType = string.Format("{0}", SQL_PageAccessType.Value);

                        if (Msg.Trim().Length > 0)
                            lblError.Text = (Msg);

                        if (PageAccessType.ToUpper() == "INVALID")
                        {
                            PanelError.Visible = true;
                            lnkErrorGo.NavigateUrl = "~/Signup.aspx";
                            return;
                        }
                        if (PageAccessType.ToUpper() == "EXPIRED")
                        {
                            PanelError.Visible = true;
                            lnkErrorGo.NavigateUrl = "~/Signup.aspx";
                            return;
                        }

                        hidReturnKeycode.Value = string.Format("{0}", SQL_ReturnKeycode.Value);
                        PanelEmailVarified.Visible = true;

                    }
                }
            }
        }

        //public void ClientMsg(string MsgTxt)
        //{
        //    ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank')", true);
        //}
        protected void cmdStartInsert_Click(object sender, EventArgs e)
        {
            //System.Threading.Thread.Sleep(2000);
            Response.Redirect(string.Format("Default.aspx?email={0}", Request.QueryString["email"]), true);
        }
    }
}