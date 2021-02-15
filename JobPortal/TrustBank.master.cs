using System;

namespace JobPortal
{
    public partial class TrustBankMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblVersion.Text = string.Format("Ver: {0}", System.Configuration.ConfigurationSettings.AppSettings["Version"]);
        }
    }
}