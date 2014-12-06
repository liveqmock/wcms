<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物流情况录入</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		$(".datebox").datebox({
			editable:false
		});
		
		$('#deliveryList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getDeliveryList',
			title: '送货单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看物流情况', 
					handler: function(){
						var data = $('#deliveryList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						viewLogistics(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'code',title:'送货单编号',width:80},
				{field:'orderNo',title:'订单编号',width:80},
				{field:'clientName',title:'收货单位',width:80},
				{field:'payPlace',title:'收货地址',width:80},
				{field:'clientLinkman',title:'联系人',width:80},
				{field:'clientLinkPhone',title:'联系电话',width:80},
				{field:'shipmentDate',title:'发货日期',width:80}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewLogistics(); 
	        },
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
			
			$('#deliveryList').datagrid('options').queryParams = queryParams;
			$('#deliveryList').datagrid('reload');
		});
		
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/gather/addLogistics',
			onSubmit:function(){
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
					$('#addWin').window('close');
					$('#viewLogisticsList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
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
		
		$('#addWin').window({
			title: '添加产品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
	});
	
	//查看物流情况
	function viewLogistics(data){
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
		
		$('#viewLogisticsList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getLogisticsList?deliveryId=' + data.id,
			title:'物流情况',
			toolbar:[{iconCls : 'icon-add', text : '新增', 
				handler: function(){
					addLogistics(data.id);
				}
			}],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'createTimeStr',title:'时间',width:80},
				{field:'place',title:'地点',width:80},
				{field:'createUserName',title:'录入人',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		$('#viewWin').window('open'); 
	}
	
	//添加物流情况
	function addLogistics(id){
		$('#addDeliveryId').val(id);
		$('#addWin').window('open');
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
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="deliveryList"></table>
	
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
   	  	<table id="viewLogisticsList"></table>
  	</div>
  	
  	<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
   		<form id="addForm" method="post">
   			<input name="deliveryId" id="addDeliveryId" type="hidden">
       		<table width="350" border="0"  align="center" >
       			<tr>
           			<td width="100" style="text-align: right;">到达地点：</td>
           			<td>
           				<input class="easyui-validatebox" required="true" style="width: 200px;" name="place">
           			</td>
       			</tr>
       			
       			<tr style="line-height: 30px;">
       				<td style="text-align: right;">备注：</td>
       				<td>
       					<textarea rows="4" cols="30" name="remark"></textarea>
       				</td>
       			</tr>
         				
       			<tr>
           			<td style="text-align: center;" colspan="2">
           				<a class="easyui-linkbutton" iconCls="icon-save" id="add-save">保存</a>
           			</td>
       			</tr>
       		</table>
   		</form>
	</div>
</body>
</html>