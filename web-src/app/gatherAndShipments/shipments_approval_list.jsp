<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>发货申请单审批</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	var seeStatus;

	$(function(){
		seeStatus = $('#seeStatus').val();
		
		$('.datebox').datebox({
			editable:false
		});
		
		$('#shipmentsList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsAuditList?seeStatus=' + seeStatus,
			title:'发货申请单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#shipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewShipment(data);
					}
				},
				{iconCls : 'icon-search', text : '审批', 
					handler: function(){
						var data = $('#shipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要审批的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							auditShipment(data);	
						}else{
							msgShow('提示', '只能审批未审批的数据' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '通过', 
					handler: function(){
						var data = $('#shipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == seeStatus){
							submitAudit(data, 1);
						}else{
							msgShow('提示', '只能审批未审批的订单' , 'warning');
						}
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id',  width:20, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == seeStatus){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.status > seeStatus){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},      
				{field:'code',title:'发货申请单编号',width:80},
				{field:'orderNo',title:'订单编号',width:80},
				{field:'applyUserName',title:'申请人',width:80},
				{field:'applyDate',title:'申请日期',width:80},
				{field:'shipmentsDate',title:'发货日期',width:80},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value==seeStatus){
							return "未审批";
						}else if(value>seeStatus){
							return "已审批";
						}
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewShipmentsList(); 
	        },
		});
		
		var p = $('#shipmentsList').datagrid('getPager'); 
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
			data:[{'id':0,'text':'未审批'},
			      {'id':1,'text':'已审批'}
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
			if(status != -1){
				queryParams.auditStatus = status;	
			}
			
			$('#shipmentsList').datagrid('options').queryParams = queryParams;
			$('#shipmentsList').datagrid('reload');
		});
		
		$('#audit-pass').on('click', function(){
			var data = {"id":$('#auditShipmentId').val()};
			if(!strIsNull($('#auditComment').val())){
				data.comment = $('#auditComment').val();
			}else{
				data.comment = "";
			}
			submitAudit(data, 1);
			$('#auditShipmentsWin').window('close');
		});
		
		$('#audit-cancel').on('click', function(){
			var data = {"id":$('#auditShipmentId').val()};
			
			if(strIsNull($('#auditComment').val())){
				msgShow('提示', '退回必须填写原因' , 'warning');
				return;
			}
			data.comment = $('#auditComment').val();
			submitAudit(data, 0);
			$('#auditShipmentsWin').window('close');
		});
		
		$('#auditForm').form({
			url:'<%=request.getContextPath()%>/gather/submitShipmentAudit',
			onSubmit:function(){
				
			},
			success:function(data){
				var data = eval('(' + data + ')');
				MaskUtil.unmask();
				if(data.flag){
					$('#shipmentsList').datagrid('reload');
					$(this).form('reset');
					msgShow('提示', '提交成功' , 'info');
				}else{
					msgShow('提示', '提交失败' , 'error');
				}
			}
		});
		
		$('#viewShipmentsWin').window({
			title: '查看发货申请单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
		});
		
		$('#auditShipmentsWin').window({
			title: '查看发货申请单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
		});
	});
	
	//查看发货申请单
	function viewShipment(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/getShipmentById?id='+data.id,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#viewShipmentsWin').window({'title':'发货申请单编号：' + data.code});
				
				$('#viewOrderName').html(data.orderName);
				$('#viewSignUserName').html(data.signUserName);
				$('#viewShipTotal').html(fmoney(data.total));
				$('#viewShipSignDate').html(data.signDate);
				$('#viewShipClientName').html(data.clientName);
				$('#viewPayPlace').html(data.payPlace);
				$('#viewPayDate').html(data.payDate);
				$('#viewWarnDate').html(data.warningDate);
				
				$('#viewShipApplyUser').html(data.applyUserName);
				$('#viewShipApplyDate').html(data.applyDate);
				$('#viewShipShipmentDate').html(data.shipmentsDate);
				$('#viewShipRemark').html(data.remark);
			},
			async:false
		});
		
		$('#viewShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + data.id,
			title:'发货产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'orderDetailName',title:'产品名称',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unit',title:'单位',width:80}
			]]
		});
		
		$('#viewOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsAttaList?id='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downShipmentsAtta(data);
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
		
		$('#viewShipmentAuditList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=5',
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
		
		$('#viewShipmentsWin').window('open');
	}
	
	//审批发货申请单
	function auditShipment(data){
		$('#auditShipmentId').val(data.id);
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/getShipmentById?id='+data.id,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#auditShipmentsWin').window({'title':'发货申请单编号：' + data.code});
				
				$('#auditOrderName').html(data.orderName);
				$('#auditSignUserName').html(data.signUserName);
				$('#auditShipTotal').html(fmoney(data.total));
				$('#auditShipSignDate').html(data.signDate);
				$('#auditShipClientName').html(data.clientName);
				$('#auditPayPlace').html(data.payPlace);
				$('#auditPayDate').html(data.payDate);
				$('#auditWarnDate').html(data.warningDate);
				
				$('#auditShipApplyUser').html(data.applyUserName);
				$('#auditShipApplyDate').html(data.applyDate);
				$('#auditShipShipmentDate').html(data.shipmentsDate);
				$('#auditShipRemark').html(data.remark);
				
				$('#auditGatherTotal').html(fmoney(data.gatherTotal));
				$('#auditUnGatherTotal').html(fmoney(data.orderTotal - data.gatherTotal));
			},
			async:false
		});
		
		$('#auditShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + data.id,
			title:'发货产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'orderDetailName',title:'产品名称',width:80},
				{field:'amount',title:'数量',width:80},
				{field:'unit',title:'单位',width:80}
			]]
		});
		
		$('#auditGatherList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getGathersByOrder?orderId=' + data.orderId,
			title:'收款单清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'id',width:10, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == 0){
							return '<div style="width:10px;height:10px;background-color:red"></div>';	
						}else if(rowData.status==30){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}else if(rowData.status==-5555){
							return '<div style="width:10px;height:10px;background-color:red"></div>';
						}else{
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}
					}
				},      
				{field:'code',title:'收款单编号',width:80},
				{field:'total',title:'收款金额',width:80, align:'right', 
					formatter:function(value, rowData, rowIndex){
						return fmoney(value);
					}	
				},
				{field:'gatherDate',title:'收款日期',width:80, align:'center'},
				{field:'realname',title:'收款人',width:80},
				{field:'status',title:'状态',width:80, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(value == 0){
							return '未提交';	
						}else if(value == 30){
							return '已生效';
						}else if(value==-5555){
							return '退回';
						}else{
							return '审批中';
						}
					}
				}
			]]
		});
		
		$('#auditOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsAttaList?id='+data.id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downShipmentsAtta(data);
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
		
		$('#auditShipmentAuditList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=5',
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
		
		$('#auditShipmentsWin').window('open');
	}
	
	//提交审批信息
	function submitAudit(data, option){
		MaskUtil.mask();
		data.seeStatus = $('#seeStatus').val();
		$('#auditForm').form('load', data);
		$('#auditOption').val(option);
		$('#auditForm').submit();
	}
</script>
</head>
<body>
	<input type="hidden" id="seeStatus" value="${seeStatus}">
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				订单号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="queryParam" name="orderNo"/>
			</td>
			<td style="text-align: right;">
				订单名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="orderName" style="width: 75%; height: 17px;"/>
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
				<input type="hidden" class="queryParam" name="signUser" id="search_signer">
			</td>
		</tr>
		<tr>
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
		<tr>
			<td style="text-align: right;">
				总额(元)：
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
				<input id="search-status" style="width: 150px; height: 22px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="shipmentsList"></table>
	
	<div id="viewShipmentsWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
		<table style="width: 100%;">
	  		<tr>
	  			<td style="width: 8%; text-align: right;">订单名称：</td>
	  			<td style="width: 15%; text-align: left;" id="viewOrderName"></td>
	  		
	  			<td style="width: 8%; text-align: right;">签单人：</td>
	  			<td style="width: 8%; text-align: left;" id="viewSignUserName"></td>
	  		
	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
	  			<td style="width: 8%; text-align: left;" id="viewShipTotal"></td>
	  		
	  			<td style="width: 8%; text-align: right;">签订日期：</td>
	  			<td style="width: 8%; text-align: left;" id="viewShipSignDate"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">客户名称：</td>
	  			<td style="text-align: left;" id="viewShipClientName"></td>
	  		
	  			<td style="text-align: right;">交付地址：</td>
	  			<td style="text-align: left;" id="viewPayPlace"></td>
	  		
	  			<td style="text-align: right;">交付日期：</td>
	  			<td style="text-align: left;" id="viewPayDate"></td>
	  		
	  			<td style="text-align: right;">质保期：</td>
	  			<td style="text-align: left;" id="viewWarnDate"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">申请人：</td>
	  			<td style="text-align: left;" id="viewShipApplyUser"></td>
	  		
	  			<td style="text-align: right;">申请日期：</td>
	  			<td style="text-align: left;" id="viewShipApplyDate"></td>
	  		
	  			<td style="text-align: right;">发货日期：</td>
	  			<td style="text-align: left;" id="viewShipShipmentDate"></td>
	  		
	  			<td style="text-align: right;"></td>
	  			<td style="text-align: left;"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">备注：</td>
	  			<td style="text-align: left;" colspan="9" id="viewShipRemark"></td>
	  		</tr>
	  	</table>
	  
	  	<table id="viewShipmentList"></table>
	  
	  	<div style="height: 10px;"></div>
	  
	  	<table id="viewOrderAtta"></table>
	  	
	  	<div style="height: 10px;"></div>
	  	
	  	<table id="viewShipmentAuditList"></table>
  	</div>
  	
  	<div id="auditShipmentsWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
		<table style="width: 100%;">
	  		<tr>
	  			<td style="width: 8%; text-align: right;">订单名称：</td>
	  			<td style="width: 15%; text-align: left;" id="auditOrderName"></td>
	  		
	  			<td style="width: 8%; text-align: right;">签单人：</td>
	  			<td style="width: 8%; text-align: left;" id="auditSignUserName"></td>
	  		
	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
	  			<td style="width: 8%; text-align: left;" id="auditShipTotal"></td>
	  		
	  			<td style="width: 8%; text-align: right;">签订日期：</td>
	  			<td style="width: 8%; text-align: left;" id="auditShipSignDate"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">客户名称：</td>
	  			<td style="text-align: left;" id="auditShipClientName"></td>
	  		
	  			<td style="text-align: right;">交付地址：</td>
	  			<td style="text-align: left;" id="auditPayPlace"></td>
	  		
	  			<td style="text-align: right;">交付日期：</td>
	  			<td style="text-align: left;" id="auditPayDate"></td>
	  		
	  			<td style="text-align: right;">质保期：</td>
	  			<td style="text-align: left;" id="auditWarnDate"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">申请人：</td>
	  			<td style="text-align: left;" id="auditShipApplyUser"></td>
	  		
	  			<td style="text-align: right;">申请日期：</td>
	  			<td style="text-align: left;" id="auditShipApplyDate"></td>
	  		
	  			<td style="text-align: right;">发货日期：</td>
	  			<td style="text-align: left;" id="auditShipShipmentDate"></td>
	  		
	  			<td style="text-align: right;"></td>
	  			<td style="text-align: left;"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">已收款：</td>
	  			<td style="text-align: left;" id="auditGatherTotal"></td>
	  		
	  			<td style="text-align: right;">未收款：</td>
	  			<td style="text-align: left;" id="auditUnGatherTotal"></td>
	  		
	  			<td style="text-align: right;">发货日期：</td>
	  			<td style="text-align: left;" id="auditShipShipmentDate"></td>
	  		
	  			<td style="text-align: right;"></td>
	  			<td style="text-align: left;"></td>
	  		</tr>
	  		<tr>
	  			<td style="text-align: right;">备注：</td>
	  			<td style="text-align: left;" colspan="9" id="auditShipRemark"></td>
	  		</tr>
	  	</table>
	  
	  	<table id="auditShipmentList"></table>
	  	
	  	<div style="height: 10px;"></div>
	  
	  	<table id="auditGatherList"></table>
	  	
	  	<div style="height: 10px;"></div>
	  
	  	<table id="auditOrderAtta"></table>
	  	
	  	<div style="height: 10px;"></div>
	  	
	  	<table id="auditShipmentAuditList"></table>
	  	
	  	<form action="#" id="auditForm" method="post">
	   		<input type="hidden" name="id">
	   		<input type="hidden" id="auditOption" name="option">
	   		<input type="hidden" name="seeStatus">
	   		<input type="hidden" name="comment">
   		</form>
   		
   		<div style="height: 10px;"></div>
    	  
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
    	<input type="hidden" id="auditShipmentId">
  	</div>
</body>
</html>