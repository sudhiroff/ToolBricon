using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Cashbook : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadData();
            BindDropdown();
        }
        if (this.Request["__EVENTARGUMENT"] == "LoadRef")
        {
            ddlCategory_SelectedIndexChanged(null, null);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();openModal();</script>", false);
        }
    }

    private void BindDropdown()
    {
        var Category = (from x in dc.bric_TransactionCategories
                        select x).ToList();
        ddlCategory.DataTextField = "TransactionCategory";
        ddlCategory.DataValueField = "Id";
        ddlCategory.DataSource = Category;
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("--Select Category--", "0"));
    }

    private void LoadData()
    {
        var result = (from x in dc.bric_DailyCashbooks
                      join c in dc.bric_TransactionCategories on x.TransactionCat equals c.Id
                      join r in dc.bric_TransactionReferences on x.TransactionRef equals r.Id
                      select new {
                          x.Id,
                          x.Narration,
                          x.Amount,
                          x.StartDate,
                          c.TransactionCategory,
                          r.TransactionRef,
                          x.TransactionType
                      }).ToList();
        grid.DataSource = result;
        grid.DataBind();        
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_DailyCashbooks
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].Narration = txtNarration.Text;
                result[0].TransactionCat =Convert.ToInt32(ddlCategory.SelectedValue);
                result[0].TransactionRef = Convert.ToInt32(ddlRef.SelectedValue);
                result[0].StartDate = DateFormater.ConvertToDate(txtDate.Text);
                result[0].TransactionType = ddlTransactionType.SelectedValue;
                result[0].Amount =Convert.ToDecimal(txtAmount.Text);
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_DailyCashbook obj = new bric_DailyCashbook();
            obj.Narration = txtNarration.Text;
            obj.TransactionCat = Convert.ToInt32(ddlCategory.SelectedValue);
            obj.TransactionRef = Convert.ToInt32(ddlRef.SelectedValue);
            obj.StartDate = DateFormater.ConvertToDate(txtDate.Text);
            obj.TransactionType = ddlTransactionType.SelectedValue;
            obj.Amount = Convert.ToDecimal(txtAmount.Text);
            dc.bric_DailyCashbooks.InsertOnSubmit(obj);
            dc.SubmitChanges();            
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtNarration.Text = "";
        txtDate.Text = "";
        txtAmount.Text = "";
        ddlCategory.SelectedValue = "0";
        ddlRef.SelectedValue = "0";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_DailyCashbooks
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_DailyCashbooks.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_DailyCashbooks
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();$('#myModal').modal('show');</script>", false);
                txtNarration.Text = result[0].Narration;
                ddlCategory.SelectedValue =Convert.ToString(result[0].TransactionCat);
                ddlCategory_SelectedIndexChanged(null, null);
                ddlRef.SelectedValue = Convert.ToString(result[0].TransactionRef);
                txtDate.Text = DateFormater.GetDate(result[0].StartDate);
                ddlTransactionType.SelectedValue = result[0].TransactionType;
                txtAmount.Text = result[0].Amount.ToString();
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

    protected void ddlRef_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedValue != "0")
        {
            var reference = (from x in dc.bric_TransactionReferences
                             where x.TransactionId == Convert.ToInt32(ddlCategory.SelectedValue)
                             select x).ToList();
            ddlRef.DataTextField = "TransactionRef";
            ddlRef.DataValueField = "Id";
            ddlRef.DataSource = reference;
            ddlRef.DataBind();
            ddlRef.Items.Insert(0, new ListItem("--Select Reference--", "0"));
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<bric_TransactionReference> GetReference(string strCat)
    {
        using (var dc = new DataClassesDataContext())
        {
            var reference = (from x in dc.bric_TransactionReferences
                             where x.TransactionId == Convert.ToInt32(strCat)
                             select x).ToList();
            return reference.ToList();
        }
    }
}