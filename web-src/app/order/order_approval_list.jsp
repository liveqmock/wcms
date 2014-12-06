<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>订单审批</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>
<style type="text/css">
	font{
		color: red;
	}
</style>
<script type="text/javascript">
	var seeStatus;
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		seeStatus = $('#seeStatus').val();
		
		$('#orderList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderAuditList?seeStatus=' + seeStatus,
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的订单' , 'warning');
					 		return;
					 	}
						
						viewOrder(data);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要审批的订单' , 'warning');
					 		return;
					 	}
						if(data.status > seeStatus){
							msgShow('提示', '该单据已审批' , 'warning');
							return;
						}
						auditOrder(data);
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要提交的订单' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							submitAudit(data, 1);	
						}else{
							msgShow('提示', '只能通过未审批的订单' , 'warning');
						}
					}
				}//,
				//{iconCls : 'icon-cancel', text : '退回', 
					//handler: function(){
						//var data = $('#orderList').datagrid('getSelected');
						//if(data==null){
					 		//msgShow('提示', '请选中需要退回的订单' , 'warning');
					 		//return;
					 	//}
						
						//if(data.status == seeStatus){
							//submitAudit(data, 0);	
						//}else{
							//msgShow('提示', '只能退回未审批的订单' , 'warning');
						//}
					//}
				//}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
			    {field:'signerId',  width:20, align:'center',
			    	formatter:function(value, rowData, rowIndex){
			    		if(rowData.status == seeStatus){
			    			return '<div style="width:10px;height:10px;background-color:yellow"></div>';
			    		}else{
			    			return '<div style="width:10px;height:10px;background-color:blue"></div>';
			    		}
			    	}
			    },    
				{field:'no',title:'订单编号',width:80},
				{field:'name',title:'订单名称',width:80},
				{field:'clientName',title:'客户名称',width:80},
				{field:'signDate',title:'签订日期',width:80, align:'center'},
				{field:'payPlace',title:'交付地址',width:80},
				{field:'payDate',title:'交付日期',width:80, align:'center'},
				{field:'total',title:'总额',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value, 2);
					}
				},
				{field:'signerName',title:'签单人',width:80},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value == 0){
							return "未提交";
						}else if(value == 10){
							return "销售部审批中";
						}else if(value == 20){
							return "财务部审批中";
						}else if(value == 30){
							return "已生效";
						}else if(value == -5555){
							return "退回";
						}	
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewOrder(rowData); 
	        },
		});
		
		var p = $('#orderList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#signerUser_search').combobox({
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$.ajax({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			type:'post',
			dataType:'json',
			success:function(data){
				data.unshift({"id":"", "text":"全部"});
				$('#signerUser_search').combobox('loadData', data);
			},
			async:true
		});
		
		$('#search-status').combobox({
			data:[{'id':0, 'text':'未审批'},{'id':1,'text':'已审批'}
			     ],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', 0);
		
		$('#search').on('click', function(){
			$('#search_signer').val($('#signerUser_search').combobox('getValue'));
			$('#search_signDateBegin').val($('#signDateBegin').datebox('getValue'));
			$('#search_signDateEnd').val($('#signDateEnd').datebox('getValue'));
			$('#search_payDateBegin').val($('#payDateBegin').datebox('getValue'));
			$('#search_payDateEnd').val($('#payDateEnd').datebox('getValue'));
			
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			var status = $('#search-status').combobox('getValue');
			queryParams.auditStatus = status;
			
			$('#orderList').datagrid('options').queryParams = queryParams;
			$('#orderList').datagrid('reload');
		});
		
		$('#viewWin').window({
            title: '订单XXXXX',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#auditWin').window({
            title: '订单XXXXX',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/order/submitAudit',
			onSubmit:function(){
				MaskUtil.mask();
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					$('#orderList').datagrid('reload');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
				}
			}
		});
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#orderId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#orderId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditWin').window('close');
		});
	});	
	
	//查看订单
	function viewOrder(data){
		$('#viewProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.id,
			title:'产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:150},
				{field:'model',title:'规格型号',width:120},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'unitName',title:'单位',width:20, align:'center'},
				{field:'unitPrice',title:'单价(元)',width:50, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value,2);
					}
				},
				{field:'total',title:'总价(元)',width:50,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value,2);
					}
				},
				{field:'remark',title:'备注',width:150}
			]]
		});
		
		$('#viewOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderAttaList?orderId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#viewOrderAtta').datagrid('getSelected');
						if(data==null){
							 msgShow('提示', '请选中需要下载的附件' , 'warning');
							 return;
						}
						window.open('<%=request.getContextPath()%>/order/downloadOrderAtta?attaId='+data.id);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'附件名称',width:80}
			]]
		});
		
		$('#viewAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=1',
			title:'审批记录',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'userDept',title:'部门',width:80},
				{field:'userName',title:'审批人',width:80},
				{field:'auditDate',title:'审批时间',width:80},
				{field:'comment',title:'审批意见',width:80},
				{field:'ioption',title:'操作',width:80, 
					formatter: function(value, rowData, rowIndex){
						return value==1?"通过":"退回";
					}
				},
			]]
		});
		
		$('#viewNo').html(data.no);
		$('#viewName').html(data.name);
		$('#viewSignerName').html(data.signerName);
		$('#viewTotal').html(fmoney(data.total, 2));
		$('#viewSignDate').html(data.signDate);
		$('#viewClientName').html(data.clientName);
		$('#viewPayPlace').html(data.payPlace);
		$('#viewPayDate').html(data.payDate);
		$('#viewWarrantee').html(data.warrantee);
		$('#viewLinkman').html(data.linkman);
		$('#viewPhone').html(data.phone);
		$('#viewRemark').html(data.remark);
		
		$('#viewWin').window({"title":"查看    订单号:"+data.no});
		$('#viewWin').window('open'); 
	}
	
	//审批订单
	function auditOrder(data){
		$('#orderId').val(data.id);
		$('#auditProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.id,
			title:'产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:150},
				{field:'model',title:'规格型号',width:120},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'unitName',title:'单位',width:20, align:'center'},
				{field:'unitPrice',title:'单价(元)',width:50, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value,2);
					}
				},
				{field:'total',title:'总价(元)',width:50,align:'right',
					formatter:function(value, rowData, rowIndex){
						return fmoney(value,2);
					}
				},
				{field:'remark',title:'备注',width:150}
			]]
		});
		
		$('#auditOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderAttaList?orderId='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#viewOrderAtta').datagrid('getSelected');
						if(data==null){
							 msgShow('提示', '请选中需要下载的附件' , 'warning');
							 return;
						}
						window.open('<%=request.getContextPath()%>/order/downloadOrderAtta?attaId='+data.id);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'fileName',title:'附件名称',width:80}
			]]
		});
		
		$('#auditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=1',
			title:'审批记录',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
				{field:'userDept',title:'部门',width:80},
				{field:'userName',title:'审批人',width:80},
				{field:'auditDate',title:'审批时间',width:80},
				{field:'comment',title:'审批意见',width:80},
				{field:'ioption',title:'操作',width:80, 
					formatter: function(value, rowData, rowIndex){
						return value==1?"通过":"退回";
					}
				},
			]]
		});
		
		$('#auditNo').html(data.no);
		$('#auditName').html(data.name);
		$('#auditSignerName').html(data.signerName);
		$('#auditTotal').html(fmoney(data.total, 2));
		$('#auditSignDate').html(data.signDate);
		$('#auditClientName').html(data.clientName);
		$('#auditPayPlace').html(data.payPlace);
		$('#auditPayDate').html(data.payDate);
		$('#auditWarrantee').html(data.warrantee);
		$('#auditLinkman').html(data.linkman);
		$('#auditPhone').html(data.phone);
		$('#auditRemark').html(data.remark);
		
		$('#auditWin').window({"title":"审批    订单号:"+data.no});
		$('#auditWin').window('open'); 
	}
	
	function submitAudit(data, option){
		data.option = option;
		data.seeStatus = seeStatus;
		$('#auditForm').form('load',data);
		$('#auditForm').submit();
	}
		
