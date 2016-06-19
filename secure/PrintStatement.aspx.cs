using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_PrintStatement : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request.QueryString["ref"] != null)
            {
                ShowStatement(Convert.ToInt32(Request.QueryString["ref"]));
            }
       }
    }

    private void ShowStatement(int Id)
    {
        int iInvId = Id;

        var invoiceResult = (from obj in dc.bric_InvoiceMsts
                             where obj.Id == iInvId
                             select obj).ToList();
        if (invoiceResult.Count > 0)
        {
            
        }

        var Item = (from x in dc.GET_INVOICE_ITEM(iInvId)
                    select new
                    {
                        x.POrderId,
                        x.Quantity,
                        ItemDescription = x.ItemDescription,
                        x.SubTotal,
                        x.UnitPrice,
                        TaxPercentage = (invoiceResult[0].IsCash == true ? 0 : x.TaxPercentage),
                        x.VehicleNo,
                        TaxAmount = (invoiceResult[0].IsCash == true ? 0 : GetTaxAmount(x.SubTotal, x.TaxPercentage)),
                        x.ChallanNo,
                        Shipdate=x.Shipdate,
                        Dimension = x.V_length_ft + "*" + x.V_length_Inc + " &nbsp;|&nbsp; " + x.V_wdth_ft + "*" + x.V_wdth_Inc + " &nbsp;|&nbsp; " + x.V_height_ft + "*" + x.V_height_Inc,
                    }).ToList();
        rptItem.DataSource = Item;
        rptItem.DataBind();
        if (Item.Count > 0)
        {
            var s = (from k in Item select k.POrderId).Distinct().ToList();
        }        
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
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
    private Decimal GetTaxAmount(decimal? SubTotal, decimal? taxPercentage)
    {
        return Convert.ToDecimal((SubTotal * taxPercentage) / 100);
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