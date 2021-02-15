using System;
using System.Data.SqlClient;

public partial class TrustBank : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection.ClearAllPools();
    }
}