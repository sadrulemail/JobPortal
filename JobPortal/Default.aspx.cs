using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

namespace JobPortal
{
    public partial class DefaultPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "Trust Bank Job Portal";

            if (!IsPostBack)
            {
                string Email = string.Format("{0}", Request.QueryString["email"]);
                if (Email.Trim().Length > 0)
                {
                    txtLoginId.Text = Email.Trim();
                    txtPassword.Focus();
                }
                else
                {
                    txtLoginId.Focus();
                }
            }      
            
        }

        protected string RandomNumer()
        {
            return (new Random().Next()).ToString();
        }

        protected void ClientMsgAndFocusControl(string MsgTxt, string focusControl)
        {
            string script1 = "";
            if (focusControl != "")
                script1 = "$('#" + focusControl + "').focus();";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank', function(r){" + script1 + "});", true);
        }

        protected void cmd_Click(object sender, EventArgs e)
        {
            Session["USERNAME"] = string.Empty;
            Session["FULLNAME"] = string.Empty;
            Session["USERID"] = string.Empty;


            if (IsPostBack)
            {
                txtLoginId.Attributes.Add("value", txtLoginId.Text);
                txtPassword.Attributes.Add("value", txtPassword.Text);
            }

            TrustCaptcha captcha = new TrustCaptcha();
            if (txtCaptcha.Text != string.Format("{0}", Session[TrustCaptcha.SESSION_CAPTCHA]))
            {
                //txtCaptcha.Focus();
                txtCaptcha.Text = "";
                CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
                return;
            }

            if (!Common.isEmailAddress(txtLoginId.Text))
            {
                txtCaptcha.Text = "";
                CommonControl1.ClientMsg("Please enter a valid email address.", txtLoginId);               
                return;
            }
            bool Done = false;
            string Msg = "";
            string FocusControl = "";
            long LoginLogID = 0;

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = System.Configuration.ConfigurationManager
                               .ConnectionStrings["WebDBConnectionString"].ConnectionString;
                string Query = "s_Login";
                using (SqlCommand cmd = new SqlCommand(Query, conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserID", System.Data.SqlDbType.VarChar).Value = txtLoginId.Text.Trim();
                    cmd.Parameters.Add("@Password", System.Data.SqlDbType.NVarChar).Value = txtPassword.Text;
                    cmd.Parameters.Add("@AppID", System.Data.SqlDbType.VarChar).Value = System.Configuration.ConfigurationSettings.AppSettings["WebAppID"].ToString();
                    cmd.Parameters.Add("@IP", System.Data.SqlDbType.VarChar).Value = CommonControl1.getIPAddress();
                    cmd.Parameters.Add("@Browser", System.Data.SqlDbType.VarChar).Value = Request.UserAgent.ToString();

                    SqlParameter SQL_Done = new SqlParameter("@Done", SqlDbType.Bit);
                    SQL_Done.Direction = ParameterDirection.InputOutput;
                    SQL_Done.Value = Done;
                    cmd.Parameters.Add(SQL_Done);

                    SqlParameter SQL_Msg_Out = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    SQL_Msg_Out.Direction = ParameterDirection.InputOutput;
                    SQL_Msg_Out.Value = Msg;
                    cmd.Parameters.Add(SQL_Msg_Out);

                    SqlParameter SQL_LoginLogID = new SqlParameter("@LoginLogID", SqlDbType.BigInt);
                    SQL_LoginLogID.Direction = ParameterDirection.InputOutput;
                    SQL_LoginLogID.Value = LoginLogID;
                    cmd.Parameters.Add(SQL_LoginLogID);

                    SqlParameter SQL_FocusControl = new SqlParameter("@FocusControl", SqlDbType.VarChar, 255);
                    SQL_FocusControl.Direction = ParameterDirection.InputOutput;
                    SQL_FocusControl.Value = FocusControl;
                    cmd.Parameters.Add(SQL_FocusControl);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    Done = (bool)SQL_Done.Value;
                    Msg = string.Format("{0}", SQL_Msg_Out.Value);
                    FocusControl = string.Format("{0}", SQL_FocusControl.Value);
                    LoginLogID = (long)SQL_LoginLogID.Value;
                }
            }

            if (Done)
            {
                Session["USERNAME"] = txtLoginId.Text.Trim();
                Session["LOGINLOGID"] = LoginLogID;

                if (Request.QueryString["Prev"] != null)
                {
                    Response.Redirect(Request.QueryString["prev"], true);
                }
                else
                {
                    Response.Redirect("Home.aspx", true);
                }
            }
            else
            {
                ClientMsgAndFocusControl(Msg, FocusControl);
            }
        }
    }
}