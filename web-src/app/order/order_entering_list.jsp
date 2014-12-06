<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>订单录入</title>
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
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		$('#orderList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderList',
			toolbar:[
			   {iconCls : 'icon-add', text : '新增', 
					handler: function(){
						addOrder();
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == 0 || data.status == -5555){
							editOrder(data);	
						}else{
							msgShow('提示', '只能编辑未提交或退回的订单' , 'warning');
						}
					}
				},
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewOrder(data);
					}
				},
				{iconCls : 'icon-ok', text : '提交', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要提交的数据' , 'warning');
					 		return;
					 	}
						submitOrder(data);
					}
				},
				{iconCls : 'icon-remove', text : '删除', 
					handler: function(){
						var data = $('#orderList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == 0 || data.status == -5555){
							deleteOrder(data);	
						}else{
							msgShow('提示', '只能删除未提交或退回的订单' , 'warning');
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
			    {field:'signerId',  width:20, align:'center',
			    	formatter:function(value, rowData, rowIndex){
			    		if(rowData.status == 0 || rowData.status == -5555){
			    			return '<div style="width:10px;height:10px;background-color:red"></div>';	
			    		}else if(rowData.status == 10 || rowData.status == 20){
			    			return '<div style="width:10px;height:10px;background-color:yellow"></div>';
			    		}else if(rowData.status == 30){
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
		
		$('.signerUser').combobox({
			url:'<%=request.getContextPath()%>/user/getUsersByRole?roleCode=YWY',
			valueField:'id',
			textField:'text',
			editable:false,
			required:true
		});
		
		$('.add-datebox').datebox({
			editable:false,
			required:true
		});
		
		$('#edit_unit').combobox({
			url:'<%=request.getContextPath()%>/sys/getAllUnit',
			valueField:'id',
			textField:'name',
			editable:false,
			required:true
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
		
		$('#addWin').window({
            title: '新增订单',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 350,
            top:0,
            left:50
        });
		
		$('#editWin').window({
            title: '编辑订单',
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
		
		$('#editProductWin').window({
			title: '编辑产品',
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
		
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/order/saveOrder',
			onSubmit:function(){
				$('#add_signerId').val($('#signerUser_add').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					$('#addWin').window('close');
					$('#orderList').datagrid('reload');
					editOrder(data.data);
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
		});
		
		$('#editForm').form({
			url:'<%=request.getContextPath()%>/order/updateOrder',
			onSubmit:function(){
				$('#edit_signerId').val($('#signerUser_edit').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#orderList').datagrid('reload');
					$('#editWin').window('close');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#edit-save').on('click', function(){
			$('#edit-save').submit();
		});
		
		$('#addProForm').form({
			url:'<%=request.getContextPath()%>/order/saveOrderDetail',
			onSubmit:function(){
				$('#proUnitId').val($('#add_unit').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addProductList').datagrid('reload');
					$('#addProductWin').window('close');
					$('#addProForm').form('reset');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-pro-save').on('click', function(){
			$('#addProForm').submit();
		});
		
		$('#editProForm').form({
			url:'<%=request.getContextPath()%>/order/updateOrderDetail',
			onSubmit:function(){
				$('#editProUnitId').val($('#edit_unit').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','更新成功','info');
					$('#addProductList').datagrid('reload');
					$('#editProductWin').window('close');
					$(this).form('reset');
				}else{
					msgShow('提示','更新失败','error');
				}
			}
		});
		
		$('#edit-pro-save').on('click', function(){
			$('#editProForm').submit();
		});
		
		$('#attaForm').form({
			url:'<%=request.getContextPath()%>/order/addAtta',
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
		
		$('#search-status').combobox({
			data:[{'id':'-1', 'text':'全部'},{'id':-5555,'text':'退回'},
			      {'id':0,'text':'未提交'},{'id':10,'text':'销售部审批中'},{'id':20,'text':'财务部审批中'},
			      {'id':30,'text':'已生效'}
			     ],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		$('#search-status').combobox('select', -1);
		
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
	
	//编辑订单
	function editOrder(data){
		
		$('#editWin').window({"title":"编辑    订单号:"+data.no});
		
		$('#addProOrderId').val(data.id);
		$('#atta_orderId').val(data.id);
		
		$('#editForm').form('load', data);
		
		$('#signerUser_edit').combobox('select', data.signerId);
		
		$('#addProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.id,
			title:'产品清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加产品', 
					handler: function(){
						addProduct();
					}
				},
				{iconCls : 'icon-edit', text : '编辑产品', 
					handler: function(){
						var data = $('#addProductList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						$('#edit_unit').combobox('select', data.unitId);
						
						$('#editProForm').form('load', data);
						$('#editProductWin').window('open');
					}
				},
				{iconCls : 'icon-remove', text : '删除产品', 
					handler: function(){
						var data = $('#addProductList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						$.ajax({
		        			url:"<%=request.getContextPath()%>/order/deleteOrderDetail?detailId=" + data.id,
		    				type:"post",
		    				data:$('#addForm').serialize(),
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#addProductList').datagrid('reload');
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
				}
			],
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
		
		$('#addOrderAtta').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderAttaList?orderId='+data.id,
			title:'附件清单',
			toolbar:[
			    {iconCls : 'icon-add', text : '添加附件', 
					handler: function(){
						addAtta();
					}
				},
				{iconCls : 'icon-ok', text : '下载附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要下载的附件' , 'warning');
					 		return;
					 	}
						window.open('<%=request.getContextPath()%>/order/downloadOrderAtta?attaId='+data.id);
					}
				},
				{iconCls : 'icon-remove', text : '删除附件', 
					handler: function(){
						var data = $('#addOrderAtta').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的附件' , 'warning');
					 		return;
					 	}
						MaskUtil.mask();
						$.ajax({
		        			url:"<%=request.getContextPath()%>/order/deleteOrderAtta?attaId=" + data.id,
		    				type:"post",
		    				dataType:"json",
		    				success:function(data, textStatus){
		    					MaskUtil.unmask();
		    					if(data.flag){
		    						msgShow('提示','删除成功','info');
		    						$('#addOrderAtta').datagrid('reload');
		    					}else{
		    						msgShow('提示','删除失败','error');
		    					}
		    				},
		    				error:function(){
		    					MaskUtil.unmask();
		    					msgShow('提示', '删除失败' , 'error');
		    				},
		    				async:false
		        		});
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
		
		$('#editWin').window('center');
		$('#editWin').window('open'); 
	}
	
	function addOrder(){
		$('#addWin').window('center');
		$('#addWin').window('open');
	}
	
	//添加产品
	function addProduct(){
		$('#add_unit').combobox({
			url:'<%=request.getContextPath()%>/sys/getAllUnit',
			valueField:'id',
			textField:'name',
			editable:false,
			required:true
		});
		$('#addProductWin').window('open');
	}
	
	//添加附件
	function addAtta(){
		$('#addAttaWin').window('open');
	}
	
	function submitOrder(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/order/submitOrder?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#orderList').datagrid('reload');
				}else{
					msgShow('提示','提交失败','error');
				}
			},
			error:function(){
				MaskUtil.unmask();
				msgShow('提示', '提交失败' , 'error');
			},
			async:false
		});
	}
	
	function deleteOrder(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/order/deleteOrder?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#orderList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			error:function(){
				MaskUtil.unmask();
				msgShow('提示', '删除失败' , 'error');
			},
			async:false
		});
	}
</script>
</head>
<body>
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
	<table id="orderList">
	</table>
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
  	
  	<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" method="post" id="addForm">
    		<input type="hidden" id="addId" value="-1"/>
   			<table style="width: 100%;">
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input name="name" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input class="signerUser" id="signerUser_add" style="width: 130px;"/>
    	  				<input type="hidden" name="signerId" id="add_signerId"/>
    	  				<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="total" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="signDate" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;">
    	  				<input name="clientName" class="easyui-validatebox" required="true" 
    	  					style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;">
						<input name="payPlace" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
					</td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="payDate" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="warrantee" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;">
    	  				<input name="linkman" class="easyui-validatebox" required="true" 
    	  					style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;">
						<input name="phone" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea name="remark" style="width:600px; height:80px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="add-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	
  	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">  
    	<form action="#" method="post" id="editForm">
    		<input type="hidden" name="id" id="editOrderId"/>
   			<table style="width: 100%;">
    	  		<tr style="line-height: 25px;">
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;">
    	  				<input name="name" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input class="signerUser" id="signerUser_edit" style="width: 130px;"/>
    	  				<input type="hidden" name="signerId" id="edit_signerId"/>
    	  				<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="total" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;">
    	  				<input name="signDate" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;">
    	  				<input name="clientName" class="easyui-validatebox" required="true" 
    	  					style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;">
						<input name="payPlace" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
					</td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="payDate" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;">
    	  				<input name="warrantee" class="add-datebox"
    	  					style="width: 130px; height: 22px;">
                		<font>*</font>
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;">
    	  				<input name="linkman" class="easyui-validatebox" required="true" 
    	  					style="width: 85%;">
                		<font>*</font>
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;">
						<input name="phone" class="easyui-validatebox" required="true" style="width: 85%;">
                		<font>*</font>
					</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;"></td>
    	  			<td style="text-align: left;">
    	  				
    	  			</td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">备注：</td>
    	  			<td style="text-align: left;" colspan="9">
    	  				<textarea name="remark" style="width:600px; height:80px; margin:5px;"></textarea>
    	  			</td>
    	  		</tr>
    	  	</table>
    	  
    	  	<table id="addProductList"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="addOrderAtta"></table>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	
  	<div id="addProductWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">添加产品</h1>
       	<div align="center" style="margin:20px;">
       		<form id="addProForm" method="post">
       			<input type="hidden" name="orderId" id="addProOrderId">
           		<table width="300" border="0"  align="center" >
           			<tr>
               			<td width="60">产品名称：</td>
               			<td>
               				<input name="name" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>规格型号：</td>
               			<td>
               				<input name="model" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td>数量：</td>
               			<td>
               				<input name="quantity" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单位：</td>
               			<td>
               				<input id="add_unit" style="width: 200px;">
               				<input type="hidden" id="proUnitId" name="unitId">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单价：</td>
               			<td>
               				<input name="unitPrice" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>总价：</td>
               			<td>
               				<input name="total" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>备注：</td>
               			<td>
               				<textarea name="remark"  style="width:200px; height:120px; margin:5px;"></textarea>
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a id="add-pro-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="editProductWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
  		<h1 align="center" style="color:#15428B;">编辑</h1>
       	<div align="center" style="margin:20px;">
       		<form id="editProForm" method="post">
       			<input type="hidden" name="id" >
           		<table width="300" border="0"  align="center" >
           			<tr>
               			<td width="60">产品名称：</td>
               			<td>
               				<input name="name" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>规格型号：</td>
               			<td>
               				<input name="model" style="width: 200px;">
               			</td>
           			</tr>
           			<tr>
               			<td>数量：</td>
               			<td>
               				<input name="quantity" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单位：</td>
               			<td>
               				<input id="edit_unit" style="width: 200px;">
               				<input type="hidden" id="editProUnitId" name="unitId">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>单价：</td>
               			<td>
               				<input name="unitPrice" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>总价：</td>
               			<td>
               				<input name="total" class="easyui-validatebox" required="true" style="width: 200px;">
               				<font>*</font>
               			</td>
           			</tr>
           			<tr>
               			<td>备注：</td>
               			<td>
               				<textarea name="remark"  style="width:200px; height:120px; margin:5px;"></textarea>
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a id="edit-pro-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
	
	<div id="addAttaWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        <div style="height: 40px;"></div>
        <form action="#" id="attaForm" method="post" enctype="multipart/form-data">
        	<input type="hidden" id="atta_orderId" name="orderId"/>
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