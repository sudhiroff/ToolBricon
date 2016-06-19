using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Create_Invoice : System.Web.UI.Page
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
        var client = (from x in dc.bric_customers
                   select x).ToList();
        ddlClient.DataTextField = "CustomerId";
        ddlClient.DataValueField = "CustomerId";
        ddlClient.DataSource = client;
        ddlClient.DataBind();
        ddlClient.Items.Insert(0, new ListItem("--Select Client--", "0"));        
    }

    protected void lbtnCreateInvoice_Click(object sender, EventArgs e)
    {
        bric_InvoiceMst inv = new bric_InvoiceMst();
        inv.InvoiceDate = DateFormater.ConvertToDate(DateTime.Today.ToString("dd/MM/yyyy"));       
        inv.IsCash =Convert.ToBoolean(ddlInvOption.SelectedValue);
        inv.Remark = txtRemark.Text;
        inv.SalesPerson = txtSalesPerson.Text;
        if (ddlInvOption.SelectedValue == "true")
        {
            inv.tempInvoiceNo = GetLastInvoiceId(true);
            inv.InvoiceNo = "INVCSH-" + String.Format("{0:D3}", inv.tempInvoiceNo);
        }
        else
        {
            inv.tempInvoiceNo = GetLastInvoiceId(false);
            inv.InvoiceNo = "INVCHQ-" + String.Format("{0:D3}", inv.tempInvoiceNo);
        }
        dc.bric_InvoiceMsts.InsertOnSubmit(inv);
        dc.SubmitChanges();
        
        foreach (GridViewRow dept in grid.Rows)
        {
            //Label respCount = (Label)dept.FindControl("lblResponse").Text
            int rowIndex = dept.RowIndex;
            CheckBox chk = (CheckBox)grid.Rows[rowIndex].FindControl("chkItem");
            if (chk.Checked == true)
            {
                HiddenField lbl = (HiddenField)grid.Rows[rowIndex].FindControl("hdnTradeId");
                bric_InvoiceItem objitem = new bric_InvoiceItem();
                objitem.InvoiceId = inv.Id;
                objitem.TradeId = Convert.ToInt32(lbl.Value);
                dc.bric_InvoiceItems.InsertOnSubmit(objitem);
                dc.SubmitChanges();
            }
        }
        Response.Redirect("~/Secure/InvoiceList.aspx");
    }

    private Int32 GetLastInvoiceId(bool chk)
    {
        Int32 lastId = (from x in dc.bric_InvoiceMsts
                        where x.IsCash == chk
                        orderby x.Id descending
                        select x.tempInvoiceNo).FirstOrDefault();
        return lastId + 1;
    }

    protected void lbtnSearch_Click(object sender, EventArgs e)
    {
        DateTime? dFromDate = null;
        DateTime? dToDate = null;
        if (!String.IsNullOrEmpty(txtFromDate.Text))
        {
            dFromDate = DateFormater.ConvertToDate(txtFromDate.Text);
        }
        if (!String.IsNullOrEmpty(txtToDate.Text))
        {
            dToDate = DateFormater.ConvertToDate(txtToDate.Text);
        }
        var result = (from x in dc.GET_CREATE_INVOICE_ITEM(ddlClient.SelectedValue,ddlSiteAddress.SelectedValue,dFromDate,dToDate)
                      orderby x.Id descending
                      select x).ToList();
        grid.DataSource = result;
        grid.DataBind();
        if (result.Count > 0)
        {
            var per = (from x in result
                       select new { x.TaxPercentage }).Distinct().ToList();
            ddlPercent.DataTextField = "TaxPercentage";
            ddlPercent.DataValueField = "TaxPercentage";
            ddlPercent.DataSource = per;
            ddlPercent.DataBind();
            ddlPercent.Items.Insert(0, new ListItem("--Filter by tax--", "0"));

            lbtnCreateInvoice.Visible = true;
            txtRemark.Visible = true;
            ddlInvOption.Visible = true;
            ddlPercent.Visible = true;
            txtSalesPerson.Visible = true;
        }
        else
        {
            lbtnCreateInvoice.Visible = false;
            txtRemark.Visible = false;
            ddlInvOption.Visible = false;
            ddlPercent.Visible = false;
            txtSalesPerson.Visible = false;
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }


    protected void ddlClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlClient.SelectedValue != "0")
        {
            var shp = (from x in dc.bric_CustomerSites
                       where x.CustomerNumber == ddlClient.SelectedValue
                       select x).ToList();
            ddlSiteAddress.DataTextField = "SiteAddress";
            ddlSiteAddress.DataValueField = "SiteAddress";
            ddlSiteAddress.DataSource = shp;
            ddlSiteAddress.DataBind();
            ddlSiteAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        else
        {
            ddlSiteAddress.Items.Clear();
            ddlSiteAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }
}