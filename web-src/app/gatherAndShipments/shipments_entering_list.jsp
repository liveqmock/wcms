<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款单审批</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	var productList;

	$(function(){
		//$(".datebox :text").attr("readonly","readonly");
		$('.datebox').datebox({
			editable:false
		});
		
		$('#orderList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipOrderList',
			title:'订单发货情况列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看发货申请单', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewShipmentsList(data);
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'orderId',  width:20, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.surplus != 0){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';	
						}else if(rowData.surplus == 0){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'orderNo',title:'订单号',width:80, align:'center'},
				{field:'clientName',title:'客户名称',width:80},
				{field:'linkman',title:'联系人',width:80},
				{field:'phone',title:'联系电话',width:80},
				{field:'payPlace',title:'收货地址',width:80},
				{field:'signUser',title:'签单人',width:80},
				{field:'surplus',title:'状态',width:80, align:'center', 
					formatter:function(value, rowData, rowIndex){
						if(value != 0){
							return "未发货完成";
						}else{
							return "已发货完成";
						}	
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewShipmentsList(rowData); 
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
		
		$('#addApplyUser').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		
		$('#search-status').combobox({
			data:[{"id":0, "text":'全部'}, {"id":1, "text":'未发货完成'}, {"id":2, "text":'已发货完成'}],
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
			
			$('#orderList').datagrid('options').queryParams = queryParams;
			$('#orderList').datagrid('reload');
		});
		
		$('#editShipmentForm').form({
			url:'<%=request.getContextPath()%>/gather/updateShipment',
			onSubmit:function(){
				$('#addApplyUserHidden').val($('#addApplyUser').combobox('getValue'));
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
					$('#viewShipmentsList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#editShipmentSave').on('click', function(){
			$('#editShipmentForm').submit();
		});
		
		$('#addProductForm').form({
			url:'<%=request.getContextPath()%>/gather/saveShipmentsDetail',
			onSubmit:function(){
				$('#addProductList').val($('#productList').combobox('getValue'));
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
					$('#addProductWin').window('close');
					$('#addShipmentList').datagrid('reload');
					$('#addProductForm').form('reset');
					$('#orderDetailQuantity').html('');
					$('#hadAmount').html('');
					$('#surplusAmount').html('');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-product-save').on('click', function(){
			$('#addProductForm').submit();
		});
		
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/gather/addShipmentsAtta',
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
					msgShow('提示','上传成功','info');
					$('#attaForm').form('reset');
					$('#addOrderAtta').datagrid('reload');
					$('#addAttaWin').window('close');
				}else{
					msgShow('提示','上传失败','error');
				}
			}
		});
		
		$('#atta_upload').on('click', function(){
			$('#attaForm').submit();
		});
		
		$('#viewWin').window({
            title: '查看发货申请单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
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
		
		$('#addWin').window({
            title: '新增发货申请单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#addProductWin').window({
			title: '添加产品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#addAttaWin').window({
			title: '添加附件',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 200,
            top:100,
            left:300
		});
	});
	
	//查看订单
	function viewShipmentsList(data){
		$('#addOrderId').val(data.orderId);
		//加载订单基础数据
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/getGatherOrderById?orderId='+data.orderId,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#viewOrderNo').html(data.orderNo);
				$('#viewClientName').html(data.clientName);
				$('#viewSignUser').html(data.signUser);
				$('#viewSignDate').html(data.signDate);
				$('#viewTotal').html(fmoney(data.total));
				$('#viewHadTotal').html(fmoney(data.hadTotal));
				$('#viewUnTotal').html(fmoney(data.unTotal));
				$('#viewGatherStatus').html(data.unTotal==0?"已结清":"未结清");
			},
			async:true
		});
		
		$('#viewShipmentsList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsByOrderId?orderId='+data.orderId,
			title:'发货申请单列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#viewShipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						viewShipment(data);
					}
				},
			    {iconCls : 'icon-add', text : '新增', 
					handler: function(){
						addShipment(data.orderId);
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#viewShipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						$('#addWin').window({'title':'发货申请单号：' + data.code});
						if(data.status==0 || data.status==-5555){
							editShipment(data.id);
						}else{
							msgShow('提示', '只能编辑退回和未提交状态的数据' , 'warning');
						}
					}
				},
				{iconCls : 'icon-ok', text : '提交', 
					handler: function(){
						var data = $('#viewShipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要提交的数据' , 'warning');
					 		return;
					 	}
						if(data.status==0 || data.status==-5555){
							submitShipment(data);
						}else{
							msgShow('提示', '只能提交退回和未提交状态的数据' , 'warning');
						}
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data = $('#viewShipmentsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						if(data.status==0 || data.status==-5555){
							removeShipments(data);
						}else{
							msgShow('提示', '只能删除退回和未提交状态的数据' , 'warning');
						}
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:false,
			columns:[[
			    {field:'id', width:10, align:'center',
			    	formatter:function(value, rowData, rowIndex){
			    		if(rowData.status == 0 || rowData.status == -5555){
							return '<div style="width:10px;height:10px;background-color:red"></div>';	
						}else if(rowData.status == 30){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}else{
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}
			    	}
			    },      
				{field:'code',title:'发货申请单编号',width:80},
				{field:'applyUserName',title:'申请人',width:80},
				{field:'applyDate',title:'申请日期',width:80},
				{field:'shipmentsDate',title:'发货日期',width:80},
				{field:'status',title:'状态',width:80, 
					formatter:function(value, rowData, rowIndex){
						if(value==0){
							return "未提交";
						}else if(value==10){
							return "销售部审批中";
						}else if(value==15){
							return "财务部审批中";
						}else if(value==20){
							return "生产部审批中";
						}else if(value==25){
							return "质检确认中";
						}else if(value==30){
							return "已完成";
						}else if(value==-5555){
							return "退回";
						}
					}
				}
			]]
		});
		
		$('#viewWin').window('open'); 
	}
	
	//新增发货申请单
	function addShipment(orderId){
		//创建发货申请单
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/createShipment?orderId='+orderId,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#addShipmentId').val(data.shipmentId);
				
				$('#viewShipmentsList').datagrid('reload');
				
				$('#addOrderName').html(data.name);
				$('#addSignUserName').html(data.signerName);
				$('#addTotal').html(fmoney(data.total));
				$('#addSignDate').html(data.signDate);
				$('#addClientName').html(data.clientName);
				$('#addPayPlace').html(data.payPlace);
				$('#addPayDate').html(data.payDate);
				$('#addWarnDate').html(data.warrantee);
				
				$('#addWin').window({"title":"发货申请单编号：" + data.shipCode});
			},
			async:false
		});
		
		$('#addShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + $('#addShipmentId').val(),
			title:'发货产品清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加产品', 
				 handler: 
					 function(){
						addProduct();
					}
				},
				{iconCls : 'icon-remove', text : '删除产品', 
				 handler: 
				 	function(){
					 	var data = $('#addShipmentList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						deleteProduct(data);
					}
				}
			],
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
		
		$('#addOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsAttaList?id='+$('#addShipmentId').val(),
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-add', text : '新增附件', 
					handler: function(){
						addShipmentsAtta($('#addShipmentId').val());
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downShipmentsAtta(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						
						removeShipmentsAtta(data);
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
		
		$('#addWin').window('open'); 
	}
	
	//编辑发货申请单
	function editShipment(id){
		$('#addShipmentId').val(id);
		//获取发货申请单信息
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/getShipmentById?id='+id,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#addOrderName').html(data.orderName);
				$('#addSignUserName').html(data.signUserName);
				$('#addTotal').html(fmoney(data.total));
				$('#addSignDate').html(data.signDate);
				$('#addClientName').html(data.clientName);
				$('#addPayPlace').html(data.payPlace);
				$('#addPayDate').html(data.payDate);
				$('#addWarnDate').html(data.warningDate);
				
				if(data.applyUser!=0){
					$('#addApplyUser').combobox('select', data.applyUser);
				}
				$('#addApplyDate').datebox('setValue', data.applyDate);
				$('#addShipmentDate').datebox('setValue', data.shipmentsDate);
				$('#addRemark').val(data.remark);
			},
			async:true
		});
		
		$('#addShipmentList').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsDetails?shipmentsId=' + id,
			title:'发货产品清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加产品', 
				 handler: 
					 function(){
						addProduct();
					}
				},
				{iconCls : 'icon-remove', text : '删除产品', 
				 handler: 
				 	function(){
					 	var data = $('#addShipmentList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						deleteProduct(data);
					}
				}
			],
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
		
		$('#addOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/gather/getShipmentsAttaList?id='+id,
			title:'附件清单',
			toolbar:[
				{iconCls : 'icon-add', text : '新增附件', 
					handler: function(){
						addShipmentsAtta(id);
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的数据' , 'warning');
					 		return;
					 	}
						
						downShipmentsAtta(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						
						removeShipmentsAtta(data);
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
		
		$('#addWin').window('open');
	}
	
	//添加产品
	function addProduct(){
		var shipmentsId = $('#addShipmentId').val();
		
		$('#addProductShipmentsId').val(shipmentsId);
		
		$('#productList').combobox({
			valueField:'orderDetailId',
			textField:'orderDetailName',
			editable:false,
			required:true,
			onChange:function(newValue, oldValue){
				for(i=0;i<productList.length;i++){
					var data = productList[i];
					if(data.orderDetailId == newValue){
						$('#orderDetailQuantity').html(data.orderDetailQuantity);
						$('#hadAmount').html(data.hadAmount);
						$('#surplusAmount').html(data.surplusAmount);
						break;
					}
				}
			}
		});
		
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/getOrderDetailByOrderId?orderId=' + $('#addOrderId').val(),
			type:'post',
			dataType:'json',
			success:function(data){
				productList = data;
				$('#productList').combobox('loadData',data);
			},
			async:true
		});
		
		$('#addProductWin').window('open');
	}
	
	//添加附件
	function addShipmentsAtta(id){
		$('#atta_shipmentsId').val(id);
		$('#addAttaWin').window('open');
	}
	
	function checkAmount(obj){
		if(parseFloat(obj.value) > parseFloat($('#surplusAmount').html())){
			alert("申请数量不能超过剩余数量");
			obj.value = $('#surplusAmount').html();
		}
	}
	
	//删除产品
	function deleteProduct(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/deleteShipmentsDetail?id=' + data.id,
			type:'post',
			dataType:'json',
			success:function(data){
				$('#addShipmentList').datagrid('reload');
			},
			async:true
		});
	}
	
	//下载发货申请单附件
	function downShipmentsAtta(data){
		window.location = '<%=request.getContextPath()%>/gather/downloadShipmentsAtta?id='+data.id;
	}
	
	//删除发货申请单数据
	function removeShipmentsAtta(data){
		$.ajax({
			url:"<%=request.getContextPath()%>/gather/deleteShipmentsAtta?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#addOrderAtta').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				msgShow('提示', '删除失败' , 'error');
			},
			async:false
		});
	}
	
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
	
	//删除发货申请单
	function removeShipments(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/deleteShipments?id='+data.id,
			type:'post',
			dataType:'json',
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#viewShipmentsList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				msgShow('提示', '删除失败' , 'error');
			},
			async:false
		});
	}
	
	//提交发货申请单
	function submitShipment(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/gather/submitShipments?id='+data.id,
			type:'post',
			dataType:'json',
			success:function(data, textStatus){
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#viewShipmentsList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				msgShow('提示', '提交失败' , 'error');
			},
			async:false
		});
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
	<table id="orderList">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search"> 	
        <input type="hidden" id="addOrderId"/>		 
    	  <table style="width: 100%;">
    	  	<tr style="line-height: 25px;">
    	  		<td style="width: 8%; text-align: right;">订单号：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewOrderNo"></td>
    	  		
    	  		<td style="width: 8%;text-align: right;">客户名称：</td>
    	  		<td style="width: 8%;text-align: left;" id="viewClientName"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">签单人：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewSignUser"></td>
    	  		
    	  		<td style="width: 8%; text-align: right;">签订日期：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewSignDate"></td>
    	  	</tr>
    	  	<tr style="line-height: 25px;">
    	  		<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  		<td style="width: 8%; text-align: left;" id="viewTotal"></td>
    	  		
    	  		<td style="width: 8%;text-align: right;">已收款金额(元)：</td>
    	  		<td style="width: 8%;text-align: left;" id="viewHadTotal"></td>
    	  		
    	  		<td style="width: 8%;text-align: right;">未收款金额(元)：</td>
    	  		<td style="width: 8%;text-align: left;" id="viewUnTotal"></td>
    	  		
    	  		<td style="width: 8%;text-align: right;">收款状态：</td>
    	  		<td style="width: 8%;text-align: left;" id="viewGatherStatus"></td>
    	  	</tr>
    	  </table>
    	  
    	  <table id="viewShipmentsList"></table>
    	  
    	  <div style="height: 10px;"></div>
    	  
    	  <div style="height: 10px;"></div>
  	</div>
  	
  	<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">  
    	<form id="editShipmentForm" action="#" method="post">
    		<input type="hidden" id="addShipmentId" name="id"/>
   			<table style="width: 100%;">
    	  		<tr>
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="addOrderName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="addSignUserName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="addTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="addSignDate"></td>
    	  		</tr>
    	  		<tr>
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="addClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="addPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="addPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="addWarnDate"></td>
    	  		</tr>
    	  		<tr>
    	  			<td style="text-align: right;">申请人：</td>
    	  			<td style="text-align: left;">
    	  				<input id="addApplyUser"/>
    	  				<input type="hidden" name="applyUser" id="addApplyUserHidden"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">申请日期：</td>
    	  			<td style="text-align: left;">
    	  				<input id="addApplyDate" class="datebox" required="true" name="applyDate"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">发货日期：</td>
    	  			<td style="text-align: left;">
    	  				<input id="addShipmentDate" class="datebox" required="true" name="shipmentsDate"/>
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;"></td>
    	  		</tr>
    	  		<tr>
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea id="addRemark" name="remark" required="true" style="width:600px; height:40px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  
    	  	<table id="addShipmentList"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="addOrderAtta"></table>
    	  	
    	  	<div style="height: 10px;"></div>
    	  	
    	  	<table style="width: 100%;">
    	  		<tr>
          			<td style="text-align: center;" colspan="2">
          				<a class="easyui-linkbutton" iconCls="icon-save" id="editShipmentSave">保存</a>
          			</td>
      			</tr>
    	  	</table>
    	</form>
  	</div>
  	
  	<div id="addProductWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">添加产品</h1>
       	<div align="center" style="margin:20px;">
       		<form id="addProductForm" method="post">
       			<input name="shipmentsId" id="addProductShipmentsId" type="hidden">
           		<table width="350" border="0"  align="center" >
           			<tr>
               			<td width="100">产品名称：</td>
               			<td>
               				<input style="width: 200px;" id="productList">
               				<input type="hidden" id="addProductList" name="orderDetailId">
               			</td>
           			</tr>
           			
           			<tr style="line-height: 30px;">
           				<td>订货数量：</td>
           				<td id="orderDetailQuantity"></td>
           			</tr>
           			
           			<tr style="line-height: 30px;">
           				<td>已申请发货数量：</td>
           				<td id="hadAmount"></td>
           			</tr>
           			
           			<tr style="line-height: 30px;">
           				<td>未申请发货数量：</td>
           				<td id="surplusAmount"></td>
           			</tr>
           			
           			<tr>
               			<td>本次申请数量：</td>
               			<td>
               				<input class="easyui-validatebox" required="true" style="width: 200px;"
               					validType="nums" name="amount" onblur="checkAmount(this);">
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a class="easyui-linkbutton" iconCls="icon-save" id="add-product-save">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
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
	
	<div id="addAttaWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        <div style="height: 40px;"></div>
    	<form action="#" id="attaForm" method="post" enctype="multipart/form-data">
        	<input type="hidden" id="atta_shipmentsId" name="shipmentsId"/>
    		<table style="width: 100%;">
    			<tr style="line-height: 30px;">
    				<td style="width: 100%; text-align: center;">
    					<input type="file" name="file" class="easyui-validatebox" required="true"/>
    				</td>
    			</tr>
    			<tr style="line-height: 30px;">
    				<td style="width: 100%; text-align: center;">
    					<a id="atta_upload" class="easyui-linkbutton" iconCls="icon-save">上传</a>
    				</td>
    			</tr>
    		</table>
    	</form>
    </div>
</body>
</html>