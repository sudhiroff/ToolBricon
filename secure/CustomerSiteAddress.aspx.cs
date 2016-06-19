using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_CustomerSiteAddress : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadMAsterData();
            lbtnAdd.Visible = false;
        }
    }
    private void LoadMAsterData()
    {
        var client = (from x in dc.bric_customers
                      select x).ToList();
        ddlClient.DataTextField = "CustomerId";
        ddlClient.DataValueField = "Id";
        ddlClient.DataSource = client;
        ddlClient.DataBind();
        ddlClient.Items.Insert(0, new ListItem("--Select Client--", "0"));
    }
    private void LoadData()
    {
        if (ddlClient.SelectedValue != "0")
        {
            var result = (from x in dc.bric_CustomerSites
                          join c in dc.bric_customers on x.CustomerId equals c.Id
                          where x.CustomerNumber == ddlClient.SelectedItem.Text
                          select new {
                              x.ContactPerson,
                              x.CustomerId,
                              x.CustomerNumber,
                              x.EmailId,
                              x.Id,
                              x.MobileNo,
                              x.SiteAddress,
                              c.CustomerName
                          }).ToList();
            grid.DataSource = result;
            grid.DataBind();
            lbtnAdd.Visible = true;
        }
        else
        {
            grid.DataSource = null;
            grid.DataBind();
            lbtnAdd.Visible = false;
        }
    }

    protected void lbtnAddSiteAddress_Click(object sender, EventArgs e)
    {
        if (lbtnAddSiteAddress.Text == "Update")
        {
            var result = (from x in dc.bric_CustomerSites
                          where x.Id == Convert.ToInt32(hdnSiteAddressId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].SiteAddress = txtCSiteAddress.Text;
                result[0].EmailId = txtEmail.Text;
                result[0].ContactPerson = txtContactPerson.Text;
                result[0].MobileNo = txtMobile.Text;
                dc.SubmitChanges();
                hdnSiteAddressId.Value = "0";
                lbtnAddSiteAddress.Text = "Submit";
            }
        }
        else
        {
            bric_CustomerSite obj = new bric_CustomerSite();
            obj.SiteAddress = txtCSiteAddress.Text;
            obj.EmailId = txtEmail.Text;
            obj.ContactPerson = txtContactPerson.Text;
            obj.MobileNo = txtMobile.Text;
            obj.CustomerId = Convert.ToInt32(ddlClient.SelectedValue);
            obj.CustomerNumber = ddlClient.SelectedItem.Text;
            dc.bric_CustomerSites.InsertOnSubmit(obj);
            dc.SubmitChanges();            
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtCSiteAddress.Text = "";
        txtContactPerson.Text = "";
        txtEmail.Text = "";
        txtMobile.Text = "";
        LoadData();
    }

    protected void lbtnSearch_Click(object sender, EventArgs e)
    {
         LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_CustomerSites
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_CustomerSites.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_CustomerSites
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtCSiteAddress.Text = result[0].SiteAddress;
                txtContactPerson.Text = result[0].ContactPerson;
                txtEmail.Text = result[0].EmailId;
                txtMobile.Text = result[0].MobileNo;
                hdnSiteAddressId.Value = result[0].Id.ToString();
                lbtnAddSiteAddress.Text = "Update";
            }
        }
    }
    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    protected void grid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        e.NewEditIndex = -1;
    }
}