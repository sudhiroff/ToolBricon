<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="AddTrade.aspx.cs" Inherits="secure_AddTrade" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">
    $(document).ready(function () {
        PageLoad();
    });

    function PageLoad() {
        datepicker();
        $("#<%=txtShippingAddress.ClientID%>").attr('readonly', 'true');
        $("#<%=txtBuyCost.ClientID%>").attr('readonly', 'true');
        $("#<%=txtSubTotal.ClientID%>").attr('readonly', 'true');
        $("#<%=txtTax.ClientID%>").attr('readonly', 'true');
         $("#<%=txtTotalAmt.ClientID%>").attr('readonly', 'true');

        $('.calc').on('blur', function () {
            CalcQuantity();
        });

        $('#<%=txtBuyRate.ClientID %>').on('blur', function () {
            CalcCost();
        });

        $('#<%=txtQuantity.ClientID %>').on('blur', function () {
            if ($('#<%=txtQuantity.ClientID %>').val() != "") {
                CalcCost();
                CalcSubTotal();
                caltax();
            }
        });

        $('#<%=txtUnitPrice.ClientID %>').on('blur', function () {
            CalcSubTotal();
        });

        $('#<%=txtTax.ClientID %>').on('blur', function () {
            caltax();
        });

        $("#<%=txtPOrderId.ClientID%>").autocomplete({
            source: function (request, response) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '<%= ResolveClientUrl("~/secure/TradeMaster.aspx/GetPurchaseOrder") %>',
                    data: "{'strOrderNo':'" + document.getElementById('<%=txtPOrderId.ClientID%>').value + "'}",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        response(data.d);
                    },
                    error: function (result) {
                        //showError(result);
                        alert(result);
                    }
                });
            },
            minLength: 3,
            select: function (e, ui) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '<%= ResolveClientUrl("~/secure/TradeMaster.aspx/GetPurchaseOrderDetail") %>',
                    data: "{'strOrderNo':'" + ui.item.value + "'}",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        if (data.d != "") {
                            filldata(data.d);
                        }
                    },
                    error: function (result) {
                        //showError(result);
                        alert(result);
                    }
                });
            }
        });

          $("#<%=txtVehicleNo.ClientID%>").autocomplete({
            source: function (request, response) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '<%= ResolveClientUrl("~/secure/AddTrade.aspx/GetVehicle") %>',
                    data: "{'strVehicleNo':'" + document.getElementById('<%=txtVehicleNo.ClientID%>').value + "'}",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        response(data.d);
                    },
                    error: function (result) {
                        //showError(result);
                        alert(result);
                    }
                });
            },
            minLength: 2,
            select: function (e, ui) {
                $('#<%=hdnVehicleExist.ClientID%>').val("true");
            }
        });
    }

    function filldata(data) {
        $("#<%=txtShippingAddress.ClientID%>").val(data.ShippingAddress);    
       <%-- $("#<%=txtItemDescription.ClientID%>").val(data.ItemDescription);
        $("#<%=txtBuyRate.ClientID%>").val(data.SellRate);--%>
        $("#<%=hdnPoId.ClientID%>").val(data.Id);
        // __doPostBack('select', 'LoadItemByPO')
        //   setTimeout(__doPostBack('select', 'LoadItemByPO'), 0);
        javascript: setTimeout('__doPostBack(\'ctl00$ContentPlaceHolder1$ddlItemCode\',\'LoadItemByPO\')', 0)
    }

    function CalcQuantity() {
        var a = $("#<%=txtVlengthFit.ClientID%>").val();
        var b = $("#<%=txtVlengthInc.ClientID%>").val();
        var c = $("#<%=txtVwdthFit.ClientID%>").val();
        var d = $("#<%=txtVwidthInc.ClientID%>").val();
        var e = $("#<%=txtVheightFit.ClientID%>").val();
        var f = $("#<%=txtVheightInc.ClientID%>").val();
        if ((a != "") && (b != "") && (c != "") && (d != "") && (e != "") && (f != "")) {
            var result = ((parseInt(a) + (parseInt(b) / 12)) * (parseInt(c) + (parseInt(d) / 12)) * (parseInt(e) + (parseInt(f) / 12)));
            $("#<%=txtQuantity.ClientID%>").val(result.toFixed(0));
            $("#<%=txtQuantity.ClientID%>").attr('readonly', 'true');
            // Call all calulation method

            CalcCost();
            CalcSubTotal();
            caltax();
        }
    }

    function CalcCost() {
        var a = $('#<%=txtBuyRate.ClientID %>').val();
        var b = $('#<%=txtQuantity.ClientID %>').val();
        if ((a != "") && (b != "")) {
            var res = parseInt(a) * parseInt(b);
            $("#<%=txtBuyCost.ClientID%>").val(res.toFixed(2));
             $("#<%=txtBuyCost.ClientID%>").attr('readonly', 'true');
        }
    }
    function CalcSubTotal() {
        var a = $('#<%=txtUnitPrice.ClientID %>').val();
        var b = $('#<%=txtQuantity.ClientID %>').val();
        if ((a != "") && (b != "")) {
            var res = parseInt(a) * parseInt(b);
            $("#<%=txtSubTotal.ClientID%>").val(res.toFixed(2));
             $("#<%=txtSubTotal.ClientID%>").attr('readonly', 'true');
        }
    }

    function caltax() {
        var amount = $('#<%=txtSubTotal.ClientID %>').val();
        var tax = $('#<%=txtTax.ClientID %>').val();
        if ((amount != "") && (tax != "")) {
            var res = (parseInt(amount) * parseInt(tax)) / 100 + parseInt(amount);
            $("#<%=txtTotalAmt.ClientID%>").val(res.toFixed(2));
            $("#<%=txtTotalAmt.ClientID%>").attr('readonly', 'true');
        }
    }

    function IsCalculateDim(str) {
        if (str == false) {
            $(".calc").attr('readonly', 'true');
            $("#<%=txtQuantity.ClientID%>").removeAttr('readonly');
        } else {
            $(".calc").removeAttr('readonly');
            $("#<%=txtQuantity.ClientID%>").attr('readonly', 'true');
        }       
        PageLoad();
    }

