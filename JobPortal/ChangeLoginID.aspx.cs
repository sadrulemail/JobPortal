using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace JobPortal
{
    public partial class ChangeLoginID : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "Available Jobs";
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
        
    }
}