using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Customer : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadData();
        }
    }

    private void LoadData()
    {
        var result = (from x in dc.bric_customers
                      select x).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_customers
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].CustomerName = txtName.Text;
                result[0].ContactPerson = txtContactPerson.Text;
                result[0].CustomerEmail = txtEmail.Text;
                result[0].customerAddress = txtAddress.Text;
                result[0].MobileNo = txtMobileNo.Text;
                result[0].TINNo = txtTin.Text;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_customer obj = new bric_customer();
            obj.CustomerName = txtName.Text;
            obj.ContactPerson = txtContactPerson.Text;
            obj.CustomerEmail = txtEmail.Text;
            obj.customerAddress = txtAddress.Text;
            obj.MobileNo = txtMobileNo.Text;
            obj.Status = true;
            obj.TINNo = txtTin.Text;
            dc.bric_customers.InsertOnSubmit(obj);
            dc.SubmitChanges();
            obj.CustomerId = "BCCUS/" + obj.CustomerName.Substring(0, 3).ToUpper() + "/" + String.Format("{0:D3}", obj.Id);
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtName.Text = "";
        txtEmail.Text = "";
        txtAddress.Text = "";
        txtMobileNo.Text = "";
        txtContactPerson.Text = "";
        txtTin.Text = "";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_customers
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_customers.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_customers
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtName.Text = result[0].CustomerName;
                txtContactPerson.Text = result[0].ContactPerson;
                txtEmail.Text = result[0].CustomerEmail;
                txtAddress.Text = result[0].customerAddress;
                txtMobileNo.Text = result[0].MobileNo;
                txtTin.Text = result[0].TINNo;
                btnSubmit.Text = "Update";
                hdnId.Value = result[0].Id.ToString();
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