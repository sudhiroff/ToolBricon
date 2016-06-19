using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class secure_CreateOrder : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadMasterData();
            if(Request.QueryString["ref"]!=null)
                LoadData(Convert.ToInt32(Request.QueryString["ref"]));
        }
    }

    private void LoadMasterData()
    {
        var result = (from x in dc.bric_items
                      select x).ToList();
        ddlItemCode.DataTextField = "ItemCode";
        ddlItemCode.DataValueField = "ItemCode";
        ddlItemCode.DataSource = result;
        ddlItemCode.DataBind();
        ddlItemCode.Items.Insert(0, new ListItem("--Select--", "0"));

        var client = (from x in dc.bric_customers
                      select x).ToList();
        ddlClient.DataTextField = "CustomerId";
        ddlClient.DataValueField = "CustomerId";
        ddlClient.DataSource = client;
        ddlClient.DataBind();
        ddlClient.Items.Insert(0, new ListItem("--Select--", "0"));

        var suplier = (from x in dc.bric_suppliers
                       select x).ToList();
        ddlSuplierNo.DataTextField = "SupplierId";
        ddlSuplierNo.DataValueField = "SupplierId";
        ddlSuplierNo.DataSource = suplier;
        ddlSuplierNo.DataBind();
        ddlSuplierNo.Items.Insert(0, new ListItem("--Select--", "0"));
    }

    private void LoadData(Int32 id)
    {
        var result = (from x in dc.bric_PurchaseOrders
                      where x.Id==id
                      select new
                      {
                          x.Id,
                          x.OrderDescription,
                          x.OrderId,
                          x.PODate,
                          x.ShippingAddress,
                          x.StartDate,
                          x.EndDate,
                          x.CustomerId
                      }).ToList();
        if (result.Count > 0)
        {
            txtPODate.Text = DateFormater.GetDate(result[0].PODate);
            txtStartDate.Text = DateFormater.GetDate(result[0].StartDate);
            txtEndDate.Text = DateFormater.GetDate(result[0].EndDate);
            txtOrderDes.Text = result[0].OrderDescription;
            ddlClient.SelectedValue = result[0].CustomerId;
            ddlClient_SelectedIndexChanged(null, null);
            ddlShippngAddress.SelectedValue = result[0].ShippingAddress;
            
            btnSubmit.Text = "Update";

            // load item
            List<PO_ITEM> res = (from x in dc.bric_PO_Items
                                 where x.POId == result[0].Id
                                 select new PO_ITEM
                                 {
                                     ItemCode=x.ItemCode,
                                     ItemDes=x.ItemDes,
                                     Tax=x.ItemTax,
                                     Quantity=x.Quantity,
                                     BuyRate=x.BuyRate,
                                     SellRate=x.SellRate,
                                     SuplierId=x.SuplierId,
                                     RateFrom=x.RateFrom,
                                     RateTo=x.RateTo
                                 }).ToList();
            if (res.Count > 0)
            {
                ViewState["ITEM"] = res;
                LoadItem();
            }

        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (ViewState["ITEM"] != null)
        {
            if (btnSubmit.Text == "Update")
            {
                var result = (from x in dc.bric_PurchaseOrders
                              where x.Id == Convert.ToInt32(Request.QueryString["ref"])
                              select x).ToList();
                if (result.Count > 0)
                {
                    result[0].PODate = DateFormater.ConvertToDate(txtPODate.Text);
                    result[0].StartDate = DateFormater.ConvertToDate(txtStartDate.Text);
                    result[0].EndDate = DateFormater.ConvertToDate(txtEndDate.Text);
                    result[0].OrderDescription = txtOrderDes.Text;
                    result[0].ShippingAddress = ddlShippngAddress.SelectedValue;
                    result[0].CustomerId = ddlClient.SelectedValue;
                    dc.SubmitChanges();
                    AddItemInDatabase(result[0].Id);
                }
            }
            else
            {
                bric_PurchaseOrder obj = new bric_PurchaseOrder();
                obj.OrderId = "BC";
                obj.PODate = DateFormater.ConvertToDate(txtPODate.Text);
                obj.StartDate = DateFormater.ConvertToDate(txtStartDate.Text);
                obj.EndDate = DateFormater.ConvertToDate(txtEndDate.Text);
                obj.OrderDescription = txtOrderDes.Text;
                obj.ShippingAddress = ddlShippngAddress.SelectedValue;
                obj.CustomerId = ddlClient.SelectedValue;
                dc.bric_PurchaseOrders.InsertOnSubmit(obj);
                dc.SubmitChanges();
                obj.OrderId = "BC" + String.Format("{0:MMM}", DateTime.Today).ToUpper() + String.Format("{0:yy}", DateTime.Today) + String.Format("{0:D4}", obj.Id);
                dc.SubmitChanges();
                AddItemInDatabase(obj.Id);
            }
            Response.Redirect("~/secure/PurchaseOrder.aspx");
        }
    }

    private void AddItemInDatabase(int id)
    {
        //  delete all item

        var res = (from x in dc.bric_PO_Items
                   where x.POId == id
                   select x).ToList();
        if (res.Count > 0)
        {
            dc.bric_PO_Items.DeleteAllOnSubmit(res);
            dc.SubmitChanges();
        }

        //  delete new item
        List<PO_ITEM> lstItem = new List<PO_ITEM>();
        if (ViewState["ITEM"] != null)
        {
            lstItem = (List<PO_ITEM>)ViewState["ITEM"];
        }
        for (int i = 0; i < lstItem.Count; i++)
        {
            bric_PO_Item obj = new bric_PO_Item();
            obj.POId= id;
            obj.ItemCode = lstItem[i].ItemCode;
            obj.ItemDes = lstItem[i].ItemDes;
            obj.ItemTax= lstItem[i].Tax;
            obj.Quantity = lstItem[i].Quantity;
            obj.SellRate = lstItem[i].SellRate;
            obj.BuyRate = lstItem[i].BuyRate;
            obj.SuplierId = lstItem[i].SuplierId;
            obj.RateFrom = lstItem[i].RateFrom;
            obj.RateTo = lstItem[i].RateTo;
            dc.bric_PO_Items.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }        
    }

    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            List<PO_ITEM> lstItem = new List<PO_ITEM>();
            if (ViewState["ITEM"] != null)
            {
                lstItem = (List<PO_ITEM>)ViewState["ITEM"];
            }
            lstItem.RemoveAt(Convert.ToInt32(e.CommandArgument));
            ViewState["ITEM"] = lstItem;
            LoadItem();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
        }
        if (e.CommandName == "edit")
        {
            List<PO_ITEM> lstItem = new List<PO_ITEM>();
            if (ViewState["ITEM"] != null)
            {
                lstItem = (List<PO_ITEM>)ViewState["ITEM"];
            }
            int index = Convert.ToInt32(e.CommandArgument);
            ddlItemCode.SelectedValue = lstItem[index].ItemCode;
            txtItem.Text= lstItem[index].ItemDes;
            txtItemTax.Text=Convert.ToString(lstItem[index].Tax);
            txtQuantity.Text= Convert.ToString(lstItem[index].Quantity);
            txtSellRate.Text = Convert.ToString(lstItem[index].SellRate);
            txtBuyRate.Text = Convert.ToString(lstItem[index].BuyRate);
            ddlSuplierNo.SelectedValue = lstItem[index].SuplierId;
            txtRateFrom.Text= DateFormater.GetDate(lstItem[index].RateFrom);
            txtRateTo.Text = DateFormater.GetDate(lstItem[index].RateTo);

            txtItem.Attributes.Add("readonly", "readonly");
            txtItemTax.Attributes.Add("readonly", "readonly");
            btnAddItem.Text = "Update";
            btnAddCancel.Visible = true;
            hdnItemIndex.Value = index.ToString();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
        }
    }
    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    protected void grid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        e.NewEditIndex = -1;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetItemName(string Id)
    {
        if (Id == "0")
        {
            return "";
        }
        else
        {
            using (var dc = new DataClassesDataContext())
            {
                var result = (from x in dc.bric_items
                              where x.ItemCode == Id
                              select new
                              {
                                  ItemName = x.ItemName + ";" + x.TaxPercent
                              }).ToList();
                return result[0].ItemName;
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<bric_PO_Item> GetPOItem(string Id)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PO_Items
                          where x.POId == Convert.ToInt32(Id)
                          select x).ToList();
            return result.ToList();
        }
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        List<PO_ITEM> lstItem = new List<PO_ITEM>();
        if (ViewState["ITEM"] != null)
        {
            lstItem = (List<PO_ITEM>)ViewState["ITEM"];
        }
        if (btnAddItem.Text == "Update"&& hdnItemIndex.Value!="-1")
        {
            int index = Convert.ToInt32(hdnItemIndex.Value);
            lstItem[index].ItemCode = ddlItemCode.SelectedValue;
            lstItem[index].ItemDes = txtItem.Text;
            lstItem[index].Tax = Convert.ToDecimal(txtItemTax.Text);
            lstItem[index].Quantity = Convert.ToInt32(txtQuantity.Text);
            lstItem[index].SellRate = Convert.ToDecimal(txtSellRate.Text);
            lstItem[index].BuyRate = Convert.ToDecimal(txtBuyRate.Text);
            lstItem[index].SuplierId = ddlSuplierNo.SelectedValue;
            lstItem[index].RateFrom = DateFormater.ConvertToDate(txtRateFrom.Text);
            lstItem[index].RateTo = DateFormater.ConvertToDate(txtRateTo.Text);

            btnAddItem.Text = "Add";
            btnAddCancel.Visible = false;
            hdnItemIndex.Value = "-1";
        }
        else
        {            
            PO_ITEM obj = new PO_ITEM();
            obj.ItemCode = ddlItemCode.SelectedValue;
            obj.ItemDes = txtItem.Text;
            obj.Tax = Convert.ToDecimal(txtItemTax.Text);
            obj.Quantity = Convert.ToInt32(txtQuantity.Text);
            obj.SellRate = Convert.ToDecimal(txtSellRate.Text);
            obj.BuyRate = Convert.ToDecimal(txtBuyRate.Text);
            obj.SuplierId = ddlSuplierNo.SelectedValue;
            obj.RateFrom = DateFormater.ConvertToDate(txtRateFrom.Text);
            obj.RateTo = DateFormater.ConvertToDate(txtRateTo.Text);
            lstItem.Add(obj);            
        }
        ViewState["ITEM"] = lstItem;
        LoadItem();
        ddlItemCode.SelectedValue = "0";
        txtItem.Text = "";
        txtQuantity.Text = "";
        txtSellRate.Text = "";
        txtBuyRate.Text = "";
        txtItemTax.Text = "";
        ddlSuplierNo.SelectedValue = "0";
        txtRateTo.Text = "";
        txtRateFrom.Text = "";
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }

    private void LoadItem()
    {
        List<PO_ITEM> lstItem = new List<PO_ITEM>();
        lstItem = (List<PO_ITEM>)ViewState["ITEM"];
        grid.DataSource = lstItem;
        grid.DataBind();
    }

    [Serializable]
    class PO_ITEM
    {
        public string ItemCode { get; set; }

        public string ItemDes { get; set; }

        public int Quantity { get; set; }

        public System.Nullable<decimal> Tax { get; set; }

        public decimal BuyRate { get; set; }

        public decimal SellRate { get; set; }

        public string SuplierId { get; set; }

        public DateTime RateFrom { get; set; }

        public DateTime RateTo { get; set; }

    }

    protected void ddlClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlClient.SelectedValue != "0")
        {
            var shp = (from x in dc.bric_CustomerSites
                          where x.CustomerNumber==ddlClient.SelectedValue
                          select x).ToList();
            ddlShippngAddress.DataTextField = "SiteAddress";
            ddlShippngAddress.DataValueField = "SiteAddress";
            ddlShippngAddress.DataSource = shp;
            ddlShippngAddress.DataBind();
            ddlShippngAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        else
        {
            ddlShippngAddress.Items.Clear();
            ddlShippngAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }

    protected void btnAddCancel_Click(object sender, EventArgs e)
    {
        
    }
}