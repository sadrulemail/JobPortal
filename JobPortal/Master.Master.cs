using System;
using System.Web;
using System.Web.UI.WebControls;

public partial class Master : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string PageTitle = System.Configuration.ConfigurationSettings.AppSettings["AppTitle"].ToString();
        this.Page.Title = PageTitle;
    }

    protected void TreeView1_TreeNodeDataBound(object sender, TreeNodeEventArgs e)
    {
        string[] Roles = Session["ROLES"].ToString().Split(',');

        //System.Web.UI.WebControls.TreeView tree = (System.Web.UI.WebControls.TreeView)sender;
        SiteMapNode mapNode = (SiteMapNode)e.Node.DataItem;

        if (mapNode.Roles.Count > 0)
        {
            if (mapNode.Title == "Site Admin")
            { }
            for (int i = 0; i < mapNode.Roles.Count; i++)
                foreach (string Role in Roles)
                    if (mapNode.Roles[i].ToString() == Role
                        || mapNode.Roles[0].ToString() == "*")
                        return;
            RemoveTreeNode(e);
        }
        else
            RemoveTreeNode(e);
    }

    private static void RemoveTreeNode(TreeNodeEventArgs e)
    {
        System.Web.UI.WebControls.TreeNode parent = e.Node.Parent;
        if (parent != null)
        {
            parent.ChildNodes.Remove(e.Node);
        }
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
        // All webpages displaying an ASP.NET menu control must inherit this class.
        //if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
        //    Page.ClientTarget = "uplevel";
    }
}
