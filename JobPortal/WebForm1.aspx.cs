using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobPortal
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //UserControl1.getUsername();

            Response.Write(string.Format("USERNAME: {0}<br>FULLNAME: {1}<br>USERID: {2}<br>", 
                Session["USERNAME"],
                Session["FULLNAME"],
                Session["USERID"])
                );
        }
    }
}