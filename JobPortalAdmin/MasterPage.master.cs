using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EMPID"] != null)
        {
            lblLoginUser.Text = Session["EMPID"].ToString();
            PanelAfterLogin.Visible = true;
            PanelImage.Visible = true;            
        }
        else
        {
            lblLoginUser.Text = string.Empty;
            PanelAfterLogin.Visible = false;
            PanelMenu.Visible = false;
            LoadAppInfo();            
        }        
    }

    private void LoadAppInfo()
    {
        try
        {
            string AppName = "";
            string ApplicationPath = "";
            string Logo = "";

            int ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());
            string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString;
            System.Data.SqlClient.SqlConnection oConn = new System.Data.SqlClient.SqlConnection(oConnString);
            System.Data.SqlClient.SqlCommand oComm = new System.Data.SqlClient.SqlCommand(string.Format("SELECT * FROM [Applications] WHERE ID = {0}", ApplicationID), oConn);

            if (oConn.State == System.Data.ConnectionState.Closed)
                oConn.Open();
            IDataReader DR = oComm.ExecuteReader();
            while (DR.Read())
            {
                AppName = DR["ApplicationName"].ToString();
                ApplicationPath = DR["ApplicationPath"].ToString();
                Logo = DR["Logo"].ToString();
            }

            ((HyperLink)this.Page.Master.FindControl("ApplicationName")).Text = AppName;
            ((HyperLink)this.Page.Master.FindControl("ApplicationName")).NavigateUrl = ApplicationPath;
            ((HyperLink)this.Page.Master.FindControl("ApplicationLogo")).NavigateUrl = ApplicationPath;
            ((HyperLink)this.Page.Master.FindControl("ApplicationLogo")).ImageUrl = Logo;
            ((HyperLink)this.Page.Master.FindControl("ApplicationLogoBig")).ImageUrl = Logo;
            ((HyperLink)ContentPlaceHolder2.FindControl("ApplicationLogoBig")).ImageUrl = Logo;
            //lblTitle.Text = string.Format("Login to {0}", AppName);
            //this.Title = string.Format("Login :: {0}", AppName);
        }
        catch (Exception) { }
    }

    protected void MainMenu_MenuItemClick(object sender, MenuEventArgs e)
    {
        //if (MainMenu.SelectedValue == "Add New Customer")
        //{
        //    Session.Remove("TODO");
        //    Response.Redirect("~/CustomerAdd.aspx", true);
        //}
    }

    protected void lblRole_Load(object sender, EventArgs e)
    {
        //if (lblRole.Text != "ADMIN")
        //    MainMenu.FindItem("Admin").Enabled = false;
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
        // All webpages displaying an ASP.NET menu control must inherit this class.
        if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
            Page.ClientTarget = "uplevel";
    }

    protected override void AddedControl(Control control, int index)
    {
        // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
        // Add this to the code in your master page.
        if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
            this.Page.ClientTarget = "uplevel";
        base.AddedControl(control, index);
    }

    protected void MainMenu_DataBound(object sender, EventArgs e)
    {
        
    }

    //private void RemoveTreeNode(MenuEventArgs e)
    //{
    //    System.Web.UI.WebControls.MenuItem parent = e.Item.Parent;
    //    //if (parent != null)
    //    {            
    //        //parent.ChildItems.Remove(e.Item);
    //        e.Item.Enabled = false;
    //    }
    //}

    protected void MainMenu_MenuItemDataBound(object sender, MenuEventArgs e)
    {
        string[] Roles = Session["ROLES"].ToString().Split(',');
        SiteMapNode node = e.Item.DataItem as SiteMapNode;

        if (e.Item.Text == "")
        {
            RemoveMenuNode(e);
            return;
        }

        if (!string.IsNullOrEmpty(node["target"]))
            e.Item.Target = node["target"];

        //Check Branch
        if (!string.IsNullOrEmpty(node["branch"]))
        {
            string[] branches = node["branch"].ToString().Split(',');
            for (int i = 0; i < branches.Length; i++)
                if (branches[i] == Session["BRANCHID"].ToString()
                    || branches[i] == "*") return;
            RemoveMenuNode(e);
            return;
        }

        //Check Role
        for (int i = 0; i < node.Roles.Count; i++)
            foreach (string Role in Roles)
                if (node.Roles[i].ToString() == Role
                    || node.Roles[i].ToString() == "*"
                    )
                    return;
        RemoveMenuNode(e);     
    }

    private void RemoveTreeNode(TreeNodeEventArgs e)
    {
        System.Web.UI.WebControls.TreeNode parent = e.Node.Parent;
        if (parent != null)
        {
            parent.ChildNodes.Remove(e.Node);
        }
        else
        {
            TreeView1.Nodes.Remove(e.Node);
        }
    }

    private void RemoveMenuNode(MenuEventArgs e)
    {
        try
        {
            if (e.Item.Parent == null)
            {
                
                //MainMenu.Items.Remove(e.Item);
            }
            else
                e.Item.Parent.ChildItems.Remove(e.Item);
        }
        catch (Exception) { }
    }

    protected void TreeView1_TreeNodeDataBound1(object sender, TreeNodeEventArgs e)
    {
        string[] Roles = Session["ROLES"].ToString().Split(',');

        //System.Web.UI.WebControls.TreeView tree = (System.Web.UI.WebControls.TreeView)sender;
        SiteMapNode mapNode = (SiteMapNode)e.Node.DataItem;

        if (e.Node.Text == "")
        {
            RemoveTreeNode(e);
            return;
        }

        //Check Branch
        if (!string.IsNullOrEmpty(mapNode["branch"]))
        {
            string[] branches = mapNode["branch"].ToString().Split(',');
            for (int i = 0; i < branches.Length; i++)
                if (branches[i] == Session["BRANCHID"].ToString()
                    || branches[i] == "*") return;
            RemoveTreeNode(e);
            return;
        }

        if (!string.IsNullOrEmpty(mapNode["target"]))
            e.Node.Target = mapNode["target"];

        if (mapNode.Roles.Count > 0)
        {
            for (int i = 0; i < mapNode.Roles.Count; i++)
                foreach (string Role in Roles)
                    if (mapNode.Roles[i].ToString() == Role
                        || mapNode.Roles[i].ToString() == "*")
                    {
                        //e.Node.Text = "";
                        return;
                    }
            RemoveTreeNode(e);
        }
        else
            RemoveTreeNode(e);   
    }
    protected void TreeView1_TreeNodePopulate(object sender, TreeNodeEventArgs e)
    {
        
    }
}