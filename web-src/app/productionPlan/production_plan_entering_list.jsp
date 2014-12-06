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

<script type="text/javascript">
	$(function(){
		$('.datebox').datebox({
			editable:false
		});
		
		$('#productionPlanList').datagrid({
			url: '<%=request.getContextPath()%>/producPlan/getProducPlanList',
			title: '生产计划列表',
			toolbar:[
				{iconCls : 'icon-search', text : '查看', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						viewProductPlan(data);
					}
				},
				{iconCls : 'icon-print', text : '导出', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要查看的数据' , 'warning');
					 		return;
					 	}
						
						printProductPlan(data);
					}
				},
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#productionPlanList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						if(data.status == 0 || data.status == -5555){
							editProductPlan(data);	
						}else{
							msgShow('提示', '只能编辑未提交或退回的生产计划' , 'warning');
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
			    {field:'id', title:'',width:10, 
			    	formatter:function(value, rowData, rowIndex){
			    		if(rowData.status == 0 || rowData.status == -5555){
			    			return '<div style="width:10px;height:10px;background-color:red"></div>';	
			    		}else if(rowData.status == 10 || rowData.status == 20 || rowData.status == 25){
			    			return '<div style="width:10px;height:10px;background-color:yellow"></div>';
			    		}else if(rowData.status == 30){
			    			return '<div style="width:10px;height:10px;background-color:blue"></div>';
			    		}
			    	}
			    },
				{field:'order',title:'合同编号',width:80,
					formatter:function(value, rowData, rowIndex){
						return value.no;		
					}
				},
				{field:'clientName',title:'客户名称',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.clientName;
					}
				},
				{field:'linkman',title:'联系人',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.linkman;
					}
				},
				{field:'phone',title:'联系电话',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.phone;
					}
				},
				{field:'signDate',title:'签订日期',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.signDate;
					}
				},
				{field:'deliveryDate',title:'交货日期',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.payDate;
					}
				},
				{field:'signName',title:'签单人',width:80,
					formatter:function(value, rowData, rowIndex){
						return rowData.order.signerName;
					}
				},
				{field:'status',title:'状态',width:80,
					formatter:function(value, rowData, rowIndex){
						if(value == 0){
							return "未提交";
						}else if(value == 10){
							return "销售部审批中";
						}else if(value == 20){
							return "技术部审批中";
						}else if(value == 25){
							return "采购部审批中";
						}else if(value == 30){
							return "已生效";
						}else if(value == -5555){
							return "退回";
						}
					}
				}
			]],
			onDblClickRow:function(rowIndex, rowData) {  
				viewProductionPlan(); 
	        },
		});
		
		var p = $('#productionPlanList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
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
            title: '编辑',
            width: 1000,
            modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:50
        });
		
		$('#editProductWin').window({
			title: '编辑',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		$('#editProForm').form({
			url:'<%=request.getContextPath()%>/producPlan/saveTechParam',
			onSubmit:function(){
				
				return $(this).form('validate');
			},
			success:function(data){
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#editProductWin').window('close');
					$('#editProductList').datagrid('reload');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#edit-pro-save').on('click', function(){
			$('#editProForm').submit();
		});
		
		$('#submit').on('click', function(){
			var data = {'id':$('#editId').val()};
			submitProducPlan(data);
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
			data:[{'id':'-1', 'text':'全部'},{'id':-5555,'text':'退回'},
			      {'id':0,'text':'未提交'},{'id':10,'text':'销售部审批中'},{'id':20,'text':'技术部审批中'},
			      {'id':25,'text':'采购部审批中'},{'id':30,'text':'已生效'}
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
			
			$('#productionPlanList').datagrid('options').queryParams = queryParams;
			$('#productionPlanList').datagrid('reload');
		});
	});
	
	function editProductPlan(data){
		$('#editNo').html(data.order.no);
		$('#editName').html(data.order.name);
		$('#editSignerName').html(data.order.signerName);
		$('#editTotal').html(fmoney(data.order.total, 2));
		$('#editSignDate').html(data.order.signDate);
		$('#editClientName').html(data.order.clientName);
		$('#editPayPlace').html(data.order.payPlace);
		$('#editPayDate').html(data.order.payDate);
		$('#editWarrantee').html(data.order.warrantee);
		$('#editLinkman').html(data.order.linkman);
		$('#editPhone').html(data.order.phone);
		$('#editRemark').html(data.order.remark);
		$('#editId').val(data.id);
		
		$('#editProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.order.id,
			title:'产品清单',
			toolbar:[
				{iconCls : 'icon-edit', text : '编辑', 
					handler: function(){
						var data = $('#editProductList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
					 		return;
					 	}
						
						$('#editProId').val(data.id);
						$('#editProName').html(data.name);
						$('#editQuantity').html(data.quantity);
						$('#editTechnicalParam').val(data.technicalParam);
						
						$('#editProductWin').window('open');
					}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:70},
				{field:'model',title:'型号',width:80},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'technicalParam',title:'技术参数',width:150, editor:'String'}
			]]
		});
		
		$('#editWin').window('open');
	}
	
	function viewProductPlan(data){
		$('#viewNo').html(data.order.no);
		$('#viewName').html(data.order.name);
		$('#viewSignerName').html(data.order.signerName);
		$('#viewTotal').html(fmoney(data.order.total, 2));
		$('#viewSignDate').html(data.order.signDate);
		$('#viewClientName').html(data.order.clientName);
		$('#viewPayPlace').html(data.order.payPlace);
		$('#viewPayDate').html(data.order.payDate);
		$('#viewWarrantee').html(data.order.warrantee);
		$('#viewLinkman').html(data.order.linkman);
		$('#viewPhone').html(data.order.phone);
		$('#viewRemark').html(data.order.remark);
		
		$('#viewProductList').datagrid({
			url: '<%=request.getContextPath()%>/order/getOrderDetailList?orderId='+data.order.id,
			title:'产品清单',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			columns:[[
				{field:'name',title:'产品名称',width:150},
				{field:'quantity',title:'数量',width:20, align:'right'},
				{field:'technicalParam',title:'技术参数',width:150}
			]]
		});
		
		$('#viewAuditLogList').datagrid({
			url: '<%=request.getContextPath()%>/audit/getAuditList?id='+data.id+'&type=2',
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
		
		$('#viewWin').window('open');
	}
	
	function submitProducPlan(data){
		MaskUtil.mask();
		$.ajax({
			url:"<%=request.getContextPath()%>/producPlan/submitProducPlan?id=" + data.id,
			type:"post",
			dataType:"json",
			success:function(data, textStatus){
				MaskUtil.unmask();
				if(data.flag){
					msgShow('提示','提交成功','info');
					$('#productionPlanList').datagrid('reload');
					$('#editWin').window('close');
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
	
	//导出
	function printProductPlan(data){
		window.location = "<%=request.getContextPath()%>/producPlan/printProductPlan?id=" + data.id;
	}
</script>
</head>
<body>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				合同编号：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="orderNo" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				客户名称：
			</td>
			<td style="text-align: left;">
				<input class="queryParam" name="clientName" style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status" style="width: 150px; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search-auditStatus" name="auditStatus">
			</td>
			<td style="text-align: right;">
				签单人：
			</td>
			<td style="text-align: left;">
				<input id="signerUser_search" style="width: 150px; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signer" name="signer">
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				签订日期：
			</td>
			<td style="text-align: left;">
				<input id="signDateBegin" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateBegin" name="signDateBegin">
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input id="signDateEnd" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_signDateEnd" name="signDateEnd">
			</td>
			<td style="text-align: right;">
				交货日期：
			</td>
			<td style="text-align: left;">
				<input id="payDateBegin" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateBegin" name="payDateBegin">
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input id="payDateEnd" class="easyui-datebox" style="width: 155%; height: 23px;"/>
				<input type="hidden" class="queryParam" id="search_payDateEnd" name="payDateEnd">
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: left;">
				
			</td>
			<td style="text-align: left;">
				
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
	<table id="productionPlanList">
	</table>
	<div id="viewWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-search">  
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
    	  
    	<table id="viewProductList"></table>
    	  
    	<div style="height: 10px;"></div>
    	
    	<table id="viewAuditLogList"></table>
  	</div>
  	
  	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">  
    	<form action="#" method="post" id="editForm">
    		<input id="editId" type="hidden"/>
   			<table style="width: 100%;">
    	  		<tr style="line-height: 30px;">
    	  			<td style="width: 8%; text-align: right;">订单号：</td>
    	  			<td style="width: 15%; text-align: left;" id="editNo"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">订单名称：</td>
    	  			<td style="width: 15%; text-align: left;" id="editName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签单人：</td>
    	  			<td style="width: 8%; text-align: left;" id="editSignerName"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">总金额(元)：</td>
    	  			<td style="width: 8%; text-align: left;" id="editTotal"></td>
    	  		
    	  			<td style="width: 8%; text-align: right;">签订日期：</td>
    	  			<td style="width: 8%; text-align: left;" id="editSignDate"></td>
    	  		</tr>
    	  		<tr style="line-height: 30px;">
    	  			<td style="text-align: right;">客户名称：</td>
    	  			<td style="text-align: left;" id="editClientName"></td>
    	  		
    	  			<td style="text-align: right;">交付地址：</td>
    	  			<td style="text-align: left;" id="editPayPlace"></td>
    	  		
    	  			<td style="text-align: right;">交付日期：</td>
    	  			<td style="text-align: left;" id="editPayDate"></td>
    	  		
    	  			<td style="text-align: right;">质保期：</td>
    	  			<td style="text-align: left;" id="editWarrantee"></td>
    	  		</tr>
    	  		<tr style="line-height: 25px;">
    	  			<td style="text-align: right;">联系人：</td>
    	  			<td style="text-align: left;" id="editLinkman">
    	  				
    	  			</td>
    	  		
    	  			<td style="text-align: right;">联系电话：</td>
    	  			<td style="text-align: left;" id="editPhone">
						
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
    	  			<td style="text-align: left;" colspan="9" id="editRemark"></td>
    	  		</tr>
    	  	</table>
    	  
    	  	<table id="editProductList"></table>
    	  
    	  	<div style="height: 10px;"></div>
    	  
    	  	<table id="addOrderAtta"></table>
    	  
    	  	<table style="width: 100%;">
    	  		<tr>
    	  			<td style="text-align: center;">
    	  				<a id="submit" class="easyui-linkbutton" iconCls="icon-ok">提交</a>
    	  			</td>
    	  		</tr>
    		</table>
    	</form>
  	</div>
  	
  	<div id="editProductWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
       	<div align="center" style="margin:20px;">
       		<form id="editProForm" method="post">
       			<input type="hidden" name="id" id="editProId">
           		<table width="100%" border="0"  align="center" >
           			<tr style="line-height: 40px;">
               			<td width="60">产品名称：</td>
               			<td id="editProName">
               				
               			</td>
           			</tr>
           			
           			<tr style="line-height: 40px;">
               			<td>数量：</td>
               			<td id="editQuantity">
               			</td>
           			</tr>
           			
             		<tr>
               			<td>技术参数：</td>
               			<td>
               				<textarea id="editTechnicalParam" name="technicalParam" rows="8" cols="40" class="easyui-validatebox" required="true"></textarea>
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
</body>
</html>