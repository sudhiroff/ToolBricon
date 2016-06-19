using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_PaymentMode : System.Web.UI.Page
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
        var result = (from x in dc.bric_PaymentTypes
                      select x).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_PaymentTypes
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].PaymentType = txtyear.Text;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_PaymentType obj = new bric_PaymentType();
            obj.PaymentType = txtyear.Text;
            dc.bric_PaymentTypes.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtyear.Text = "";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_PaymentTypes
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_PaymentTypes.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_PaymentTypes
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtyear.Text = result[0].PaymentType;
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