</script>
<div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server" ChildrenAsTriggers="true">
            <ContentTemplate>   
               <div class="col-lg-12">                    
                        <div class="" role="document">
                            <div class="">
                                <div class="modal-header">                                   
                                    <h4 class="modal-title" id="myModalLabel">
                                        Trade detail</h4>
                                </div>
                                <div class="modal-body clearfix">
                                       <div class="col-md-12 clearfix">
                                           <div class="col-md-3 col-sm-6">
                                                Ship date
                                                <asp:TextBox ID="txtShipdate" CssClass="form-control datepckr" placeholder="Ship date"
                                                    runat="server" required></asp:TextBox>
                                            </div>
                                           <div class="col-md-3 col-sm-6">
                                                P.O. Number
                                                <asp:TextBox ID="txtPOrderId"  CssClass="form-control" autocomplete="on" placeholder="Purchase order id" runat="server"
                                                    required></asp:TextBox>
                                            </div>                                           
                                           <div class="col-md-3 col-sm-6">
                                                Supplier id
                                                <asp:DropDownList ID="ddlSuplier" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSuplier_SelectedIndexChanged" runat="server"></asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-md-12" style="height:15px;"></div>
                                        <div class="col-md-12 clearfix">
                                            
                                            <div class="col-md-3 col-sm-6">
                                                Item Code
                                                <asp:DropDownList ID="ddlItemCode" CssClass="form-control" runat="server" 
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlItemCode_SelectedIndexChanged">
                                                  <asp:ListItem Text="--Select--" Value="0"></asp:ListItem>
                                                 </asp:DropDownList>
                                            </div>
                                            <div class="col-md-3 col-sm-6">
                                                Item Description
                                                <asp:TextBox ID="txtItemDescription" CssClass="form-control" placeholder="Item description" runat="server"
                                                    required></asp:TextBox>
                                            </div>     
                                            <div class="col-md-3 col-sm-6">                                           
                                                Vehicle No      
                                                <asp:TextBox ID="txtVehicleNo" CssClass="form-control" autocomplete="on" placeholder="Vehicle number" runat="server">                                              
                                                </asp:TextBox>
                                                <asp:HiddenField ID="hdnVehicleExist" Value="false" runat="server" />
                                            </div>    
                                            <div class="col-md-3">
                                               Challan No.
                                                <asp:TextBox ID="txtChallanNo" CssClass="form-control" placeholder="Challan no." runat="server"
                                                    required></asp:TextBox>
                                            </div> 
                                                                              
                                        </div>
                                        <div class="col-md-12" style="height:15px;"></div>
                                        <div class="col-md-12 clearfix">
                                            <div class="col-md-3 col-sm-6">
                                                Shipping address
                                                <asp:TextBox ID="txtShippingAddress" CssClass="form-control" placeholder="Shipping address"
                                                    runat="server" required></asp:TextBox>
                                            </div>
                                            <div class="col-md-6">                                                
                                                     <div class="col-md-12 col-sm-12 clearfix" style="padding-left: 0px">
                                                            <span class="col-md-12 col-sm-12 col-xs-12" style="padding-left: 0px">Container Area (Length | Width | Height) </span>
                                                            <div class="col-md-4 col-sm-4" style="padding-left: 0px;padding-right: 0px">
                                                                <asp:TextBox ID="txtVlengthFit" CssClass="form-control col-md-6 col-sm-6 col-xs-6 calc" Style="width: 70px"
                                                                    placeholder="L Ft." runat="server" required></asp:TextBox>
                                                                <asp:TextBox ID="txtVlengthInc" CssClass="form-control col-md-4 col-sm-6 col-xs-6 calc"
                                                                    Style="width: 70px" placeholder="L In." runat="server" required></asp:TextBox>
                                                            </div>
                                                            <div class="col-md-4 col-sm-4" style="padding-left: 0px;padding-right: 0px">
                                                                <asp:TextBox ID="txtVwdthFit" CssClass="form-control col-md-6 col-sm-6 col-xs-6 calc" Style="width: 70px"
                                                                    placeholder="W Ft." runat="server" required></asp:TextBox>
                                                                <asp:TextBox ID="txtVwidthInc" CssClass="form-control col-md-4 col-sm-6 col-xs-6  calc"
                                                                    Style="width: 70px" placeholder="W In." runat="server" required></asp:TextBox>
                                                            </div>
                                                            <div class="col-md-4 col-sm-4" style="padding-left: 0px;padding-right: 0px">
                                                                <asp:TextBox ID="txtVheightFit" CssClass="form-control col-md-6 col-sm-6 col-xs-6 calc" Style="width: 70px"
                                                                    placeholder="H Ft." runat="server" required></asp:TextBox>
                                                                <asp:TextBox ID="txtVheightInc" CssClass="form-control col-md-4 col-sm-6 col-xs-6 calc"
                                                                    Style="width: 70px" placeholder="H In." runat="server" required></asp:TextBox>
                                                            </div>
                                                  </div>
                                                                                               
                                            </div>
                                            <div class="col-md-3">
                                                Quantity
                                                <asp:TextBox ID="txtQuantity" CssClass="form-control" placeholder="Quantity" runat="server"
                                                    required></asp:TextBox>
                                            </div>
                                            
                                        </div>                                        
                                        <div class="col-md-12" style="height:15px;"></div>
                                        <div class="col-md-12 clearfix">    
                                           <div class="col-md-3 col-sm-6">
                                               Sell rate
                                                <asp:TextBox ID="txtUnitPrice" CssClass="form-control" placeholder=" Unit price" runat="server"
                                                    required readonly></asp:TextBox>
                                            </div>                                      
                                            <div class="col-md-3 col-sm-6">
                                               Buy rate
                                                <asp:TextBox ID="txtBuyRate" CssClass="form-control" placeholder="Buy rate" runat="server"
                                                    required readonly></asp:TextBox>
                                            </div>
                                            <div class="col-md-3 col-sm-6">
                                               Buy cost
                                                <asp:TextBox ID="txtBuyCost" CssClass="form-control" placeholder="Buy cost" runat="server"
                                                    required></asp:TextBox>
                                            </div>                                            
                                        </div>
                                        <div class="col-md-12" style="height:15px;"></div>
                                        <div class="col-md-12 clearfix">      
                                           <div class="col-md-3 col-sm-6">
                                               Sub total
                                                <asp:TextBox ID="txtSubTotal" CssClass="form-control" placeholder="Sub total" runat="server"
                                                    required ></asp:TextBox>
                                            </div>                                  
                                            <div class="col-md-3 col-sm-6">
                                              Tax (if any).
                                                <asp:TextBox ID="txtTax" CssClass="form-control" placeholder="Tax" Text="0" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="col-md-3 col-sm-6">
                                              Total amt.
                                                <asp:TextBox ID="txtTotalAmt" CssClass="form-control" placeholder="Total amt." runat="server"
                                                    required ></asp:TextBox>
                                            </div>                                          
                                            
                                        </div>
                                        <div class="col-md-12" style="height:15px;"></div>
                                   
                                </div>
                                <div class="modal-footer clearfix">
                                    <asp:Button ID="btnClose" class="btn btn-default" runat="server" Text="Cancel" PostBackUrl="~/secure/TradeMaster.aspx" formnovalidate />
                                    <asp:Button ID="btnSubmit" class="btn btn-default" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
                                    <asp:HiddenField ID="hdnPoId" Value="0" runat="server" />
                                </div>
                            </div>
                        </div>
                </div>
                <asp:UpdateProgress ID="uppanle" runat="server">
                            <ProgressTemplate>
                                <img src="~/Images/progress.gif" style="position: absolute; top: 50%; left: 50%;" runat="server" alt="" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
            </ContentTemplate>
       </asp:UpdatePanel>
    </div>
</asp:Content>

