using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;

/// <summary>
/// Summary description for BbConnector
/// </summary>
namespace JobPortal
{
    public class BbConnector
    {
        //static Configuration rootWebConfig = WebConfigurationManager.OpenWebConfiguration("/TigercoInventoryApp");
        //const string CONSTRINGNAME = "satescodbConnectionString";
        //static ConnectionStringSettings satescodbConnectionString = rootWebConfig.ConnectionStrings.ConnectionStrings[CONSTRINGNAME];

        ////private static string connectionString = ConfigurationManager.AppSettings["satescodbConnectionString"];
        //    private static SqlConnection connection;
        //    //SqlConnection con = new SqlConnection(connectionString.ConnectionString);
        //    static BbConnector()
        //    {
        //        connection = new SqlConnection(satescodbConnectionString.ConnectionString);
        //    }

        //    public static SqlConnection Connection
        //    {
        //        get { return connection; }
        //    }
        //    public static string ConnectionString
        //    {
        //        get { return satescodbConnectionString.ConnectionString; }
        //    }
        private static SqlConnection connection;

        static BbConnector()
        {
            connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Request_ProcessConnectionString"].ConnectionString);
        }
        public static SqlConnection Connection
        {
            get { return connection; }
        }

        public void OpenConnection()
        {

            if (connection.State == ConnectionState.Closed)
            {
                Connection.Open();
            }

        }

        public void CloseConnection()
        {

            if (Connection.State == ConnectionState.Open)
            {
                connection.Close();
            }


        }
    }
}