using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Supplier : System.Web.UI.Page
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
        var result = (from x in dc.bric_suppliers
                      select x).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_suppliers
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].SupplierName = txtName.Text;
                result[0].ContactPerson = txtConatctPerson.Text;
                result[0].SupplierEmail = txtEmail.Text;
                result[0].SupplierAddress = txtAddress.Text;
                result[0].MobileNo = txtMobileNo.Text;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_supplier obj = new bric_supplier();
            obj.SupplierName = txtName.Text;
            obj.ContactPerson = txtConatctPerson.Text;
            obj.SupplierEmail = txtEmail.Text;
            obj.SupplierAddress = txtAddress.Text;
            obj.MobileNo = txtMobileNo.Text;
            obj.Status = true;
            dc.bric_suppliers.InsertOnSubmit(obj);
            dc.SubmitChanges();
            obj.SupplierId = "BCSUP/" + obj.SupplierName.Substring(0,3).ToUpper() + "/" + String.Format("{0:D3}", obj.Id);
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtName.Text = "";
        txtEmail.Text = "";
        txtAddress.Text = "";
        txtMobileNo.Text = "";
        txtConatctPerson.Text = "";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_suppliers
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_suppliers.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_suppliers
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtName.Text = result[0].SupplierName;
                txtConatctPerson.Text = result[0].ContactPerson;
                txtEmail.Text = result[0].SupplierEmail;
                txtAddress.Text = result[0].SupplierAddress;
                txtMobileNo.Text = result[0].MobileNo;
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