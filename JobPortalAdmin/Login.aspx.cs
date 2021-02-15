using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using System.IO;

public partial class Login : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Directory.Exists(Server.MapPath("Upload")))
            Directory.CreateDirectory(Server.MapPath("Upload"));

        try
        {
            string ApplicationID = System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString();
            string CookieName = "Login_" + ApplicationID;
            if (Request.Cookies[CookieName] != null)
            {
                HttpCookie cookie = Request.Cookies.Get(CookieName);
                LoginTo(cookie.Values["ID"].ToString(), cookie.Values["Password"].ToString()); 
            }            
        }
        catch (Exception) { }
        //((Panel)(Page.Master.FindControl("MenuPanel"))).Visible = false;

        string focusScript = "document.getElementById('" + txtEmpID.ClientID + "').focus();";
        if (!IsPostBack)
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "clientScript", "setTimeout(\"" + focusScript + ";\",100);", true);
        else
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "clientScript", focusScript, true);
    }

    protected void cmdLogin_Click(object sender, EventArgs e)
    {        
        Session["EMPID"] = null;
        Session["DESIGID"] = null;
        Session["DEPTID"] = null;
        Session["BRANCHID"] = null;

        Session["APPID_ROLE"] = string.Empty;

        string EmpID;
        try
        {
            EmpID = txtEmpID.Text.Trim();
        }
        catch (Exception)
        {
            ClientMsg("Please enter Employee ID and Password.");
            return;
        }

        if (chkRemember.Checked)
        {
            SetCookie();
        }            

        LoginTo(EmpID, txtPassword.Text);
        
    }

    private void SetCookie()
    {
        try
        {
            string ApplicationID = System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString();
            HttpCookie cookie = new HttpCookie("Login_" + ApplicationID);
            cookie.Values.Add("ID", txtEmpID.Text);
            cookie.Values.Add("Password", EncodePassword(txtPassword.Text));
            cookie.Expires = DateTime.Now.AddMonths(1);
            Response.Cookies.Add(cookie);
        }
        catch (Exception) { }
    }

    private bool LoginTo(string EmpID, string Password)
    {
        int ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());

        bool LoginSuccess = false;
        if (Password == string.Empty)
        {
            ClientMsg("Please enter Employee ID and Password.");
            return false;
        }
        else            
        {
            try
            {
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
                SqlCommand oCommand = new SqlCommand("execute [usp_getEmp] '" + EmpID + "',NULL", oConn);

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();

                string Role = string.Empty;
                while (oReader.Read())
                {
                    string PassHex = BitConverter.ToString(((byte[])(oReader["PassHex"])));
                    if (PassHex == EncodePassword(Password) || PassHex == Password)
                    {
                        Session["EMPID"] = oReader["EMPID"].ToString();
                        LoginSuccess = true;                        
                    }                    
                }
                oConn.Close();                

            }
            catch (Exception ex)
            {
                ClientMsg(ex.Message);
            }
            if (LoginSuccess)
            {
                try
                {
                    SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
                    SqlCommand oCommandLoginLog = new SqlCommand("usp_LoginLog_Insert", oConn);
                    oCommandLoginLog.CommandType = CommandType.StoredProcedure;
                    oCommandLoginLog.Parameters.Add("@param_EmpID", SqlDbType.VarChar).Value = EmpID;
                    oCommandLoginLog.Parameters.Add("@param_AppID", SqlDbType.Int).Value = ApplicationID;
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
                    oCommandLoginLog.Parameters.Add("@param_IP", SqlDbType.Text).Value = Client_IP_Address;
                    //oCommandLoginLog.Parameters.Add("@param_ComputerName", SqlDbType.Text).Value = "";
                    //oCommandLoginLog.Parameters.Add("@param_HTTP_USER_AGENT", SqlDbType.Text).Value = "";

                    if (oConn.State == ConnectionState.Closed)
                        oConn.Open();
                    oCommandLoginLog.ExecuteNonQuery();


                    if (Request.QueryString["Prev"] != null)
                    {
                        string tail = "";
                        foreach (String key in Request.QueryString.AllKeys)
                        {
                            if (key.ToLower() != "prev")
                                tail += "&" + key + "=" + Request.QueryString[key].ToString();
                        }
                        Response.Redirect(Request.QueryString["Prev"] + tail, true);
                    }
                    else
                        Response.Redirect("Default.aspx", true);
                }
                catch (Exception ex)
                {
                    ClientMsg("Error2: " + ex.Message);
                }
            }
        }
        ClientMsg("Please enter valid Employee ID and Password.");
        return false;
    }

    public string EncodePassword(string OriginalPassword)
    {
        Byte[] originalBytes;
        Byte[] encodedBytes;
        MD5 md5;
        md5 = new MD5CryptoServiceProvider();
        originalBytes = ASCIIEncoding.Default.GetBytes(OriginalPassword);
        encodedBytes = md5.ComputeHash(originalBytes);
        return BitConverter.ToString(encodedBytes);
    }

    private void ClientMsg(string MsgTxt)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "alert('" + MsgTxt + "')", true);
    }
}