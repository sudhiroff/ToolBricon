using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_TransactionRef : System.Web.UI.Page
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
        var result = (from x in dc.bric_TransactionReferences
                      join c in dc.bric_TransactionCategories on x.TransactionId equals c.Id
                      select new {
                          x.TransactionRef,
                          c.TransactionCategory,
                          x.Id
                      }).ToList();
        grid.DataSource = result;
        grid.DataBind();

        var cate= (from x in dc.bric_TransactionCategories
                   select x).ToList();
        if (cate.Count > 0)
        {
            ddlCat.DataTextField = "TransactionCategory";
            ddlCat.DataValueField = "Id";
            ddlCat.DataSource = cate;
            ddlCat.DataBind();
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_TransactionReferences
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].TransactionId = Convert.ToInt32(ddlCat.SelectedValue);
                result[0].TransactionRef = txtRef.Text;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_TransactionReference obj = new bric_TransactionReference();
            obj.TransactionId = Convert.ToInt32(ddlCat.SelectedValue);
            obj.TransactionRef = txtRef.Text;
            dc.bric_TransactionReferences.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');;$('body').removeClass('modal-open');</script>", false);
        txtRef.Text = "";
       // ddlCat.SelectedValue = "0";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_TransactionReferences
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_TransactionReferences.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_TransactionReferences
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtRef.Text = result[0].TransactionRef;
                ddlCat.SelectedValue = result[0].TransactionId.ToString();
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