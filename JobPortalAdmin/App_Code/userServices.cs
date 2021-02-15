using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class userServices : System.Web.Services.WebService
{
    [WebMethod]
    public string getUserInfo(string contextKey)
    {
        string Retval = "";
        string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
        SqlConnection oConn = new SqlConnection(oConnString);
        SqlConnection.ClearAllPools();
        if (oConn.State == ConnectionState.Closed)
            oConn.Open();
        SqlCommand oCommand = new SqlCommand("usp_getEmpInfo", oConn);
        oCommand.CommandType = CommandType.StoredProcedure;
        oCommand.Parameters.Add("@param_EmpID", SqlDbType.VarChar).Value = contextKey;

        if (oConn.State == ConnectionState.Closed)
            oConn.Open();

        SqlDataReader oReader = oCommand.ExecuteReader();

        string Role = string.Empty;
        while (oReader.Read())
        {
            Retval = string.Format("<table class='ui-corner-all'>");
            Retval = string.Format("{0}<tr><td><a href='../Profile.aspx?ID={2}' title='view profile' target='_blank'><img src='EmpImage.aspx?EMPID={2}&W=120&H=120&imgid={3}' width='60'></a></td><td nowrap=nowrap>{1}</td></tr>", Retval, oReader["Emp"], contextKey, oReader["ImageIdentifier"]);
            //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["EMP"]);
            //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["DesigFullName"]);
            //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["BranchName"]);
            Retval = string.Format("{0}</tr></table></a>", Retval);
        }
        return Retval;
    }

    [WebMethod]
    public string getBranchInfo(string contextKey)
    {
        string Retval = "";
        string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
        SqlConnection oConn = new SqlConnection(oConnString);
        SqlConnection.ClearAllPools();
        if (oConn.State == ConnectionState.Closed)
            oConn.Open();
        SqlCommand oCommand = new SqlCommand("s_getBranchInfo", oConn);
        oCommand.CommandType = CommandType.StoredProcedure;
        oCommand.Parameters.Add("@BranchID", SqlDbType.VarChar).Value = contextKey;

        if (oConn.State == ConnectionState.Closed)
            oConn.Open();

        SqlDataReader oReader = oCommand.ExecuteReader();

        string Role = string.Empty;
        while (oReader.Read())
        {
            Retval = string.Format("<a href='{0}' target='_blank'><table class='ui-corner-all'>", oReader["Url"]);
            //Retval = string.Format("{0}<tr><td><a href='../Profile.aspx?ID={2}' title='view profile' target='_blank'><img src='EmpImage.aspx?EMPID={2}&W=120&H=120&imgid={3}' width='60'></a></td><td nowrap=nowrap>{1}</td></tr>", Retval, oReader["Emp"], contextKey, oReader["ImageIdentifier"]);
            Retval = string.Format("{0}<tr><td><b>{1}</b></td></tr>", Retval, oReader["BranchName"]);
            //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["DesigFullName"]);
            //Retval = string.Format("{0}<tr><td>{1}</td></tr>", Retval, oReader["BranchName"]);
            Retval = string.Format("{0}</tr></table></a>", Retval);
        }
        return Retval;
    }
}