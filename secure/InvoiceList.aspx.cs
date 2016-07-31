using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_InvoiceList : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadData();
            BindGrid();
        }
    }

    private void BindGrid()
    {
        var result = (from x in dc.bric_InvoiceMsts
                      orderby x.Id descending
                      select new
                      {
                          x.Id,
                          x.InvoiceNo,
                          InvoiceDate = DateFormater.GetDate(x.InvoiceDate),
                          x.SalesPerson,
                          Client = GetClient(x.Id)
                      }).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }

    private void LoadData()
    {
        var seting = (from x in dc.bric_Settings
                      select x).FirstOrDefault();
        if (seting != null)
        {
            lblCompanyName.Text = seting.Name;
            imgCompanyLogo.Src = "~/Images/" + seting.CompanyLogo;
            lblAddresLine1.InnerText = seting.RegAddressLine1;
            lblAddresLine2.InnerText = seting.RegAddressLine2;
            lblCompanyPhone.InnerText = "Phone : " + seting.PhoneNumber;
            lblTinCst.InnerText = seting.TinCstNo;
        }       
    }

    private object GetClient(int id)
    {
        var result = (from x in dc.bric_InvoiceItems
                      join t in dc.bric_Trade_Masters on x.TradeId equals t.Id
                      join po in dc.bric_PurchaseOrders on t.POrderId equals po.OrderId
                      where x.InvoiceId == id
                      select po.CustomerId).Distinct().ToList();

        return String.Join(",", result.ToArray());
    }

    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "edit")
        {
            Response.Redirect("~/secure/PrintStatement.aspx?ref=" + e.CommandArgument);
        }

        if (e.CommandName == "view")
        {
            int iInvId = Convert.ToInt32(e.CommandArgument);

            var invoiceResult = (from obj in dc.bric_InvoiceMsts
                                 where obj.Id == iInvId
                                 select obj).ToList();
            if(invoiceResult.Count>0)
            {
                lblInvNumber.InnerText = invoiceResult[0].InvoiceNo;
                lblInvDate.InnerText = DateFormater.GetDate(invoiceResult[0].InvoiceDate);
                lblSalesPerson.Text = invoiceResult[0].SalesPerson;
                //lblCommnetInstruction.InnerText = invoiceResult[0].Remark;
            }

            var Item = (from x in dc.GET_INVOICE_ITEM(iInvId)
                        select new
                        {
                            x.POrderId,
                            x.Quantity,
                            ItemDescription= x.ItemDescription,
                            x.SubTotal,
                            x.UnitPrice,
                            TaxPercentage= (invoiceResult[0].IsCash==true?0:x.TaxPercentage),                            
                        }).ToList();

           var resultn = Item.GroupBy(l => new { l.ItemDescription,l.UnitPrice })
                            .Select(cl => new 
                            {
                                ItemDescription = cl.First().ItemDescription,
                                Quantity = cl.Sum(c => c.Quantity).ToString(),
                                SubTotal = cl.Sum(c => c.SubTotal).ToString(),
                                UnitPrice = cl.First().UnitPrice,
                            }).ToList();

            rptItem.DataSource = resultn;
            rptItem.DataBind();
            if (Item.Count > 0)
            {
                var s = (from k in Item select k.POrderId).Distinct().ToList();
                lblPoNumber.Text = String.Join(",", s);

                decimal dTaxPercent =Convert.ToDecimal(Item[0].TaxPercentage);
                decimal dSubtotal = (decimal)(from x in Item select x.SubTotal).Sum();
                decimal dShiping = 0;
                decimal Salestax = GetTaxAmount(dSubtotal, dTaxPercent);
                decimal dTotalDue = dSubtotal + dShiping + Salestax;

                lblVatPercent.InnerText = dTaxPercent.ToString() + " %";
                lblSubTotal.Text = dSubtotal.ToString();                
                lblSalesTax.Text = Salestax.ToString("0.00");                
                lblShippingCharge.Text = dShiping.ToString("0.00");
                lblTotalDue.Text = dTotalDue.ToString("0.00");
               
                lblInWord.InnerText = NumbersToWords(Convert.ToInt32(dTotalDue)) + " Only.";
            }


            var bill = (from x in dc.bric_Trade_Masters
                        join c in dc.bric_PurchaseOrders on x.POrderId equals c.OrderId
                        join t in dc.bric_customers on c.CustomerId equals t.CustomerId
                        where x.POrderId == Item[0].POrderId && x.IsInvoiceGenerate == true
                        select new {
                            t.CustomerName,
                            t.ContactPerson,
                            t.customerAddress,
                            t.MobileNo,
                            t.TINNo,
                            x.ShippingAddress
                        }).FirstOrDefault();
            if (bill != null)
            {
               // lblToName.InnerText = bill.ContactPerson;
                lblToCompanyName.InnerText = bill.CustomerName;
                lblToAddresLine1.InnerText = bill.customerAddress;
                lblToPhone.InnerText = bill.MobileNo;
                lblPurTin.Text = bill.TINNo;

                var shipad = (from a in dc.bric_CustomerSites
                              where a.SiteAddress == bill.ShippingAddress
                              select a).FirstOrDefault();
                if (shipad != null)
                {
                  //  lblShipToName.InnerText = shipad.ContactPerson;
                    lblShipToCompanyName.InnerText = bill.CustomerName;
                    lblShipToAddresLine1.InnerText = shipad.SiteAddress;
                    lblShipToPhone.InnerText = shipad.MobileNo;
                }
            }                       
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
        }       
    }
    private Decimal GetTaxAmount(decimal? SubTotal, decimal? taxPercentage)
    {
        return Convert.ToDecimal((SubTotal * taxPercentage) / 100);
    }

    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    protected void grid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        e.NewEditIndex = -1;
    }

    protected void grid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grid.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    public static string NumbersToWords(Int32 inputNumber)
    {
        int inputNo = inputNumber;

        if (inputNo == 0)
            return "Zero";

        int[] numbers = new int[4];
        int first = 0;
        int u, h, t;
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        if (inputNo < 0)
        {
            sb.Append("Minus ");
            inputNo = -inputNo;
        }

        string[] words0 = {"" ,"One ", "Two ", "Three ", "Four ",
            "Five " ,"Six ", "Seven ", "Eight ", "Nine "};
        string[] words1 = {"Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ",
            "Fifteen ","Sixteen ","Seventeen ","Eighteen ", "Nineteen "};
        string[] words2 = {"Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ",
            "Seventy ","Eighty ", "Ninety "};
        string[] words3 = { "Thousand ", "Lakh ", "Crore " };

        numbers[0] = inputNo % 1000; // units
        numbers[1] = inputNo / 1000;
        numbers[2] = inputNo / 100000;
        numbers[1] = numbers[1] - 100 * numbers[2]; // thousands
        numbers[3] = inputNo / 10000000; // crores
        numbers[2] = numbers[2] - 100 * numbers[3]; // lakhs

        for (int i = 3; i > 0; i--)
        {
            if (numbers[i] != 0)
            {
                first = i;
                break;
            }
        }
        for (int i = first; i >= 0; i--)
        {
            if (numbers[i] == 0) continue;
            u = numbers[i] % 10; // ones
            t = numbers[i] / 10;
            h = numbers[i] / 100; // hundreds
            t = t - 10 * h; // tens
            if (h > 0) sb.Append(words0[h] + "Hundred ");
            if (u > 0 || t > 0)
            {
                if (h > 0 || i == 0) sb.Append("and ");
                if (t == 0)
                    sb.Append(words0[u]);
                else if (t == 1)
                    sb.Append(words1[u]);
                else
                    sb.Append(words2[t - 2] + words0[u]);
            }
            if (i != 0) sb.Append(words3[i - 1]);
        }
        return sb.ToString().TrimEnd();
    }
}