</script>
</head>
<body>
	<input type="hidden" id="seeStatus" value="${seeStatus}"/>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				订单号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="no" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				订单名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="name" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				客户名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="clientName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input id="signerUser_search" style="width: 150px; height: 22px;"/>
				<input type="hidden" class="queryParam" name="signer" id="search_signer">
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateBegin" name="signDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="signDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateEnd" name="signDateEnd"/>
			</td>
			<td style="text-align: right;">
				交付日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateBegin" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateBegin" name="payDateBegin"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" id="payDateEnd" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateEnd" name="payDateEnd"/>
			</td>
		</tr>
		<tr style="padding-bottom: 35px;">
			<td style="text-align: right;">
				总额：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="totalBegin" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="totalEnd" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="orderList"></table>
	
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
          <form action="#" id="viewForm"> 		  
    	  	<table style="width: 100%;">
    	  		<tr style="line-height: 30px;">
    	  			<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="viewNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="viewName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewSignerName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="viewSignDate"></td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="viewClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="viewPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="viewPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="viewWarrantee"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="viewLinkman">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="viewPhone">
						
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9" id="viewRemark"></td>
    	  		</tr>
    	  	</table>
    	  </form>
    	  <table id="viewProductList"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <table id="viewOrderAtta"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <table id="viewAuditLogList"></table>
    	  
    	  <div style="height: 10px;"></div>
  	</div>
  	
  	<div id="auditWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">
        	<input type="hidden" id="orderId"/>
          <form action="#" id="auditForm"> 		  
    	  	<table style="width: 100%;">
    	  		<tr style="line-height: 30px;">
    	  			<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="auditNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="auditName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditSignerName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="auditSignDate"></td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="auditClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="auditPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="auditPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="auditWarrantee"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="auditLinkman">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="auditPhone">
						
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9" id="auditRemark"></td>
    	  		</tr>
    	  	</table>
    	  </form>
    	  <table id="auditProductList"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <table id="auditOrderAtta"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <table id="auditLogList"></table>
    	  
    	  <table style="width: 100%;">
    	  		<tr>
    	  			<td style="width: 70%;">
    	  				<textarea rows="4" cols="110" id="auditComment"></textarea>
    	  			</td>
    	  			<td style="text-align: left;width: 30%;">
    	  				<a id="audit-pass" class="easyui-linkbutton" iconCls="icon-ok">通过</a>
    	  				<a id="audit-cancel" class="easyui-linkbutton" iconCls="icon-cancel">退回</a>
    	  			</td>
    	  		</tr>
    	  </table>
  	</div>
  	
  	<form action="#" id="auditForm" method="post">
  		<input type="hidden" name="id"/>
  		<input type="hidden" name="option"/>
  		<input type="hidden" name="seeStatus"/>
  		<input type="hidden" name="comment"/>
  	</form>
</body>
</html>