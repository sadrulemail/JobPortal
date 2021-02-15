using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace JobPortal
{
    public partial class PasswordChange : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "Change Password";
        }
        public string getIPAddress()
        {
            string Client_IP_Address = string.Empty;
            try
            {
                Client_IP_Address = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            catch (Exception)
            {
                try
                {
                    Client_IP_Address = HttpContext.Current.Request.UserHostAddress;
                }
                catch (Exception)
                {
                    Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
                }
            }
            return Client_IP_Address;
        }
        protected void cmd_Click(object sender, EventArgs e)
        {
            bool Done = false;
            string Msg = "";
            int Focus = 0;

            txtPassword.Attributes.Add("value", txtPassword.Text);
            txtOldPassword.Attributes.Add("value", txtOldPassword.Text);
            txtConformPassword.Attributes.Add("value", txtConformPassword.Text);

            try
            {
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);
                SqlCommand oCommand = new SqlCommand("s_ChangePassword", oConn);
                oCommand.CommandType = CommandType.StoredProcedure;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();
                oCommand.Parameters.Add("@UserID", SqlDbType.VarChar).Value = Session["Username"].ToString();
                oCommand.Parameters.Add("@OldPassword", SqlDbType.NVarChar).Value = txtOldPassword.Text;
                oCommand.Parameters.Add("@NewPassword", SqlDbType.NVarChar).Value = txtPassword.Text;
                oCommand.Parameters.Add("@RetypePassword", SqlDbType.NVarChar).Value = txtConformPassword.Text;
                oCommand.Parameters.Add("@IP", SqlDbType.VarChar).Value = getIPAddress();


                SqlParameter sql_Done = new SqlParameter("@Done", SqlDbType.Bit);
                sql_Done.Value = Done;
                sql_Done.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Done);

                SqlParameter sql_Msg = new SqlParameter("@Msg", SqlDbType.VarChar);
                sql_Msg.Size = 255;
                sql_Msg.Value = Msg;
                sql_Msg.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Msg);

                SqlParameter sql_Focus = new SqlParameter("@Focus", SqlDbType.Int);
                sql_Focus.Value = Focus;
                sql_Focus.Direction = ParameterDirection.InputOutput;
                oCommand.Parameters.Add(sql_Focus);

                oCommand.ExecuteNonQuery();

                Msg = string.Format("<br />{0}<br />", sql_Msg.Value);
                Done = (bool)sql_Done.Value;
                Focus = (int)sql_Focus.Value;

                oConn.Close();
                if (Done)
                {
                    PanelPassword.Visible = false;
                    PasswordChangeSuccess.Visible = true;
                    litStatus.Text = Msg;
                }
                else
                {
                    CommonControl1.ClientMsg(Msg, null);
                }
                
            }

            catch (Exception exx)
            { CommonControl1.ClientMsg(exx.Message.ToString(), null); }
        }
    }
}