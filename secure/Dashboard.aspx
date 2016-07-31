<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Main.master" AutoEventWireup="true"
    CodeFile="Dashboard.aspx.cs" Inherits="secure_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '<%= ResolveClientUrl("~/secure/Dashboard.aspx/TradeInvChart") %>',
                    data: "",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        LoadChart(data.d);
                    },
                    error: function (result) {
                        //showError(result);
                        alert(result);
                    }
                });

            function LoadChart(d) {
                Morris.Bar({
                    element: 'morris-bar-chart',
                    data: d,
                    xkey: 'Month',
                    ykeys: ['Trdae', 'Inv'],
                    labels: ['Trade', 'Invoice'],
                    hideHover: 'auto',
                    resize: true
                });
                var htm = "";
                for (var i = 0; i < d.length; i++) {
                    htm += ' <tr><td>' + parseInt(i + 1) + ' </td><td> ' + d[i].Month + '</td><td> ' + d[i].Trdae + '</td><td>' + d[i].Inv + '</td></tr>'
                }
                $('#datah').html(htm);
            }            
        })
    </script>
    <div class="row">
        <div class="col-lg-12">
            <h1 class="page-header">
                Dashboard</h1>
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-3 col-md-6">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-tasks fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right" id="lblInvoice" runat="server">
                            <div class="huge">
                                26</div>
                            <div>
                                New Comments!</div>
                        </div>
                    </div>
                </div>
                <a href="#">
                    <div class="panel-footer">
                        <span class="pull-left">View Details</span> <span class="pull-right"><i class="fa fa-arrow-circle-right">
                        </i></span>
                        <div class="clearfix">
                        </div>
                    </div>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="panel panel-green">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-tasks fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right" id="lblTrade" runat="server">
                            <div class="huge">
                                12</div>
                            <div>
                                New Tasks!</div>
                        </div>
                    </div>
                </div>
                <a href="#">
                    <div class="panel-footer">
                        <span class="pull-left">View Details</span> <span class="pull-right"><i class="fa fa-arrow-circle-right">
                        </i></span>
                        <div class="clearfix">
                        </div>
                    </div>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="panel panel-yellow">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-tasks fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right" id="lblRate" runat="server">
                            <div class="huge">
                                124</div>
                            <div>
                                New Orders!</div>
                        </div>
                    </div>
                </div>
                <a href="#">
                    <div class="panel-footer">
                        <span class="pull-left">View Details</span> <span class="pull-right"><i class="fa fa-arrow-circle-right">
                        </i></span>
                        <div class="clearfix">
                        </div>
                    </div>
                </a>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="panel panel-red">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-3">
                            <i class="fa fa-tasks fa-5x"></i>
                        </div>
                        <div class="col-xs-9 text-right" id="lblSup" runat="server">
                            <div class="huge">
                                13</div>
                            <div>
                                Support Tickets!</div>
                        </div>
                    </div>
                </div>
                <a href="#">
                    <div class="panel-footer">
                        <span class="pull-left">View Details</span> <span class="pull-right"><i class="fa fa-arrow-circle-right">
                        </i></span>
                        <div class="clearfix">
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <!-- /.row -->
    <div class="row">
        <div class="col-lg-8">
            <!-- /.panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-bar-chart-o fa-fw"></i>Bar Chart (Trade & Invoice per month)
                    <%--<div class="pull-right">
                        <div class="btn-group">
                            <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                Actions <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu pull-right" role="menu">
                                <li><a href="#">Action</a> </li>
                                <li><a href="#">Another action</a> </li>
                                <li><a href="#">Something else here</a> </li>
                                <li class="divider"></li>
                                <li><a href="#">Separated link</a> </li>
                            </ul>
                        </div>
                    </div>--%>
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-striped">
                                    <thead>
                                        <tr>
                                            <th>
                                                #
                                            </th>
                                            <th>
                                                Month
                                            </th>
                                            <th>
                                                 Trade
                                            </th>
                                            <th>
                                                 Invoice
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="datah">
                                        
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.table-responsive -->
                        </div>
                        <!-- /.col-lg-4 (nested) -->
                        <div class="col-lg-8">
                            <div id="morris-bar-chart">
                            </div>
                        </div>
                        <!-- /.col-lg-8 (nested) -->
                    </div>
                    <!-- /.row -->
                </div>
                <!-- /.panel-body -->
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-bar-chart-o fa-fw"></i>Area Chart Example
                    <div class="pull-right">
                        <div class="btn-group">
                            <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                Actions <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu pull-right" role="menu">
                                <li><a href="#">Action</a> </li>
                                <li><a href="#">Another action</a> </li>
                                <li><a href="#">Something else here</a> </li>
                                <li class="divider"></li>
                                <li><a href="#">Separated link</a> </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <div id="morris-area-chart">
                    </div>
                </div>
                <!-- /.panel-body -->
            </div>           
            
            <!-- /.panel -->
        </div>
        <!-- /.col-lg-8 -->
        <div class="col-lg-4">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-bar-chart-o fa-fw"></i>Donut Chart Example
                </div>
                <div class="panel-body">
                    <div id="morris-donut-chart">
                    </div>
                    <a href="#" class="btn btn-default btn-block">View Details</a>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-bell fa-fw"></i>Notifications Panel
                </div>
                <!-- /.panel-heading -->
                <div class="panel-body">
                    <div class="list-group">
                        <a href="#" class="list-group-item"><i class="fa fa-comment fa-fw"></i>New Comment <span
                            class="pull-right text-muted small"><em>4 minutes ago</em> </span></a><a href="#"
                                class="list-group-item"><i class="fa fa-twitter fa-fw"></i>3 New Followers <span
                                    class="pull-right text-muted small"><em>12 minutes ago</em> </span></a>
                        <a href="#" class="list-group-item"><i class="fa fa-envelope fa-fw"></i>Message Sent
                            <span class="pull-right text-muted small"><em>27 minutes ago</em> </span></a>
                        <a href="#" class="list-group-item"><i class="fa fa-tasks fa-fw"></i>New Task <span
                            class="pull-right text-muted small"><em>43 minutes ago</em> </span></a><a href="#"
                                class="list-group-item"><i class="fa fa-upload fa-fw"></i>Server Rebooted <span class="pull-right text-muted small">
                                    <em>11:32 AM</em> </span></a><a href="#" class="list-group-item"><i class="fa fa-bolt fa-fw">
                                    </i>Server Crashed! <span class="pull-right text-muted small"><em>11:13 AM</em> </span>
                                    </a><a href="#" class="list-group-item"><i class="fa fa-warning fa-fw"></i>Server Not
                                        Responding <span class="pull-right text-muted small"><em>10:57 AM</em> </span>
                        </a><a href="#" class="list-group-item"><i class="fa fa-shopping-cart fa-fw"></i>New
                            Order Placed <span class="pull-right text-muted small"><em>9:49 AM</em> </span>
                        </a><a href="#" class="list-group-item"><i class="fa fa-money fa-fw"></i>Payment Received
                            <span class="pull-right text-muted small"><em>Yesterday</em> </span></a>
                    </div>
                    <!-- /.list-group -->
                    <a href="#" class="btn btn-default btn-block">View All Alerts</a>
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->          
            
            <!-- /.panel .chat-panel -->
        </div>
        <!-- /.col-lg-4 -->
    </div>
    <!-- /.row -->
</asp:Content>
