<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>送货单录入</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		$('#deliveryList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getDeliveryList',
			title: '送货单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#deliveryList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						viewDelivery(data);
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#deliveryList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						if(data.status == 2){
							msgShow('提示', '该条记录已生效，不能编辑' , 'warning');
							return;
						}
						editDelivery(data);
					}
				},
				{iconCls : 'icon-ok', text : '生效', 
					handler: function(){
						var data = $('#deliveryList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要生效的数据' , 'warning');
					 		return;
					 	}
						if(data.status == 2){
							msgShow('提示', '该条记录已生效' , 'warning');
							return;
						}
						effectDelivery(data);
					}
				},
				{iconCls : 'icon-print', text : '导出', 
					handler: function(){
						var data = $('#deliveryList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要导出的数据' , 'warning');
					 		return;
					 	}
						printDelivery(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id', width:10, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.status == 1 ){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else{
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},        
				{field:'code',title:'送货单编号',width:80},
				{field:'orderNo',title:'订单编号',width:80},
				{field:'clientName',title:'收货单位',width:80},
				{field:'payPlace',title:'收货地址',width:80},
				{field:'clientLinkman',title:'联系人',width:80},
				{field:'clientLinkPhone',title:'联系电话',width:80},
				{field:'shipmentDate',title:'发货日期',width:80},
				{field:'status',title:'状态',width:80, 
					formatter:function(value, rowData, rowIndex){
						if(value==1){
							return "未生效";
						}else if(value==2){
							return "已生效";
						}
					}
				}
			]]
		});
		
		var p = $('#deliveryList').datagrid('getPager'); 
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
		
		$('#edit-linkman').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=CKGLY',
			valueField:'id',
			textField:'text',
			required:true,
			editable:false
		});
		
		$('#search-status').combobox({
			data:[{"id":0, "text":'全部'}, {"id":1, "text":'未生效'}, {"id":2, "text":'已生效'}],
			valueField:"id",
			textField:"text",
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
				queryParams.status = status;	
			}
			
			$('#deliveryList').datagrid('options').queryParams = queryParams;
			$('#deliveryList').datagrid('reload');
		});
		
		$('#editForm').form({
			url:'<%=request.getContextPath()%>/gather/updateDelivery',
			onSubmit:function(){
				$('#editLinkman').val($('#edit-linkman').combobox('getValue'));
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#editWin').window('close');
					$('#deliveryList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#edit-save').on('click', function(){
			$('#editForm').submit();
		});
		
		$('#viewWin').window({
            title: '查看',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#editWin').window({
            title: '编辑送货单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
	});
	
	//编辑送货单
	function editDelivery(data){
		$('#editDeliveryId').val(data.id);
		
		$('#editDeliveryNo').html(data.code);
		$('#editOrderNo').html(data.orderNo);
		$('#editClientName').html(data.clientName);
		$('#editPayPlace').html(data.payPlace);
		$('#editClientLinkmanName').html(data.clientLinkman);
		$('#editClientPhone').html(data.clientLinkPhone);
		
		$('#editForm').form('load', data);
		
		$('#editShipmentDate').datebox('setValue', data.shipmentDate);
		if(data.linkman != 0){
			$('#edit-linkman').combobox('select', data.linkman);
		}
		
		$('#viewShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + data.shipmentId,
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
		
		$('#editWin').window('open');
	}
	
	function effectDelivery(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/effectDelivery?id=' + data.id,
			type:'post',
			dataType:'json',
			success:function(data){
				if(data.flag){
					msgShow('提示','生效成功','info');
					$('#deliveryList').datagrid('reload');
				}else{
					msgShow('提示','生效失败','error');
				}
			},
			async:true
		});
	}
	
	//查看
	function viewDelivery(data){
		$('#viewDeliveryNo').html(data.code);
		$('#viewOrderNo').html(data.orderNo);
		$('#viewClientName').html(data.clientName);
		$('#viewPayPlace').html(data.payPlace);
		$('#viewClientLinkmanName').html(data.clientLinkman);
		$('#viewClientPhone').html(data.clientLinkPhone);
		
		$('#viewShipmentDate').html(data.shipmentDate);
		$('#viewLinkman').html(data.linkmanName);
		$('#viewPhone').html(data.phone);
		$('#viewFox').html(data.fox);
		$('#viewMobile').html(data.mobile);
		$('#viewRemark').html(data.remark);
		
		$('#viewViewShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + data.shipmentId,
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
		
		$('#viewWin').window('open');
	}
	
	//导出
	function printDelivery(data){
		window.location = "<%=request.getContextPath()%>/gather/printDelivery?id=" + data.id;
	}
</script>
</head>
<body>
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
	<table id="deliveryList">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
   	  <table style="width: 100%;">
   	  		<tr style="line-height: 25px;">
   	  			<td style="width: 8%; text-align: right;">送货单编号：</td>
   	  			<td style="width: 15%; text-align: left;" id="viewDeliveryNo"></td>
   	  		
   	  			<td style="width: 10%; text-align: right;">订单编号：</td>
   	  			<td style="width: 8%; text-align: left;" id="viewOrderNo"></td>
   	  		
   	  			<td style="width: 8%; text-align: right;">收货单位：</td>
   	  			<td style="width: 8%; text-align: left;" id="viewClientName"></td>
   	  		
   	  			<td style="width: 8%; text-align: right;">收货地址：</td>
   	  			<td style="width: 8%; text-align: left;" id="viewPayPlace"></td>
   	  		</tr>
   	  		<tr style="line-height: 25px;">
   	  			<td style="text-align: right;">客户联系人：</td>
   	  			<td style="text-align: left;" id="viewClientLinkmanName"></td>
   	  		
   	  			<td style="text-align: right;">客户联系电话：</td>
   	  			<td style="text-align: left;" id="viewClientPhone"></td>
   	  		
   	  			<td style="text-align: right;">发货日期：</td>
   	  			<td style="text-align: left;" id="viewShipmentDate"></td>
   	  		
   	  			<td style="text-align: right;"></td>
   	  			<td style="text-align: left;"></td>
   	  		</tr>
   	  		<tr>
   	  			<td style="text-align: right;">联系人：</td>
   	  			<td style="text-align: left;" id="viewLinkman"></td>
   	  				
   	  			<td style="text-align: right;">联系电话：</td>
   	  			<td style="text-align: left;" id="viewPhone"></td>
   	  		
   	  			<td style="text-align: right;">传真：</td>
   	  			<td style="text-align: left;" id="viewFox"></td>
   	  		
   	  			<td style="text-align: right;">手机：</td>
   	  			<td style="text-align: left;" id="viewMobile"></td>
   	  		</tr>
   	  		<tr style="line-height: 25px;">
   	  			<td style="text-align: right;">备注：</td>
   	  			<td style="text-align: left;" colspan="9" id="viewRemark"></td>
   	  		</tr>
   	  	</table>
   	  
   	  	<div style="height: 10px;"></div>
   	  	<table id="viewViewShipmentList"></table>
  	</div>
  	
  	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">  
    	<form action="#" id="editForm" method="post">
    		<input type="hidden" name="id" id="editDeliveryId"/>
   			<table style="width: 100%;">
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">送货单编号：</td>
    	  			<td style="width: 15%; text-align: left;" id="editDeliveryNo"></td>
    	  		
    	  			<td style="width: 10%; text-align: right;">订单编号：</td>
    	  			<td style="width: 8%; text-align: left;" id="editOrderNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">收货单位：</td>
    	  			<td style="width: 8%; text-align: left;" id="editClientName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">收货地址：</td>
    	  			<td style="width: 8%; text-align: left;" id="editPayPlace"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">客户联系人：</td>
    	  			<td style="text-align: left;" id="editClientLinkmanName"></td>
    	  		
    	  			<td style="text-align: right;">客户联系电话：</td>
    	  			<td style="text-align: left;" id="editClientPhone"></td>
    	  		
    	  			<td style="text-align: right;">发货日期：</td>
    	  			<td style="text-align: left;">
    	  				<input class="datebox" required="true" id="editShipmentDate" name="shipmentDate" class="easyui-validatebox"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;"></td>
    	  		</tr>
    	  		<tr>
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;">
    	  				<input id="edit-linkman">
    	  				<input type="hidden" id="editLinkman" name="linkman">
    	  			</td>
    	  				
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="editPhone">
    	  				<input id="editPhone" name="phone" class="easyui-validatebox" required="true"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">传真：</td>
    	  			<td style="text-align: left;">
    	  				<input type="text" id="editFox" name="fox" class="easyui-validatebox" required="true"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">手机：</td>
    	  			<td style="text-align: left;">
    	  				<input id="editMobile" name="mobile" class="easyui-validatebox" required="true"/>
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea style="width:600px; height:40px; margin:5px;" name="remark"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  
    	  	<div style="height: 10px;"></div>
    	  	<table id="viewShipmentList"></table>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
</body>
</html>