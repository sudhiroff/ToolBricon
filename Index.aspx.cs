using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Index : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        var result = (from obj in dc.bric_users
                      where obj.UserName == txtuserName.Text.Trim() && obj.passeword == txtPassword.Text.Trim()
                      select obj).FirstOrDefault();
        if (result != null)
        {
            Session[Constant.UserName] = result.UserName;
            Response.Redirect("~/secure/Dashboard.aspx");            
        }                
    }
}