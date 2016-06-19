using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class secure_AddTrade : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindMaster();
            if(Request.QueryString["ref"]!=null)
             LoadMasterData();            
        }
        if (this.Request["__EVENTARGUMENT"] == "LoadItemByPO")
        {
            LoadItemByPO(Convert.ToInt32(hdnPoId.Value));
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>PageLoad();</script>", false);
        }
    }

    private void BindMaster()
    {
        //var sup = (from x in dc.bric_suppliers
        //           select x).ToList();
        //ddlSuplier.DataTextField = "SupplierId";
        //ddlSuplier.DataValueField = "SupplierId";
        //ddlSuplier.DataSource = sup;
        //ddlSuplier.DataBind();
        ddlSuplier.Items.Insert(0, new ListItem("--Select--", "0"));

        txtQuantity.Attributes.Add("readonly", "readonly");
    }

    private void LoadItemByPO(int PId)
    {
        DateTime dtShipDate = DateFormater.ConvertToDate(txtShipdate.Text);
        var sup = (from x in dc.bric_PO_Items
                   where x.POId== PId && dtShipDate >= x.RateFrom && dtShipDate <= x.RateTo
                   select new {
                       x.SuplierId
                   }).Distinct().ToList();
        ddlSuplier.DataTextField = "SuplierId";
        ddlSuplier.DataValueField = "SuplierId";
        ddlSuplier.DataSource = sup;
        ddlSuplier.DataBind();
        ddlSuplier.Items.Insert(0, new ListItem("--Select--", "0"));       
    }

    private void LoadItemByPO(string PId)
    {
        var res = (from obj in dc.bric_PO_Items
                   join x in dc.bric_PurchaseOrders on obj.POId equals x.Id
                   where x.OrderId == PId
                   select obj).ToList();
        if (res.Count > 0)
        {
            ddlItemCode.DataTextField = "ItemCode";
            ddlItemCode.DataValueField = "ItemCode";
            ddlItemCode.DataSource = res;
            ddlItemCode.DataBind();
            txtItemDescription.Text = res[0].ItemDes;
            txtBuyRate.Text = res[0].BuyRate.ToString();
            txtUnitPrice.Text = res[0].SellRate.ToString();
        }
    }

    protected void ddlSuplier_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSuplier.SelectedValue != "0")
        {
            DateTime dtShipDate = DateFormater.ConvertToDate(txtShipdate.Text);

            var res = (from obj in dc.bric_PO_Items
                       join i in dc.bric_items on obj.ItemCode equals i.ItemCode
                       where obj.POId == Convert.ToInt32(hdnPoId.Value) && obj.SuplierId == ddlSuplier.SelectedValue
                       && dtShipDate >= obj.RateFrom   && dtShipDate <= obj.RateTo
                       select new
                       {
                           obj.Id,
                           obj.ItemCode,
                           obj.ItemDes,
                           obj.ItemTax,
                           obj.Quantity,
                           obj.SellRate,
                           obj.BuyRate,
                           i.IsCalculateByDimenson
                       }).ToList();
            if (res.Count > 0)
            {
                ddlItemCode.DataTextField = "ItemCode";
                ddlItemCode.DataValueField = "ItemCode";
                ddlItemCode.DataSource = res;
                ddlItemCode.DataBind();
                txtItemDescription.Text = res[0].ItemDes;
                txtBuyRate.Text = res[0].BuyRate.ToString();
                txtUnitPrice.Text = res[0].SellRate.ToString();
                txtTax.Text = res[0].ItemTax == null ? "0" : Convert.ToString(res[0].ItemTax);

                txtTax.Attributes.Add("readonly", "readonly");
                txtItemDescription.Attributes.Add("readonly", "readonly");

                if (res[0].IsCalculateByDimenson == false)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>IsCalculateDim(false);</script>", false);
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>IsCalculateDim(true);</script>", false);
                }
            }
        }
        else
        {

        }
    }

    /// <summary>
    ///  Load edit form datta
    /// </summary>
    private void LoadMasterData()
    {
        var result = (from x in dc.bric_Trade_Masters                      
                      where x.Id == Convert.ToInt32(Request.QueryString["ref"])
                      select x).ToList();
        if (result.Count > 0)
        {
            LoadItemByPO(result[0].POrderId);
            hdnPoId.Value = (from x in dc.bric_PurchaseOrders where x.OrderId == result[0].POrderId select x.Id).FirstOrDefault().ToString();

            txtPOrderId.Text = result[0].POrderId;
            ddlItemCode.SelectedValue = result[0].ItemCode;
            txtItemDescription.Text = result[0].ItemDescription;
            txtItemDescription.Attributes.Add("readonly", "readonly");

            txtVehicleNo.Text = result[0].VehicleNo;
            if (chkIsAutoCalDim() == true)
            {
                txtVlengthFit.Text = result[0].V_length_ft.ToString();
                txtVlengthInc.Text = result[0].V_length_Inc.ToString();
                txtVwdthFit.Text = result[0].V_wdth_ft.ToString();
                txtVwidthInc.Text = result[0].V_wdth_Inc.ToString();
                txtVheightFit.Text = result[0].V_height_ft.ToString();
                txtVheightInc.Text = result[0].V_height_Inc.ToString();
                txtQuantity.Attributes.Add("readonly", "readonly"); 
                              
             }
            else
            {
                txtVlengthFit.Attributes.Add("readonly", "readonly");
                txtVlengthInc.Attributes.Add("readonly", "readonly");
                txtVwdthFit.Attributes.Add("readonly", "readonly");
                txtVwidthInc.Attributes.Add("readonly", "readonly");
                txtVheightFit.Attributes.Add("readonly", "readonly");
                txtVheightInc.Attributes.Add("readonly", "readonly");
                txtQuantity.Attributes.Remove("readonly");
            }
            txtQuantity.Text = result[0].Quantity.ToString();
            txtChallanNo.Text = result[0].ChallanNo;
            ddlSuplier.SelectedValue = result[0].SuplierId;
            txtShippingAddress.Text = result[0].ShippingAddress;
            txtShipdate.Text = DateFormater.GetDate(Convert.ToDateTime(result[0].Shipdate));
            txtUnitPrice.Text = result[0].UnitPrice.ToString();
            txtSubTotal.Text = result[0].SubTotal.ToString();
            txtTotalAmt.Text = result[0].TotalAmt.ToString();
            txtBuyRate.Text = result[0].BuyRate.ToString();
            txtBuyCost.Text = result[0].BuyCost.ToString();
            txtTax.Text = Convert.ToString(result[0].TaxPercentage);
            btnSubmit.Text = "Update";
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["ref"] !=null)
        {
            var result = (from x in dc.bric_Trade_Masters
                          where x.Id == Convert.ToInt32(Request.QueryString["ref"])
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].POrderId = txtPOrderId.Text.Trim();
                result[0].ItemDescription = txtItemDescription.Text;
                result[0].ItemCode = ddlItemCode.SelectedValue;
                if (hdnVehicleExist.Value == "false")
                {
                    AddVehicleInDatabase(txtVehicleNo.Text);
                }                
                result[0].VehicleNo = txtVehicleNo.Text;
                if (chkIsAutoCalDim() == true)
                {
                    result[0].V_length_ft = Convert.ToInt32(txtVlengthFit.Text);
                    result[0].V_length_Inc = Convert.ToInt32(txtVlengthInc.Text);
                    result[0].V_wdth_ft = Convert.ToInt32(txtVwdthFit.Text);
                    result[0].V_wdth_Inc = Convert.ToInt32(txtVwidthInc.Text);
                    result[0].V_height_ft = Convert.ToInt32(txtVheightFit.Text);
                    result[0].V_height_Inc = Convert.ToInt32(txtVheightInc.Text);
                }
                result[0].Quantity = Convert.ToInt32(txtQuantity.Text);
                result[0].ChallanNo = txtChallanNo.Text;
                result[0].SuplierId = ddlSuplier.SelectedValue;
                result[0].ShippingAddress = txtShippingAddress.Text;
                result[0].Shipdate = DateFormater.ConvertToDate(txtShipdate.Text);                
                result[0].UnitPrice = Convert.ToDecimal(txtUnitPrice.Text);
                result[0].SubTotal = Convert.ToDecimal(txtSubTotal.Text);
                result[0].TotalAmt = Convert.ToDecimal(txtTotalAmt.Text);
                result[0].BuyRate = Convert.ToDecimal(txtBuyRate.Text);
                result[0].BuyCost = Convert.ToDecimal(txtBuyCost.Text);
                result[0].TaxPercentage = Convert.ToDecimal(txtTax.Text.Trim());
                dc.SubmitChanges();
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_Trade_Master obj = new bric_Trade_Master();
            obj.POrderId = txtPOrderId.Text.Trim();
            obj.ItemDescription = txtItemDescription.Text;
            obj.ItemCode = ddlItemCode.SelectedValue;
            if (hdnVehicleExist.Value == "false")
            {
                AddVehicleInDatabase(txtVehicleNo.Text);
            }
            obj.VehicleNo = txtVehicleNo.Text;
            if (chkIsAutoCalDim() == true)
            {
                obj.V_length_ft = Convert.ToInt32(txtVlengthFit.Text);
                obj.V_length_Inc = Convert.ToInt32(txtVlengthInc.Text);
                obj.V_wdth_ft = Convert.ToInt32(txtVwdthFit.Text);
                obj.V_wdth_Inc = Convert.ToInt32(txtVwidthInc.Text);
                obj.V_height_ft = Convert.ToInt32(txtVheightFit.Text);
                obj.V_height_Inc = Convert.ToInt32(txtVheightInc.Text);
            }
            obj.ChallanNo = txtChallanNo.Text;
            obj.SuplierId = ddlSuplier.SelectedValue;
            obj.ShippingAddress = txtShippingAddress.Text;
            obj.Shipdate = DateFormater.ConvertToDate(txtShipdate.Text);
            obj.Quantity = Convert.ToInt32(txtQuantity.Text);
            obj.UnitPrice = Convert.ToDecimal(txtUnitPrice.Text);
            obj.SubTotal = Convert.ToDecimal(txtSubTotal.Text);
            obj.TaxPercentage = Convert.ToDecimal(txtTax.Text.Trim());
            obj.TotalAmt = Convert.ToDecimal(txtTotalAmt.Text);
            obj.BuyRate = Convert.ToDecimal(txtBuyRate.Text);
            obj.BuyCost = Convert.ToDecimal(txtBuyCost.Text);
            obj.CreateDate = DateFormater.ConvertToDate(DateTime.Today.ToString("dd/MM/yyyy"));
            dc.bric_Trade_Masters.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }
        Response.Redirect("TradeMaster.aspx");
    }

    private bool chkIsAutoCalDim()
    {
        bool res = (from x in dc.bric_items
                    where x.ItemCode == ddlItemCode.SelectedValue
                    select x.IsCalculateByDimenson).FirstOrDefault();
        return res;
    }

    private void AddVehicleInDatabase(string text)
    {
        bric_Vehicle obj = new bric_Vehicle();
        obj.VehicleNo = text;
        dc.bric_Vehicles.InsertOnSubmit(obj);
        dc.SubmitChanges();
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
                              where x.Id == Convert.ToInt32(Id)
                              select x).ToList();
                return result[0].ItemName;
            }
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<string> GetPurchaseOrder(string strOrderNo)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.OrderId.Contains(strOrderNo)
                          select x.OrderId).ToList();
            return result.ToList();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static bric_PurchaseOrder GetPurchaseOrderDetail(string strOrderNo)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.OrderId == strOrderNo
                          select x).ToList();
            return result[0];
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<string> GetVehicle(string strVehicleNo)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_Vehicles
                          where x.VehicleNo.Contains(strVehicleNo)
                          select x.VehicleNo).ToList();
            return result.ToList();
        }
    }


    protected void ddlItemCode_SelectedIndexChanged(object sender, EventArgs e)
    {
        DateTime dtShipDate = DateFormater.ConvertToDate(txtShipdate.Text);
        var res = (from obj in dc.bric_PO_Items
                   join i in dc.bric_items on obj.ItemCode equals i.ItemCode
                   where obj.POId == Convert.ToInt32(hdnPoId.Value) && obj.ItemCode == ddlItemCode.SelectedValue && obj.SuplierId==ddlSuplier.SelectedValue
                   && dtShipDate >= obj.RateFrom && dtShipDate <= obj.RateTo
                   select new
                   {
                       obj.ItemDes,
                       obj.BuyRate,
                       obj.SellRate,
                       i.IsCalculateByDimenson
                   }).ToList();
        if (res.Count > 0)
        {
            txtItemDescription.Text = res[0].ItemDes;
            txtBuyRate.Text = res[0].BuyRate.ToString();
            txtUnitPrice.Text = res[0].SellRate.ToString();
            txtItemDescription.Attributes.Add("readonly", "readonly");
            if (res[0].IsCalculateByDimenson == false)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>IsCalculateDim(false);</script>", false);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>IsCalculateDim(true);</script>", false);
            }
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>PageLoad();</script>", false);
    }
}